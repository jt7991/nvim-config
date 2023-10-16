local projects = {
	{ name = "ophelia-emr", path = "~/ophelia-web/client/emr" },
	{ name = "functions", path = "~/ophelia-web/server/functions" },
	{ name = "@shared/utils", path = "~/ophelia-web/shared/utils" },
	{ name = "@shared/types", path = "~/ophelia-web/shared/types" },
	{ name = "ophelia-patient", path = "~/ophelia-web/client/patient" },
}

local function getEslintEntriesForProject(project)
	local lint_output = vim.api.nvim_exec("!lerna run lint --scope=" .. project.name .. " -- -- --format=unix", true)
	local lines = vim.split(lint_output, "\n")
	local errors = {}
	for _, line in ipairs(lines) do
		local parts = vim.split(line, ":")
		print(line)
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
	return errors
end

local function getAllEslintErrors()
	local allEntries = {}
	for _, project in ipairs(projects) do
		local newEntries = getEslintEntriesForProject(project)
		for _, entry in ipairs(newEntries) do
			table.insert(allEntries, entry)
		end
	end
	return allEntries
end

local function addLintOutputToQf()
	local allEntries = getAllEslintErrors()
	vim.fn.setqflist(allEntries, "r")
	vim.api.nvim_exec("copen", true)
end

local function addTypeCheckOutputForProject(project)
	local output = vim.api.nvim_exec("!lerna run typecheck --scope=" .. project.name, true)
	local lines = vim.split(output, "\n")
	local errors = {}
	for _, line in ipairs(lines) do
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
	return errors
end

local function getAllTypeCheckErrors()
	local allEntries = {}
	for _, project in ipairs(projects) do
		local newEntries = addTypeCheckOutputForProject(project)
		for _, entry in ipairs(newEntries) do
			table.insert(allEntries, entry)
		end
	end
	return allEntries
end

local function addTypeCheckOutputToQuickfixList()
	local allEntries = getAllTypeCheckErrors()
	vim.fn.setqflist(allEntries, "r")
	vim.api.nvim_exec("copen", true)
end

local function addTypescriptDiagnosticsToQuickfix()
	local eslintEntries = getAllEslintErrors()
	local typeCheckEntries = getAllTypeCheckErrors()
	local allEntries = {}
	for _, entry in ipairs(eslintEntries) do
		table.insert(allEntries, entry)
	end

	for _, entry in ipairs(typeCheckEntries) do
		table.insert(allEntries, entry)
	end
	vim.fn.setqflist(allEntries, "r")
	vim.api.nvim_exec("copen", true)
end

return {
	addLintOutputToQf = addLintOutputToQf,
	addTypeCheckOutputToQuickfixList = addTypeCheckOutputToQuickfixList,
	addTypescriptDiagnosticsToQuickfix = addTypescriptDiagnosticsToQuickfix,
}
