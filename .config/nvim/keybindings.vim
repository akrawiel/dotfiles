" Vim handling

nnoremap <space>fs :w<CR>
nnoremap <space>fS :wq<CR>
nnoremap <space>qq :qa<CR>

" Tabs

nnoremap <silent> <space>tn :tabnew<CR>
nnoremap <silent> <space>tN :tabnew %<CR>
nnoremap <silent> <space>tc :tabclose<CR>
nnoremap <silent> <space>tC :bufdo :bwipeout<CR>
nnoremap <silent> <space>to :tabonly!<CR>
nnoremap <silent> <space>tu :tab ball<CR>

" Function keys

nnoremap <silent> <F3> :noh<CR>
nnoremap <silent> <F4> :NnnPicker %:p:h<CR>

" Telescope

nnoremap <silent> <space><space> :lua require('telescope.builtin').find_files({ find_command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git' } })<CR>
nnoremap <silent> <space>fb :lua require('telescope.builtin').buffers()<CR>
nnoremap <silent> <space>fp :lua require('telescope-config').search_config()<CR>
nnoremap <silent> <space>fr :lua require('telescope.builtin').live_grep()<CR>
nnoremap <silent> <space>lo :lua require('telescope.builtin').lsp_document_symbols()<CR>
nnoremap <silent> <space>ld :lua require('telescope.builtin').lsp_workspace_diagnostics()<CR>
nnoremap <silent> <space>/ :lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>

" Undo markers

inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u

" Line moving

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==

" Quicklist

nnoremap <silent> <C-j> :cnext<CR>
nnoremap <silent> <C-k> :cprev<CR>

" Sneak

map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
map <space>s <Plug>SneakLabel_s
map <space>S <Plug>SneakLabel_S

" Git

nnoremap <silent> <space>gg :Gtabedit :<CR>
nnoremap <space>gh :diffget //2<CR>
nnoremap <space>gl :diffget //3<CR>

" Line reverse

vnoremap <silent> <space>lr :<C-u>'<,'>!tac<CR>

" Undo tree

nnoremap <F5> :UndotreeToggle<CR>

" haxe build

nnoremap <F9> :!haxe build.hxml<CR>
