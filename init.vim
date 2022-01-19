call plug#begin('~/.config/nvim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'easymotion/vim-easymotion'
Plug 'brgmnn/vim-opencl'
Plug 'junegunn/vim-easy-align'
" Plug 'junegunn/rainbow_parentheses.vim'
Plug 'liuchengxu/vista.vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
call plug#end()

syntax enable
set background=dark
colorscheme atom-dark-256

set number
set relativenumber
set cursorline

set tabstop=4
set softtabstop=4
set shiftwidth=2
set expandtab

set showcmd
set mouse=a
set clipboard+=unnamedplus

set list
set listchars=tab:»\ ,trail:·,extends:>,precedes:<


" Enable syntax highlighting for LLVM files. To use, copy
" utils/vim/syntax/llvm.vim to ~/.vim/syntax .
augroup filetype
  au! BufRead,BufNewFile *.ll     set filetype=llvm
  au! BufRead,BufNewFile *.td     set filetype=tablegen
  au! BufRead,BufNewFile *.cl     set filetype=opencl
augroup END

hi default LspCxxHlGroupEnumConstant ctermfg=176
hi default LspCxxHlGroupNamespace ctermfg=136
hi default LspCxxHlGroupMemberVariable ctermfg=81
hi default LspCxxHlSymFunctionVariable guifg=#26cdca

"*********"
"  Vista  "
"*********"
let g:vista#renderer#enable_icon = 0
let g:vista#renderer#kind_default_icon = ['╰─▸ ', '├─▸ ']
let g:vista_icon_indent = ["|- ", "`-"]
let g:vista_default_executive = 'coc'
noremap <space>v :Vista!!<CR>


"******************"
"  vim-easy-align  "
"******************"
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


"***********************"
"  rainbow_parentheses  "
"***********************"
"let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}'],['<', '>']]
"augroup rainbow_lisp
"  autocmd!
"  autocmd VimEnter * RainbowParentheses
"  autocmd FileType cmake RainbowParentheses!
"  autocmd FileType tablegen RainbowParentheses!
"augroup END


"***********"
"  LeaderF  "
"***********"
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_ShowDevIcons = 0
let g:Lf_NormalMap = { "File":   [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']] }
noremap <space>ff :Leaderf file --no-ignore<CR>
noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg --no-ignore -e %s", expand("<cword>"))<CR>

"*****************"
"  lightline.vim  "
"*****************"
set laststatus=2
set noshowmode
let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'active': {
  \   'left': [
  \     [ 'mode', 'paste' ],
  \     [ 'cocstatus', 'relativepath', 'modified', 'curr_func' ],
  \   ]
  \ },
  \ 'component_function': {
  \   'cocstatus': 'coc#status',
  \   'curr_func': 'LightlineCurrentFunction'
  \ },
  \ }

" Use autocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
autocmd CursorHold * silent call CocActionAsync('highlight')

function! LightlineGitStatus() abort
  let status = get(g:, 'coc_git_status', '')
  return status
endfunction

function! LightlineCurrentFunction() abort
  let line = get(b:, 'coc_current_function', '')
  return line
endfunction

nmap gc <Plug>(coc-git-commit)


"***************"
"  easy-motion  "
"***************"
let g:EasyMotion_do_mapping = 0 " Disable default mappings
" nmap s <Plug>(easymotion-overwin-f)
nmap s <Plug>(easymotion-overwin-f2)
let g:EasyMotion_smartcase = 1
map <space>j <Plug>(easymotion-j)
map <space>k <Plug>(easymotion-k)

"************"
"  coc.nvim  "
"************"
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=1

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings using CoCList:
" Unmap <Ctrl-I>
:unmap <C-I>
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Show buffers.
nnoremap <slient> <space>b  :<C-u>CocList buffers<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>n  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>p  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>r  :<C-u>CocListResume<CR>

" nnoremap <silent> <space>n :<C-u>CocList files --no-ignore<cr>
