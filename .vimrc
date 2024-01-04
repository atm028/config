"Use Vim settings, rather then Vi settings (much better!).
"This must be first, because it changes other options as a side effect.
set nocompatible

"allow backspacing over everything in insert mode
set backspace=indent,eol,start

"store lots of :cmdline history
set history=1000

set rnu
set showcmd     "show incomplete cmds down the bottom
set showmode    "show current mode down the bottom
set showmatch   "show first pair break after enter the second one
set matchpairs+=(:)
set matchpairs+={:}

set incsearch   "find the next match as we type the search
set hlsearch    "hilight searches by default

set nowrap      "dont wrap lines
set linebreak   "wrap lines at convenient points

"statusline setup
set statusline=%f       "tail of the filename

"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%h      "help file flag
set statusline+=%y      "filetype
set statusline+=%r      "read only flag
set statusline+=%m      "modified flag

"display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

set statusline+=%{StatuslineTrailingSpaceWarning()}

set statusline+=%{StatuslineLongLineWarning()}

set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

set statusline+=%=      "left/right separator
set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set laststatus=2

set clipboard=unnamed

set guioptions-=m
set guioptions-=T
set guioptions-=r


set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set list
set listchars=tab:>-     " >

set ic 


" ======== MAPS =======
let mapleader = '\'
"Tags
let g:indexer_ctagsDontSpecifyFilesIfPossible = 1
autocmd BufWritePost $MYVIMRC source $MYVIMRC
nnoremap <silent>,v :tabnew $MYVIMRC<CR>
nnoremap <silent>,t :NERDTreeToggle<cr>
nnoremap <silent>,f :TlistToggle<cr>

nnoremap <C-j> :tabnext<cr>
nnoremap <C-k> :tabprevious<cr>
nnoremap <C-m> :tabclose<cr>
noremap <C-o> :MaximizerToggle<cr>

nmap ,fb :CtrlPBuffer<cr>
nmap ,ff :CtrlP .<cr>
nmap ,fF :execute ":CtrlP " . expand('%:p:h')<cr>
nmap ,fr :CtrlP<cr>
nmap ,fm :CtrlPMixed<cr>

nmap <leader>fb :Buffers<cr>
nmap <leader>ff :Files ./<cr>

" Use the bufkill plugin to eliminate a buffer but keep the window layout
nmap ,bd :BD<cr>
nmap ,ss :shell<cr>


"YouCompleteMe
"nnoremap <leader>jd :YcmCompleter GoTo<CR>


"""""""""""""""""CTags mapping""""""""""""""""""""""
map  <F4> [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
"map  <F9> <Plug>ToggleProject
"imap <F9> <Plug>ToggleProject
"nmap <F9> <Plug>ToggleProject
"nmap <F8> :TagbarToggle<CR>
"map  <F12> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>

"make <c-l> clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

"map to fuzzy finder text mate stylez
nnoremap <c-f> :FuzzyFinderTextMate<CR>

"map Q to something useful
noremap Q gq

"make Y consistent with C and D
nnoremap Y y$

"Project build
" Command Make will call make and then cwindow which
" opens a 3 line error window if any errors are found.
" If no errors, it closes any open cwindow.
:command! -nargs=* CMake make <args> | cwindow 3
nnoremap <F7> :CMake<CR>

"visual search mappings
function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = temp
endfunction
"vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
"vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>

" ===== END MAPS =======

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")

        if !&modifiable
            let b:statusline_trailing_space_warning = ''
            return b:statusline_trailing_space_warning
        endif

        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction


"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let b:statusline_tab_warning = ''

        if !&modifiable
            return b:statusline_tab_warning
        endif

        let tabs = search('^\t', 'nw') != 0

        "find spaces that arent used as alignment in the first indent column
        let spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        endif
    endif
    return b:statusline_tab_warning
endfunction

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")

        if !&modifiable
            let b:statusline_long_line_warning = ''
            return b:statusline_long_line_warning
        endif

        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)

    let long_line_lens = []

    let i = 1
    while i <= line("$")
        let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
        if len > threshold
            call add(long_line_lens, len)
        endif
        let i += 1
    endwhile

    return long_line_lens
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
    let nums = sort(a:nums)
    let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
endfunction

"indent settings
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

set wildmode=list:longest   "make cmdline tab completion similar to bash
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing

"display tabs and trailing spaces
set list
set listchars=tab:··

set formatoptions-=o "dont continue comments when pushing o/O

"vertical/horizontal scroll off settings
set scrolloff=3
set sidescrolloff=7
set sidescroll=1

"load ftplugins and indent files
filetype plugin on
filetype off

"setup vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()
"call vundle#scripts#reload()

filetype indent on 

""""""""""""""""""""""""""""""""""""""""""""""
"Vundle set repos
" github
call vundle#begin()
Plugin 'rking/ag.vim'
Plugin 'MarcWeber/vim-addon-completion'
Plugin 'kien/ctrlp.vim'
Plugin 'DfrankUtil'
Plugin 'EasyMotion' "never used this plugin, review
Plugin 'derekwyatt/vim-fswitch' "not used
Plugin 'tpope/vim-fugitive' "Git tool
Plugin 'endel/vim-github-colorscheme'
Plugin 'vim-scripts/gnupg.vim'
Plugin 'sjl/gundo.vim' "cool undo tree plugin but doesn't work
Plugin 'elzr/vim-json'
Plugin 'scrooloose/nerdtree'
Plugin 'derekwyatt/vim-npl'
Plugin 'derekwyatt/vim-protodef'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-surround' "change \" -> \'
Plugin 'godlygeek/tabular' "https://devhints.io/tabular
Plugin 'tpope/vim-unimpaired'
Plugin 'VisIncr'
Plugin 'GEverding/vim-hocon'
Plugin 'xolox/vim-misc'
Bundle 'lokaltog/vim-easymotion'
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'L9'

Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'

Plugin 'Colorzone'
Plugin 'Solarized'
Plugin 'mattn/emmet-vim'
Plugin 'rizzatti/dash.vim'
Plugin 'drmingdrmer/xptemplate' "code templates, never used it so it questionable
Plugin 'bufkill.vim'
Bundle 'taglist-plus'
Bundle 'gmarik/vundle'
Bundle 'ZenCoding'
Plugin 'davidoc/taskpaper.vim'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'github-theme'
Plugin 'fatih/vim-go'
Plugin 'vim-monokai'
Plugin 'vim-maximizer'

Plugin 'Tagbar'
let g:airline#extensions#tagbar#flags = 'f'
let g:tagbar_ctags_bin='/usr/local/bin/ctags'

Plugin 'mhinz/vim-startify'

Plugin 'ctags.vim'
"let g:ctags_statusline=1
"let g:ctags_regenerate=1

call vundle#end()
filetype plugin indent on

"-----------------------------------------------------------------------------
" ORG Mode settings
"-----------------------------------------------------------------------------
let g:org_todo_keywords=['TODO', 'IN_PRPGRESS', 'DONE']

"-----------------------------------------------------------------------------
" XPTemplate settings
"-----------------------------------------------------------------------------
set runtimepath+=~/.vim/xpt-personal
let g:xptemplate_brace_complete = ''
let g:xptemplate_key = '<C-\>'

"vim-project confgure
let g:project_enable_welcome = 1
let g:project_use_nerdtree = 1
set rtp+=~/.vim/bundle/vim-project/
" custom starting path
" call project#rc("/Volume/Data/Project/")
" default starting path (the home directory)
call project#rc()

"-----------------------------------------------------------------------------
" CtrlP Settings
"-----------------------------------------------------------------------------
let g:ctrlp_switch_buffer = 'E'
let g:ctrlp_tabpage_position = 'c'
let g:ctrlp_working_path_mode = 'rc'
let g:ctrlp_root_markers = ['.project.root']
let g:ctrlp_custom_ignore = '\v'
let g:ctrlp_custom_ignore .= '%(/\.'
let g:ctrlp_custom_ignore .= '%(git|hg|svn)|'
let g:ctrlp_custom_ignore .= '\.%(class|o|png|jpg|jpeg|bmp|tar|jar|tgz|deb|zip|xml|html)$|'
let g:ctrlp_custom_ignore .= '/target/%(quickfix|resolution-cache|streams)|'
let g:ctrlp_custom_ignore .= '/target/scala-2.1./%(classes|test-classes|sbt-0.13|cache)|'
let g:ctrlp_custom_ignore .= '/project/target|/project/project'
let g:ctrlp_custom_ignore .= ')'
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_open_multiple_files = '1ri'
let g:ctrlp_match_window = 'max:40'
let g:ctrlp_prompt_mappings = {
  \ 'PrtSelectMove("j")':   ['<c-n>'],
  \ 'PrtSelectMove("k")':   ['<c-p>'],
  \ 'PrtHistory(-1)':       ['<c-j>', '<down>'],
  \ 'PrtHistory(1)':        ['<c-i>', '<up>']
\ }
""""""""""""""""""""""""""""""""""""""""""""""

"turn on syntax highlighting
syntax enable

au BufRead,BufNewFile *.scala set filetype=scala
au! Syntax scala source ~/.vim/bundle/vim-scala/syntax/scala.vim
au BufRead,BufNewFile *.sbt set filetype=sbt
au! Syntax sbt source ~/.vim/bundle/vim-sbt/syntax/sbt.vim
au BufRead,BufNewFile *.taskpaper set filetype=taskpaper
au! Syntax taskpaper source ~/.vim/bundle/taskpaper.vim/syntax/taskpaper.vim


"""""" Color theme
"tell the term has 256 colors
"set t_Co=256
let g:solarized_termcolors=256
"colorscheme solarized
"colorscheme github
colorscheme PaperColor

"colo seoul256
" Light color scheme
"colo seoul256-light

" Switch
set background=dark
"set background=light


"Cursor
highlight Cursor guifg=white guibg=black
highlight iCursor guifg=white guibg=steelblue
set guicursor=n-v-c:block-Cursor
set guicursor+=i:ver100-iCursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkwait10


"some stuff to get the mouse going in term
set mouse=a
"set ttymouse=xterm2


"hide buffers when not displayed
set hidden

""""""""""""""""Set font""""""""""""""""
if has("gui")
  if has("win32")
    set guifont=Consolas:h16:cANSI
  endif
endif
set guifont=Monaco:h16


"dont load csapprox if we no gui support - silences an annoying warning
if !has("gui")
    let g:CSApprox_loaded = 1
endif

function! GenerateTagsFile()
  if (!filereadable("tags"))
    if has("win32")
       exec ":!start /min ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase ."
    endif
    if has("linux")
       exec ":!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase ."
    endif
 endif
endfunction

" Always change to directory of the buffer currently in focus.
autocmd! bufenter *.* :cd %:p:h
autocmd! bufread  *.* :cd %:p:h

" Generate tags on opening an existing file.
autocmd! bufreadpost *.cpp :call GenerateTagsFile()
autocmd! bufreadpost *.c   :call GenerateTagsFile()
autocmd! bufreadpost *.h   :call GenerateTagsFile()

" Generate tags on save. Note that this regenerates tags for all files in current folder.
autocmd! bufwritepost *.cpp :call GenerateTagsFile()
autocmd! bufwritepost *.c   :call GenerateTagsFile()
autocmd! bufwritepost *.h   :call GenerateTagsFile()

"""""""""""""TagList"""""""""""""""""""""""""""""""""
let g:Tlist_Show_one_File=1
let g:Tlist_GainFocus_On_ToggleOpen = 1
let g:Tlist_Compact_Format=1
let g:Tlist_Close_On_Select=0
let g:Tlist_Auto_Highlight_Tag=1
let Tlist_Use_Right_Window=4
let Tlist_Use_WinWidth=10


"""""""""""""""""""""""""""""""""""""""""""""""""""""
                                                    
"mark syntax errors with :signs
let g:syntastic_enable_signs=1


" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview


"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    end
endfunction

"define :HighlightLongLines command to highlight the offending parts of
"lines that are longer than the specified length (defaulting to 80)
command! -nargs=? HighlightLongLines call s:HighlightLongLines('<args>')
function! s:HighlightLongLines(width)
    let targetWidth = a:width != '' ? a:width : 79
    if targetWidth > 0
        exec 'match Todo /\%>' . (targetWidth) . 'v/'
    else
        echomsg "Usage: HighlightLongLines [natural number]"
    endif
endfunction

"Settings for XCode
if len(glob( getcwd() . '/*.xcodeproj' )) > 0
        let &makeprg = 'xcodebuild'
endif


