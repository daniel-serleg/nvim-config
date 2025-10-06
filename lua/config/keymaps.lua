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
vim.keymap.set('n', '<leader>tl', '<Cmd>BufferPrevious<CR>', { desc = "[T]ab Go [Last] <--"})
vim.keymap.set('n', '<leader>th', '<Cmd>BufferNext<CR>', { desc = "[T]ab Go A[h]ead -->" })

-- Re-order to previous/next
vim.keymap.set('n', '<leader>tH', '<Cmd>BufferMovePrevious<CR>')
vim.keymap.set('n', '<leader>tL', '<Cmd>BufferMoveNext<CR>')

-- Goto buffer in position...
vim.keymap.set('n', '<leader>t1', '<Cmd>BufferGoto 1<CR>')
vim.keymap.set('n', '<leader>t2', '<Cmd>BufferGoto 2<CR>')
vim.keymap.set('n', '<leader>t3', '<Cmd>BufferGoto 3<CR>')
vim.keymap.set('n', '<leader>t4', '<Cmd>BufferGoto 4<CR>')
vim.keymap.set('n', '<leader>t5', '<Cmd>BufferGoto 5<CR>')
vim.keymap.set('n', '<leader>t6', '<Cmd>BufferGoto 6<CR>')
vim.keymap.set('n', '<leader>t7', '<Cmd>BufferGoto 7<CR>')
vim.keymap.set('n', '<leader>t8', '<Cmd>BufferGoto 8<CR>')
vim.keymap.set('n', '<leader>t9', '<Cmd>BufferGoto 9<CR>')
vim.keymap.set('n', '<leader>t0', '<Cmd>BufferLast<CR>')

-- Pin/unpin buffer
vim.keymap.set('n', '<leader>tP', '<Cmd>BufferPin<CR>', { desc = "[T]ab [P]in" })

-- Goto pinned/unpinned buffer
--                 :BufferGotoPinned
--                 :BufferGotoUnpinned

-- Close buffer
vim.keymap.set('n', '<leader>tc', '<Cmd>BufferClose<CR>', { desc = "[T]ab [C]lose" })

-- Wipeout buffer
--                 :BufferWipeout

-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight

-- Magic buffer-picking mode
-- map('n', '<C-p>',   '<Cmd>BufferPick<CR>', opts)
-- map('n', '<C-s-p>', '<Cmd>BufferPickDelete<CR>', opts)

-- Sort automatically by...
vim.keymap.set('n', '<leader>bb', '<Cmd>BufferOrderByBufferNumber<CR>')
vim.keymap.set('n', '<leader>bn', '<Cmd>BufferOrderByName<CR>')
vim.keymap.set('n', '<leader>bd', '<Cmd>BufferOrderByDirectory<CR>')
vim.keymap.set('n', '<leader>bl', '<Cmd>BufferOrderByLanguage<CR>')
vim.keymap.set('n', '<leader>bw', '<Cmd>BufferOrderByWindowNumber<CR>')

