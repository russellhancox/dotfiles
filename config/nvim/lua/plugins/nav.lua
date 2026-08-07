return {
  {
    'stevearc/oil.nvim',
    opts = { view_options = { show_hidden = true } },
    keys = { { '<leader>e', '<cmd>Oil<cr>', desc = 'File Browser' } },
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      picker = { enabled = true },
      notifier = { enabled = true },
      input = { enabled = true },
    },
    keys = {
      { '<leader>gp', function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
      { '<leader>gP', function() Snacks.picker.gh_pr({state = 'all' }) end, desc = "GitHub Pull Requests (all)" },
      { '<leader>f', function() Snacks.picker.files() end, desc = 'Find Files' },
      { '<leader>s', function() Snacks.picker.grep() end,  desc = 'Search Text' },
      { '<leader>b', function() Snacks.picker.buffers() end, desc = 'Buffers' },
      { '<leader>ld', function() Snacks.picker.lsp_definitions() end, desc ='LSP Definitions' },
      { '<leader>lD', function() Snacks.picker.lsp_declarations() end, desc ='LSP Declarations' },
      { '<leader>li', function() Snacks.picker.lsp_implementations() end, desc ='LSP Implementations' },
      { '<leader>lc', function() Snacks.picker.lsp_incoming_calls() end, desc ='LSP Callers' },
      { '<leader>lr', function() Snacks.picker.lsp_references() end, desc ='LSP References' },
      { '<leader>ls', function() Snacks.picker.lsp_symbols() end, desc ='LSP Symbols' },
      { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition' },
    },
  },
}
