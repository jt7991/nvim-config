local get_review_threads_for_current_pr = function(pr_info_table)
	local graphQLQuery = [[{
	repository(owner: "]] .. pr_info_table.owner_name .. [[", name: "]] .. pr_info_table.repo_name .. [[") {
	    pullRequest(number:]] .. pr_info_table.pr_number .. [[) {
	        reviewThreads(first: 100) {
		    edges {
		      node {
                        id
                        line
			path
                        comments(first: 100) {
                          edges {
                            node {
                              bodyText
                            }
                          }
                        }
                     }
                   }
                }
              }
           }
         }]]
	local comments = vim.fn.systemlist("gh api graphql --paginate -f query='" .. graphQLQuery .. "'")
	local comment_table = vim.fn.json_decode(comments[1])
	local review_threads = comment_table.data.repository.pullRequest.reviewThreads.edges
	print(vim.inspect(review_threads))
	return review_threads
end

local get_current_pr_repo_and_owner = function()
	local current_pr = vim.fn.systemlist("gh pr view --json number")
	local pr_table = vim.fn.json_decode(current_pr[1])
	local pr_number = pr_table.number
	local current_pr_repo_and_owner =
		vim.fn.json_decode(vim.fn.systemlist("gh pr view --json headRepository,headRepositoryOwner")[1])
	if current_pr_repo_and_owner == nil then
		print("No PR found")
		return
	end
	return {
		repo_name = current_pr_repo_and_owner.headRepository.name,
		owner_name = current_pr_repo_and_owner.headRepositoryOwner.login,
		pr_number = pr_number,
	}
end

local get_qf_entry = function(thread)
	local qf_entry = {
		text = thread.node.comments.edges[1].node.bodyText,
		lnum = thread.node.line,
		filename = thread.node.path,
	}
	return qf_entry
end

local get_qf_list = function(review_threads)
	local qf_list = {}
	for _, thread in ipairs(review_threads) do
		table.insert(qf_list, get_qf_entry(thread))
	end
	return qf_list
end

local add_pr_comments_to_qf = function()
	local pr_info_table = get_current_pr_repo_and_owner()
	local review_threads = get_review_threads_for_current_pr(pr_info_table)
	local qf_list = get_qf_list(review_threads)
	vim.fn.setqflist(qf_list)
	vim.api.nvim_exec("copen", false)
end

return {
	add_pr_comments_to_qf = add_pr_comments_to_qf,
}
