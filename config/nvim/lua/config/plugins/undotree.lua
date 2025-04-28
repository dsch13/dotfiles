return {
  "mbbill/undotree",
  cmd = "UndotreeToggle",
  keys = { { "<leader>U", vim.cmd.UndotreeToggle, desc = "[U]ndotree" } },
  config = function()
    vim.keymap.set("n", "<leader>U", vim.cmd.UndotreeToggle, { desc = "[U]ndotree" })
  end
}
