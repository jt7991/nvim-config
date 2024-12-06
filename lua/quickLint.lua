local projects = {
	{ name = "orbit",           path = "~/finni/packages/fotivity" },
	{ name = "backend",         path = "~/finni/packages/backend" },
	{ name = "mission-control", path = "~/finni/packages/mission-control" },
	{ name = "den",             path = "~/finni/packages/den" },
}

local function getEslintEntriesForProject(project)
	local on_text = function(_, data, _)
		local errors = {}
		for _, line in ipairs(data) do
			local parts = vim.split(line, ":")
			if #parts > 1 and line:match("Error") then
				local file = parts[1]
				local line_number = parts[2]
				local col = parts[3]
				table.insert(errors, {
					text = parts[4],
					filename = file,
					lnum = line_number,
					col = col,
				})
			end
		end
		vim.fn.setqflist(errors, "a")
	end
	print("Executing lerna run lint --scope=" .. project.name)
	local job_id = vim.fn.jobstart("lerna run lint --scope='" .. project.name .. "' -- -- --format=unix --quiet", {
		on_stderr = on_text,
		on_stdout = on_text,
		on_exit = function(_, data, _)
			print("Finished lint for " .. project.name)
		end,
	})
	return job_id
end

local function getAllEslintErrors()
	local jobs = {}
	for _, project in ipairs(projects) do
		local job_id = getEslintEntriesForProject(project)
		table.insert(jobs, job_id)
	end
	return jobs
end

local function addLintOutputToQf()
	local jobs = getAllEslintErrors()
	vim.fn.jobwait(jobs, -1)
	vim.api.nvim_exec("copen", true)
end

local function addTypeCheckOutputForProject(project)
	print("Executing lerna run typecheck --scope=" .. project.name)
	local job_id = vim.fn.jobstart("lerna run typecheck --scope=" .. project.name, {
		on_stderr = function(_, data, _)
			local errors = {}
			for _, line in ipairs(data) do
				local parts = vim.split(line, "%(")
				if #parts > 1 then
					local parts2 = vim.split(parts[2], "%)")
					local colRowParts = vim.split(parts2[1], ",")
					local file = parts[1]
					local line_number = colRowParts[1]
					local col = colRowParts[2]
					table.insert(errors, {
						text = parts2[2],
						filename = vim.fn.expand(project.path) .. "/" .. file,
						lnum = line_number,
						col = col,
					})
				end
			end
			vim.fn.setqflist(errors, "a")
		end,
		on_exit = function(_, data, _)
			print("Finished typecheck for " .. project.name)
		end,
	})
	return job_id
end

local function getAllTypeCheckErrors()
	local jobs = {}
	for _, project in ipairs(projects) do
		local job_id = addTypeCheckOutputForProject(project)
		table.insert(jobs, job_id)
	end
	return jobs
end

local function addTypeCheckOutputToQuickfixList()
	local jobs = getAllTypeCheckErrors()

	vim.fn.jobwait(jobs, -1)
	-- open quickfix window once the above async jobs are done
	vim.api.nvim_exec("copen", true)
end

local function addTypescriptDiagnosticsToQuickfix()
	local jobs1 = getAllEslintErrors()
	local jobs2 = getAllTypeCheckErrors()
	vim.fn.jobwait(jobs1, -1)
	vim.fn.jobwait(jobs2, -1)
	vim.api.nvim_exec("copen", true)
end

return {
	addLintOutputToQf = addLintOutputToQf,
	addTypeCheckOutputToQuickfixList = addTypeCheckOutputToQuickfixList,
	addTypescriptDiagnosticsToQuickfix = addTypescriptDiagnosticsToQuickfix,
}
