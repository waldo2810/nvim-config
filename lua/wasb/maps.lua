local keymap = vim.keymap

keymap.set('n', 'x', '"_x')

-- Increment/decrement
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Delete a word backwards
keymap.set('n', 'dw', 'vb"_d')

-- Select all
keymap.set('n', '<C-a>', 'gg<S-v>G')

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- New tab
keymap.set('n', 'te', ':tabedit')
-- Split window
keymap.set('n', 'sh', ':split<Return><C-w>w')
keymap.set('n', 'sv', ':vsplit<Return><C-w>w')
-- Move window
keymap.set('n', '<Space>', '<C-w>w')
keymap.set('', '<C-h>', '<C-w>h')
keymap.set('', '<C-k', '<C-w>k')
keymap.set('', '<C-j>', '<C-w>j')
keymap.set('', '<C-l>', '<C-w>l')

-- Resize window
keymap.set('n', '<C-left>', '<C-w><')
keymap.set('n', '<C-right>', '<C-w>>')
keymap.set('n', '<C-up>', '<C-w>+')
keymap.set('n', '<C-down>', '<C-w>-')

-- Terminal
keymap.set('', '<leader>tc', '<Cmd>ToggleTermToggleAll<CR>')

-- Java
function keymap.map_java_keys(bufnr)
  keymap.map_lsp_keys()

  local spring_boot_run = 'mvn spring-boot:run'
  local command = ':lua require("toggleterm").exec("' .. spring_boot_run .. '")<CR>'
  keymap.set('n', '<leader>sr', command)
  keymap.set('n', '<leader>oi', ':lua require("jdtls").organize_imports()<CR>')
  keymap.set('n', '<leader>jc', ':lua require("jdtls).compile("incremental")')
end
