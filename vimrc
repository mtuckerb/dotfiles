let mapleader = " "
set nocompatible
set rtp+=~/.fzf
set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
set background=dark

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

source ~/.vimrc.bundles

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

filetype plugin indent on

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
  autocmd BufRead,BufNewFile aliases.local,zshrc.local,*/zsh/configs/* set filetype=sh
  autocmd BufRead,BufNewFile gitconfig.local set filetype=gitconfig
  autocmd BufRead,BufNewFile tmux.conf.local set filetype=tmux
  autocmd BufRead,BufNewFile vimrc.local set filetype=vim
augroup END

" ALE linting events
augroup ale
  autocmd!
  let g:ale_lint_delay = 1000
  highlight ALEError ctermbg=darkgray
  highlight ALEWarning ctermbg=darkgray
  highlight clear ALEErrorSign
  highlight clear ALEWarningSign
  let g:ale_sign_error = 'ⓧ'
  let g:ale_sign_warning = '❕'
  hi SpellCap ctermbg=238 guibg=#444444
  hi SpellBad ctermbg=238 guibg=#444444
  if g:has_async
    set updatetime=1000
    let g:ale_lint_on_text_changed = 'never'
    "autocmd CursorHold * call ale#Queue(0)
    "autocmd CursorHoldI * call ale#Queue(0)
    "autocmd InsertEnter * call ale#Queue(0)
    "autocmd InsertLeave * call ale#Queue(0)
  else
    echoerr "The thoughtbot dotfiles require NeoVim or Vim 8"
  endif
  let g:ale_lint_on_text_changed = 'never'
  let g:ale_lint_on_enter = 0
  let g:ale_lint_on_insert_leave= 'never'
augroup END

  let g:ale_lint_on_text_changed = 0
" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use one space, not two, after punctuation.
set nojoinspaces

if executable('rg')
  " Use Ag over Grep
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
  command! -bang -nargs=* Rg call fzf#vim#grep( 'rg --column --line-number --no-heading --color=always --ignore-case '.shellescape(<q-args>), 1, <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)
  set grepprg=rg\ --vimgrep

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'rg --literal --files-with-matches --nocolor --hidden -g "" %s'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Numbers
set relativenumber
set numberwidth=5

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full

function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<Tab>"
  else
    return "\<C-p>"
  endif
endfunction

vmap <C-c> y:new ~/.vimbuffer<CR>VGp:x<CR> \| :!cat ~/.vimbuffer \| it2copy <CR><CR>

" This makes leader gh open the URL in it2copy instead of trying to launch a
" browser
let g:gh_open_command = 'fn() { echo "$@" | it2copy; }; fn '

" copy/paste from the command line (no Xterm) is rough in vim/tmux
" This function and Leader + c helps by taking the current line of the current
" file and opening it in less where you can copy paste normally

function! Less()
  silent !clear
  execute "!" . "less" . " " . "+" . line('.') . " -j10  " . bufname("%")
endfunction
nnoremap <Leader>c :call Less() <CR>

inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
inoremap <S-Tab> <C-n>

" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

nnoremap <Leader>b :<C-u>call gitblame#echo()<CR>

" vim-test mappings
nnoremap <silent> <Leader>t :TestFile<CR>
nnoremap <silent> <Leader>s :TestNearest<CR>
nnoremap <silent> <Leader>l :TestLast<CR>
nnoremap <silent> <Leader>a :TestSuite<CR>
nnoremap <silent> <Leader>gt :TestVisit<CR>

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<Space>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Move between linting errors
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>

nnoremap <C-p> :FZF <CR>
nnoremap <C-f> :Rg<Cr>

"This would be a cool global search but it slows down ctrl-p so no
"nnoremap <C-p>a :Rg 

" --column: Show column number
"  " --line-number: Show line number
"  " --no-heading: Do not show file headings in results
"  " --fixed-strings: Search term as a literal string
"  " --ignore-case: Case insensitive search
"  " --no-ignore: Do not respect .gitignore, etc...
"  " --hidden: Search hidden files and folders
"  " --follow: Follow symlinks
"  " --glob: Additional conditions for search (in this case ignore everything in
"  the .git/ folder)
"  " --color: Search color options

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=horizontal

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif


"noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
"noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>
"noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
"noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>

"


" colorscheme one
" colorscheme  Tomorrow-Night
colorscheme tender
" get rid of that aweful highlight color
hi PMenu guifg=#5fd6fe ctermfg=111 guibg=#4e4e4e ctermbg=239 gui=NONE cterm=NONE
let g:indentLine_enabled = 1
let g:indentLine_color_term = 234
let g:indentLine_color_tty_light = 1
let g:indentLine_color_gui = '#5f605d'
let g:indentLine_char = '│'
let g:indentLine_first_char = '.'
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_setColors = 1
let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 2

let g:airline_theme='tender'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_powerline_fonts = 1

set guifont=Source\ Code\ Pro\ for\ Powerline:h14

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
"" unicode symbols
"    let g:airline_left_sep = '»'
"    let g:airline_left_sep = '▶'
"    let g:airline_right_sep = '«'
"    let g:airline_right_sep = '◀'
"    let g:airline_symbols.crypt = '🔒'
"    let g:airline_symbols.linenr = '☰'
"    let g:airline_symbols.linenr = '␊'
"    let g:airline_symbols.linenr = '␤'
"    let g:airline_symbols.linenr = '¶'
"    let g:airline_symbols.maxlinenr = ''
"    let g:airline_symbols.maxlinenr = '㏑'
"    let g:airline_symbols.branch = '⎇'
"    let g:airline_symbols.paste = 'ρ'
"    let g:airline_symbols.paste = 'Þ'
"    let g:airline_symbols.paste = '∥'
"    let g:airline_symbols.spell = 'Ꞩ'
"    let g:airline_symbols.notexists = 'Ɇ'
"    let g:airline_symbols.whitespace = 'Ξ'
"

let g:CommandTCursorColor = 81
let g:CommandTHighlightColor= 81
let g:CommandTMatchWindowAtTop= 1

set hidden
nmap T :enew<cr>
nmap l :bnext<CR>
nmap h :bprevious<CR>
nmap <leader>bq :bp <BAR> bd #<CR>
nmap <leader>bl :ls<CR>

:au FocusLost * silent! wa

set tags=./tags;
" Bind leader p to ctag search
nnoremap <leader>. :CtrlPTag<cr>

if (&diff)
  colorscheme github
  nnoremap [ [m
  nnoremap ] ]m
endif

set mouse=a
let g:NERDTreeMouseMode=3



" enable gtags module
let g:gutentags_modules = ['ctags']
let g:gutentags_project_root = ['.root', '.git']
let g:gutentags_cache_dir = expand('~/.cache/tags')
" change focus to quickfix window after search (optional).
let g:gutentags_plus_switch = 1
let g:gutentags_define_advanced_commands = 1
let g:gutentags_ctags_executable_ruby = 'ctags'

" from https://github.com/janko-m/vim-test#setup
" map ctrl-t to run test under cursor
nmap <silent> <C-T> :TestNearest<CR>
" map ctrl-l to return to run again last test
nmap <silent> <C-L> :TestLast<CR>
" map ctrl-g to go to last test run
nmap <silent> <C-G> :TestVisit<CR>
" map ctrl-a to go to last test run
nmap <silent> <C-A> :TestFile<CR>

"florent's test shortcuts
let test#strategy="vimterminal"
" use m to run test (from
" https://github.com/janko-m/vim-test/wiki/Minitest#m-runner)
let g:test#ruby#minitest#executable = 'spring m'
let g:test#ruby#rails#executable = 'spring m'
let g:test#ruby#rspec#executable = 'spring m'
" make sure it is not run through bundle exec (from https://github.com/janko-m/vim-test#ruby)
let test#ruby#bundle_exec = 0
" manually prepend spring (from https://github.com/janko-m/vim-test#executable)
let test#ruby#m#executable = 'spring m'
let test#ruby#use_spring_binstub = 1
let g:DirDiffSimpleMap = 1
let g:DirDiffTheme="github"
"let g:vimwiki_list = [{'path': '~/vimwiki', 'auto_toc': 1}]
let lineText = getline('.')

"yank and put to tmux buffer
nmap ty :Tyank<CR>
nmap tp :Tput<CR>
nmap <C-w> :bd<cr>
autocmd BufReadPost,FileReadPost,BufNewFile,BufEnter * call system("tmux rename-window " . system("git rev-parse --show-toplevel | awk -F '/' '{print $NF}'") . "-" .  expand("%:t"))

