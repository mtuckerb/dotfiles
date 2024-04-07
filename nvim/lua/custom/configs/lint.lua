require('lint').linters_by_ft = {
  javascript = {"eslint"},
  typescript = {"eslint"},
  kotlin = {"ktlint"},
  ruby = {"rubocop"},
  json = {"jsonlint"}
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})