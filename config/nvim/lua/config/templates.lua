--- Apply a template to the current buffer
--- @param template_path string The path to the template file
local apply_template = function(template_path)
	if vim.fn.filereadable(template_path) == 1 then
		vim.cmd("0r " .. template_path)
	end
end

--- Get all templates for a given filetype
--- @param ft string The filetype to get templates for
--- @return string[] A list of template file paths
local get_templates_for_ft = function(ft)
	local template_dir = vim.fn.stdpath("config") .. "/lua/config/templates/"
	local templates = vim.fn.glob(template_dir .. "*" .. ft, false, true)
	return templates
end

--- Show a telescope picker to select a template
--- @param templates string[] A list of template file paths
local pick_template = function(templates)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local selected_template

	-- add option to select no template
	local options = templates
	table.insert(options, 1, "No template")

	vim.schedule(function()
		pickers
			.new({}, {
				prompt_title = "Select a template",
				finder = finders.new_table({
					results = options,
				}),
				initial_mode = "normal",
				sorter = conf.generic_sorter({}),
				attach_mappings = function(prompt_bufnr, _)
					actions.select_default:replace(function()
						actions.close(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						selected_template = selection.value
						if selected_template ~= "No template" then
							apply_template(selected_template)
						end
					end)
					return true
				end,
			})
			:find()
	end)
end

local group = vim.api.nvim_create_augroup("FileTemplates", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
	callback = function(ev)
		if vim.api.nvim_buf_line_count(ev.buf) > 1 or vim.api.nvim_buf_get_lines(ev.buf, 0, 1, false)[1] ~= "" then
			return
		end

		if vim.bo[ev.buf].filetype == "vue" then
			local templates = get_templates_for_ft("vue")
			if #templates == 0 then
				return
			end

			if #templates == 1 then
				apply_template(templates[1])
				return
			end

			pick_template(templates)
		end
	end,
	group = group,
})
