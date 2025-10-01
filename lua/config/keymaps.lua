-- Remove search highlights after searching
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Remove search highlights" })

-- Exit Vim's terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- OPTIONAL: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Easily split windows
vim.keymap.set("n", "<leader>wv", ":vsplit<cr>", { desc = "[W]indow Split [V]ertical" })
vim.keymap.set("n", "<leader>wh", ":split<cr>", { desc = "[W]indow Split [H]orizontal" })

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left in visual mode" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right in visual mode" })

vim.keymap.set("n", "<C-S-k>", ":m .-2<CR>==", { desc = "Move a line up" })
vim.keymap.set("n", "<C-S-j>", ":m .+1<CR>==", { desc = "Move a line down" })

-- Json formatter
vim.keymap.set("n", "<leader>cjf", ":JqxList<CR>", { desc = "[C]ode [Json] [F]ormatter"})

-- Barbar
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<C-S-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<C-S-.>', '<Cmd>BufferNext<CR>', opts)

-- Re-order to previous/next
map('n', '<C-S-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<C-S->>', '<Cmd>BufferMoveNext<CR>', opts)

-- Goto buffer in position...
map('n', '<C-S-1>', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<C-S-2>', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<C-S-3>', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<C-S-4>', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<C-S-5>', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<C-S-6>', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<C-S-7>', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<C-S-8>', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<C-S-9>', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<C-S-0>', '<Cmd>BufferLast<CR>', opts)

-- Pin/unpin buffer
map('n', '<C-S-p>', '<Cmd>BufferPin<CR>', opts)

-- Goto pinned/unpinned buffer
--                 :BufferGotoPinned
--                 :BufferGotoUnpinned

-- Close buffer
map('n', '<C-S-c>', '<Cmd>BufferClose<CR>', opts)

-- Wipeout buffer
--                 :BufferWipeout

-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight

-- Magic buffer-picking mode
map('n', '<C-p>',   '<Cmd>BufferPick<CR>', opts)
map('n', '<C-s-p>', '<Cmd>BufferPickDelete<CR>', opts)

-- Sort automatically by...
map('n', '<leader>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
map('n', '<leader>bn', '<Cmd>BufferOrderByName<CR>', opts)
map('n', '<leader>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
map('n', '<leader>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
map('n', '<leader>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used