local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
 autocmd("VimResized", {
   pattern = "*",
   command = "tabdo wincmd =",
 })

autocmd("FocusLost", {
  pattern = "*",
  command = ":w"
})

-- require "custom.configs.auto-reload"
