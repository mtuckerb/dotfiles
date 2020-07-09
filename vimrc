let mapleader = " "
set nocompatible
set rtp+=~/.fzf
set rtp+=~/.vim/bundle/tabnine-vim
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
set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

if empty(glob('~/.vim/tmp'))
  silent !mkdir -p ~/.vim/tmp
endif
set directory=$HOME/.vim/tmp


" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

source ~/.vimrc.bundles
imap jk <ESC>
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
  autocmd BufRead, BufNewFile *.md set filetype=markdown
  autocmd BufRead, BufNewFile .{jscs,jshint,eslint}rc set filetype=json
  autocmd BufRead, BufNewFile aliases.local,zshrc.local,*/zsh/configs/* set filetype=sh
  autocmd BufRead, BufNewFile gitconfig.local set filetype=gitconfig
  autocmd BufRead, BufNewFile tmux.conf.local set filetype=tmux
  autocmd BufRead, BufNewFile vimrc.local set filetype=vim
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
  endif
  let g:ale_ruby_rubocop_options = '-c ~/client_engineering/rubocop.yml --ignore-parent-exclusion' 
  let g:ale_lint_on_text_changed = 'never'
  let g:ale_lint_on_enter = 0
  let g:ale_lint_on_insert_leave= 'never'
  let g:ale_lint_save = 1
  let g:ale_fix_on_save = 'never'
  let g:ale_completion_enabled = 0
  let g:ale_linter_aliases = {'js': ['css', 'javascript']}
  let g:ale_linters = {
        \   'javascript': ['prettier','stylelint', 'eslint'], 
        \   'ruby': ['rubocop']}
  let g:ale_linters_explicit=1
  let g:ale_fixers = {
        \   'javascript': ['prettier'],
        \   'css': ['prettier'],
        \   'ruby': ['rubocop']
        \}
augroup END
nnoremap <Leader><Leader>f :ALEFix<CR>
let g:prettier#autoformat_require_pragma = 1
nnoremap confe :e $MYVIMRC<CR>
nnoremap confr :source $MYVIMRC<CR>
let g:ale_lint_on_text_changed = 0
" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Softtabs, 2 spaces
set tabstop=2 shiftwidth=2 expandtab
set shiftround
" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use one space, not two, after punctuation.
set nojoinspaces

if executable('rg')
  " Use Ag over Grep
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
  command! -bang -nargs=* Ripgrep call fzf#vim#grep( 'rg --column -U --line-number --no-heading --color=always --ignore-case '.shellescape(<q-args>), 1, <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)
  set grepprg=rg\ --vimgrep

  function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
  endfunction

  command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
  function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
  endfunction

  let g:fzf_action = {
        \ 'ctrl-q': function('s:build_quickfix_list'),
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-x': 'split',
        \ 'ctrl-v': 'vsplit' }

  let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'
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


vmap <C-c> y:new ~/.vimbuffer<CR>VGp:x<CR> \| :!~/.iterm2/it2copy ~/.vimbuffer<CR><CR>

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

"inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
"inoremap <S-Tab> <C-n>

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
nnoremap <C-k> :redraw! <CR>

" Move between linting errors
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>

nnoremap <C-p> :FZF <CR>
nnoremap <C-f> :Ripgrep<Cr>

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

colorscheme tender

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

let g:airline_theme='tender' " was tender
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_powerline_fonts = 1
let g:airline_enable_fugitive=1

set guifont=Source\ Code\ Pro\ for\ Powerline:h14

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"


set hidden

:au FocusLost * silent! wa

"set tags=./tags;
"set tags+=gems.tags; 

if (&diff)
  colorscheme github
  nnoremap [ [m
  nnoremap ] ]m
endif

set mouse=a
let g:NERDTreeMouseMode=3
" Makes sure the cursor is on the open buffer
nmap <silent> <C-e> :call NERDTreeToggleInCurDir()<cr>
function! NERDTreeToggleInCurDir()
  " If NERDTree is open in the current buffer
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    exe ":NERDTreeClose"
  else
    exe ":NERDTreeFind"
  endif
endfunction

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
let g:test#ruby#minitest#executable = 'be m'
let g:test#ruby#rails#executable = 'be m'
let g:test#ruby#rspec#executable = 'be m'
" make sure it is not run through bundle exec (from https://github.com/janko-m/vim-test#ruby)
let test#ruby#bundle_exec = 0
" manually prepend spring (from https://github.com/janko-m/vim-test#executable)
let test#ruby#m#executable = ' spring m'
let test#ruby#use_spring_binstub = 0
let g:DirDiffSimpleMap = 1
let g:DirDiffTheme="github"
"let g:vimwiki_list = [{'path': '~/vimwiki', 'auto_toc': 1}]
let g:vimwiki_table_mappings = 0
let lineText = getline('.')

"yank and put to tmux buffer
nmap ty :Tyank<CR>
nmap tp :Tput<CR>
nmap <C-x> :bd<cr>
autocmd BufReadPost, FileReadPost, BufNewFile, BufEnter * call system("tmux rename-window " . system("git rev-parse --show-toplevel | awk -F '/' '{print $NF}'") . "-" .  expand("%:t"))
" Workaround for OSX filesystem chroot
cmap w!! %!sudo tee > /dev/null 
runtime macros/emojis.vim


let g:user_emmet_leader_key='<Leader> <Tab>'
let g:user_emmet_settings = {
      \  'javascript.jsx' : {
      \      'extends' : 'jsx',
      \  },
      \}

autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.vue,*.yaml,*.html PrettierAsync
let g:rainbow_active = 1

" quickfix-reflector
let g:qf_join_changes = 1 " allow undo as a single operation per buffer

command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  let isfirst = 1
  let words = []
  for word in split(a:cmdline)
    if isfirst
      let isfirst = 0  " don't change first word (shell command)
    else
      if word[0] =~ '\v[%#<]'
        let word = expand(word)
      endif
      let word = shellescape(word, 1)
    endif
    call add(words, word)
  endfor
  let expanded_cmdline = join(words)
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:  ' . a:cmdline)
  call setline(2, 'Expanded to:  ' . expanded_cmdline)
  call append(line('$'), substitute(getline(2), '.', '=', 'g'))
  silent execute '$read !'. expanded_cmdline
  1
endfunction

" Automatically install all needed coc extensions
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

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap T :enew<cr>
nmap <C-h> :bprev<CR>
nmap <C-l> :bnext <CR>
nnoremap - :bnext<CR>
nnoremap _ :bprevious<CR>
nmap <leader>bq :bp <BAR> bd #<CR>
nmap <leader>bl :ls<CR>
