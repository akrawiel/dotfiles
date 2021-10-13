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
nnoremap <silent> <space>tl :tabm +1<CR>
nnoremap <silent> <space>th :tabm -1<CR>

" Buffers

nnoremap <silent> <space>bd :Bwipeout<CR>
nnoremap <silent> <space>bD :bwipeout<CR>

" Function keys

nnoremap <silent> <F3> :noh<CR>
nnoremap <silent> <F4> :NnnPicker %:p:h<CR>

" Telescope

nnoremap <silent> <space><space> :lua require('telescope.builtin').find_files({ find_command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git' } })<CR>
nnoremap <silent> <space><tab> :lua require('telescope.builtin').buffers()<CR>
nnoremap <silent> <space>ff :lua require('telescope.builtin').file_browser()<CR>
nnoremap <silent> <space>fp :lua require('telescope-config').search_config()<CR>
nnoremap <silent> <space>fr :lua require('telescope.builtin').live_grep()<CR>
nnoremap <silent> <space>lo :lua require('telescope.builtin').lsp_document_symbols()<CR>
nnoremap <silent> <space>ld :lua require('telescope.builtin').lsp_workspace_diagnostics()<CR>
nnoremap <silent> <space>/ :lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>
nnoremap <silent> <F1> :lua require('telescope.builtin').help_tags()<CR>
nnoremap <silent> <space><return> :lua require('telescope.builtin').commands()<CR>

" Windows

nnoremap <silent> <space>wc :q<CR>

" Undo markers

inoremap <silent> , ,<C-g>u
inoremap <silent> . .<C-g>u
inoremap <silent> ! !<C-g>u
inoremap <silent> ? ?<C-g>u

" Line moving

vnoremap <silent> J :m '>+1<CR>gv=gv
vnoremap <silent> K :m '<-2<CR>gv=gv
nnoremap <silent> <M-j> :m .+1<CR>==
nnoremap <silent> <M-k> :m .-2<CR>==

" Quicklist

nnoremap <silent> <C-j> :cnext<CR>
nnoremap <silent> <C-k> :cprev<CR>

" Sneak

map <silent> f <Plug>Sneak_f
map <silent> F <Plug>Sneak_F
map <silent> t <Plug>Sneak_t
map <silent> T <Plug>Sneak_T
map <silent> <space>s <Plug>SneakLabel_s
map <silent> <space>S <Plug>SneakLabel_S

" Git

nnoremap <silent> <space>gg :LazyGit<CR>
nnoremap <silent> <space>gh :diffget //2<CR>
nnoremap <silent> <space>gl :diffget //3<CR>

" Line reverse

vnoremap <silent> <space>lr :<C-u>'<,'>!tac<CR>

" Undo tree

nnoremap <silent> <F5> :UndotreeToggle<CR>
