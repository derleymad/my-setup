"coloca a numeração em cada linha
set number

"Define o tema no awsome-vim-colorschemes
colo deus

"Define atalho para abrir e fechar o plugin NerdTree
nnoremap <C-t> :NERDTreeToggle<CR>

"Define a barra horizontal em cada linha selecionada
set cursorline

"Diminui o tamanho o tab
set softtabstop=2 expandtab shiftwidth=2

"Define o caractere indentado pelo plugin
let g:indentLine_char = '┊'  

"Ativa os buffers como varias tabs
let g:airline#extensions#tabline#enabled = 1

let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
"Tira as descriçoes exageradas das tabs e deixa so o nome do arquivo e o formato
let g:airline#extensions#tabline#formatter = 'unique_tail'


nnoremap <silent> <S-l> :bn!<CR>
nnoremap <silent> <S-h> :bp!<CR>
