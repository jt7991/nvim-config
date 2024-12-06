return {
  'dmmulroy/tsc.nvim',
  config = function()
    require('tsc').setup({
      flags = {
        noEmit = false
      }
    })
  end
}
