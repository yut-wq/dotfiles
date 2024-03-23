-- " スワップファイルを作らない
-- vim.o.noswapfile = true
-- " 編集中のファイルが変更されたら自動で読み直す
vim.o.autoread = true
-- " バッファが編集中でもその他のファイルを開けるように
vim.o.hidden = true
-- " 入力中のコマンドをステータスに表示する
vim.o.showcmd = true
-- "jkでescの代わりに
vim.keymap.set('i', 'jk', '<ESC>')
vim.keymap.set('i', 'jj', '<ESC>')
-- " クリップボード連携
-- xclipが必要
vim.opt.clipboard:append{'unnamedplus', 'unnamed'}
vim.g.mapleader = " "
-- " leader sで行頭へ
vim.keymap.set({'n','v'}, '<leader>s', '^')
-- " leader eで行末へ
vim.keymap.set({'n','v'}, '<leader>e', '$')
-- leader w で保存
vim.keymap.set('n', '<leader>w', ':w<CR>')


--
-- " 見た目系
-- " 行番号を表示
vim.o.number = true
-- " 現在の行を強調表示
-- " 行末の1文字先までカーソルを移動できるように
vim.o.virtualedit = 'onemore'
-- " インデントはスマートインデント
vim.o.smartindent = true
-- "ビープ音すべてを無効にする
vim.o.belloff = 'all'
-- " 括弧入力時の対応する括弧を表示
vim.o.showmatch = true
-- " ステータスラインを常に表示
vim.o.laststatus = 2
-- " コマンドラインの補完
vim.o.wildmode = 'list:longest'
-- " 折り返し時に表示行単位での移動できるようにする
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
-- " シンタックスハイライトの有効化
vim.o.syntax = 'enable'
-- " 折りたたみ
vim.o.foldmethod = 'manual'
--
--
--
--
-- " Tab系
-- " 行頭以外のTab文字の表示幅（スペースいくつ分）
vim.o.tabstop = 4
-- " 行頭でのTab文字の表示幅
vim.o.shiftwidth = 4
--
--
-- " 検索系
-- " 検索文字列が小文字の場合は大文字小文字を区別なく検索する
vim.o.ignorecase = true

-- " 検索文字列に大文字が含まれている場合は区別して検索する
vim.o.ignorecase = true
-- " 検索文字列入力時に順次対象文字列にヒットさせる
vim.o.incsearch = true
-- " 検索時に最後まで行ったら最初に戻る
vim.o.wrapscan = true
-- " 検索語をハイライト表示
vim.o.hlsearch = true
-- " ESC連打でハイライト解除
vim.keymap.set('n', '<Esc><Esc>', ':nohlsearch<CR><Esc>')
--
-- "ターミナルモード中にEscでターミナルノーマルモードに移行
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
-- " バッファー操作
vim.keymap.set('n', '<C-j>', ':bprev<CR>',{silent = true})
vim.keymap.set('n', '<C-k>', ':bnext<CR>',{silent = true})
vim.keymap.set('n', '<leader>h', '<C-w>h')
vim.keymap.set('n', '<leader>j', '<C-w>j')
vim.keymap.set('n', '<leader>k', '<C-w>k')
vim.keymap.set('n', '<leader>l', '<C-w>l')
vim.keymap.set('n', '<leader>q', ':bd',{silent = true})





