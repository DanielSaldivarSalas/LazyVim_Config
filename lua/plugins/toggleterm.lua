return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = true,
  keys = {
    {
      "<leader>td",
      "<cmd>ToggleTerm size=30 direction=float<cr>",
      --"<cmd>ToggleTerm size=30 dir=~/Desktop direction=float<cr>",
      desc = "Open a horizontal terminal at the Desktop directory",
    },
  },
}
