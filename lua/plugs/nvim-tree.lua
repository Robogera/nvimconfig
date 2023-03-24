require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = false,
    width = 25,
    side = "left"
  },
  renderer = {
    group_empty = true,
    highlight_opened_files = "all",
  },
  filters = {
    dotfiles = false,
  },
})
