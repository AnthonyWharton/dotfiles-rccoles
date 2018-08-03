call plug#begin('~/.vim/vim-plug-plugins')
Plug 'lervag/vimtex'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'takac/vim-hardtime'
Plug 'Valloric/YouCompleteMe'
Plug 'tpope/vim-commentary'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'junegunn/vim-peekaboo'
Plug 'rccoles/vim-markaboo'
Plug 'tomasr/molokai'
Plug 'airblade/vim-gitgutter'
" Plug 'lilydjwg/colorizer' // really slow
Plug 'junegunn/goyo.vim'
call plug#end()

"general
set nohidden
set autoindent
set shiftwidth=8
set tabstop=8
set noexpandtab
set number
set background=dark
set backspace=indent,eol,start
filetype plugin on
filetype indent on
set autoread
set autowrite
set autowriteall
set breakindent

"Typewriter mode courtesy of Anthony Wharton
set scrolloff=999        " Broken Typewriter mode

" Show matching brackets when text indicator is over them
set showmatch 
" How many tenths of a second to blink when matching brackets
set matchtime=2

" Search
set ignorecase
set smartcase            " Ignore case if all lower case, else search is case sensitive
set hlsearch             " Highlight searched terms
set incsearch            " Show highlighted terms as you search

" Map :W to sudo write
command! W w !sudo tee % > /dev/null

" Remap VIM 0 to first non-blank character
map 0 ^

" date string option
iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>

"gitgutter
let g:gitgutter_terminal_reports_focus=0
let g:gitgutter_map_keys=0
set updatetime=100
let g:gitgutter_sign_added = '✚'
let g:gitgutter_sign_modified = '✹'
let g:gitgutter_sign_removed = '✖'
command! Stage GitGutterStageHunk
command! Undo  GitGutterUndoHunk
highlight link GitGutterAdd Function
highlight link GitGutterChange Special
highlight link GitGutterDelete Tag
highlight link GitGutterChangeDelete Special


"Theme
set termguicolors
" let g:molokai_original = 1
colorscheme molokai

"Syntax checking
"let g:syntastic_python_checkers = ['pylint']
"let g:syntastic_haskell_checkers = ['hlint']
"let g:syntastic_tex_checkers=['chktex']
""If it's not an error we don't care
"let g:syntastic_quiet_messages = {
"    \ "!level":  "errors",
"    \ "type":    "style"}
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 0
"let g:syntastic_ignore_files = ['NERD_tree*']

"Syntax highlighting
syntax enable

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

"Color code colorisation
let g:colorizer_auto_color = 1
let g:colorizer_colornames = 0

"Hack to allow Alt key use
let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw
let c='1'
while c <= '9'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw
set timeout ttimeoutlen=50

"Nav
nmap <silent>  <A-Up>    :wincmd k<CR>
nmap <silent>  <A-Down>  :wincmd j<CR>
nmap <silent>  <A-Left>  :wincmd h<CR>
nmap <silent>  <A-Right> :wincmd l<CR>
nmap <silent>  <A-k>     :wincmd k<CR>
nmap <silent>  <A-j>     :wincmd j<CR>
nmap <silent>  <A-h>     :wincmd h<CR>
nmap <silent>  <A-l>     :wincmd l<CR>
nmap <silent>  <A-u>     gt
nmap <silent>  <A-i>     gT
imap <silent>  <A-u>     <C-o>gt
imap <silent>  <A-i>     <C-o>gT

"goyo
let g:goyo_width=150
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2

"Tree
"let NERDTreeQuitOnOpen = 1
let g:NERDTreeWinPos = "right"
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:NERDTreeWinSize = 30
map <C-n> :NERDTreeToggle<CR>
"autocmd VimEnter * silent! NERDTree  " Autostart NERDTree
"autocmd VimEnter * silent! wincmd p  " And then focus on file
autocmd BufWinEnter * silent! NERDTreeMirror
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd TabLeave * if bufname('') =~ "Nerd_tree" | wincmd h | endif

"Clipboard from system
set clipboard=unnamedplus

"Latex
let g:tex_flavor = 'latex'
let g:vimtex_latexmk_continuous = 1

"Commenting
autocmd FileType c setlocal commentstring=//\ %s
autocmd FileType h setlocal commentstring=//\ %s
autocmd FileType cpp setlocal commentstring=//\ %s
autocmd FileType hpp setlocal commentstring=//\ %s
nmap <silent> <C-_>    gcc
imap <silent> <C-_>    <C-o>gcc
vmap <silent> <C-_>    gc

"get rid of buffers
fu! DeleteInactiveBufs()
	"From tabpagebuflist() help, get a list of all buffers in all tabs
	let tablist = []
	for i in range(tabpagenr('$'))
		call extend(tablist, tabpagebuflist(i + 1))
	endfor

	"Below originally inspired by Hara Krishna Dara and Keith Roberts
	"http://tech.groups.yahoo.com/group/vim/message/56425
	let nWipeouts = 0
	for i in range(1, bufnr('$'))
		if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
		"bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
			silent exec 'bwipeout' i
			let nWipeouts = nWipeouts + 1
		endif
	endfor
endfunction

autocmd WinEnter * call DeleteInactiveBufs()

" save/restore
" set ssop-=options    " do not store global and local values in a session
" set ssop-=folds      " do not store folds
" fu! SaveSess()
" 	execute 'mksession!'. getcwd()  .'/.session.vim'
" endfunction

" if !exists('*RestoreSess')
" 	fu RestoreSess()
" 	if filereadable(getcwd() ."/.session.vim")
" 		execute 'so' . getcwd() . '/.session.vim'
" 		if bufexists(1)
" 		    for l in range(1, bufnr('$'))
" 		        if bufwinnr(l) == -1
" 		            exec 'vert sbuffer ' . l
" 		        endif
" 		    endfor
" 		endif
" 	endif
" 	so /home/raef/.vimrc
" 	bufdo e
" 	endfunction
" endif

" autocmd VimLeave * call SaveSess()
" autocmd VimEnter * call RestoreSess()

"Tabs suck
nmap <A-1> 1gt
nmap <A-2> 2gt
nmap <A-3> 3gt
nmap <A-4> 4gt
nmap <A-5> 5gt
nmap <A-6> 6gt
nmap <A-7> 7gt
nmap <A-8> 8gt
nmap <A-9> 9gt

"Don't like wrap by default
set nowrap

"Mourse control
" set mouse=a

"Mark the 80 char column
" set colorcolumn=80
let &colorcolumn=join(range(81,999),",")

"Fix for auto indentation of semicolons
set cinoptions+=L0
set cinoptions+=g0

"Peekaboo for paste
let g:peekaboo_window = 'vert bel 50new'

"Markaboo :D
let g:markaboo_window = 'vert bel 50new'
let g:markaboo_enable_special = 1
let g:markaboo_marks_special = '."'''

""Don't question full reloads
"set autoread
"au FocusGained,BufEnter * :silent! !

"Fix python tabbing
" autocmd FileType python setlocal noexpandtab tabstop=8 shiftwidth=8

"Completion via YCM from the AUR
"Don't ask to load config - maybe insecure
let g:ycm_confirm_extra_conf = 0
"Allow jump to erros using :lne and :lp
let g:ycm_always_populate_location_list = 1
"Allow completion from system preprocessor macros
let g:ycm_collect_identifiers_from_tags_files=1
"More debug
let g:ycm_log_level = 'debug'
"Set to python3 explicitly
let g:ycm_path_to_python_interpreter = '/usr/bin/python3'
"" start completion from the first character
let g:ycm_min_num_of_chars_for_completion=1
"" don't cache completion items
let g:ycm_cache_omnifunc=0
"" complete syntax keywords
let g:ycm_seed_identifiers_with_syntax=1
" let g:ycm_show_diagnostics_ui = 0
let g:ycm_autoclose_preview_window_after_insertion=1
" Check on save
autocmd BufWritePost * silent! YcmForceCompileAndDiagnostics
"Don't show fixit window
autocmd User YcmQuickFixOpened cclose
"Open definition / declaration in new window sometimes
let g:ycm_goto_buffer_command="new-tab"
"Commands
command! Declaration YcmCompleter GoToDeclaration
command! Definition  YcmCompleter GoToDefinition
command! Fix         YcmCompleter FixIt

"Fix for garbage in start
set t_RV=
autocmd VimEnter * redraw! 

" Do menu related stuff
set wildmode=longest,list
set wildmenu

"Airline config
let g:airline_theme='molokai'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_extensions = ['syntastic', 'vimtex', 'tabline']


"I enjoy having a hard time
" let g:hardtime_default_on = 1
