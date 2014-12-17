"Use Vim settings, rather then Vi settings (much better!).
"This must be first, because it changes other options as a side effect.
set nocompatible

"allow backspacing over everything in insert mode
set backspace=indent,eol,start

"store lots of :cmdline history
set history=1000

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

set statusline+=%*
set statusline+=%<%f%h%m%r%=%{strftime(\"%I:%M\")}\ %{&ff}\ %l,%c%V
set laststatus=2

set clipboard=unnamed

set guioptions-=m
set guioptions-=T
set guioptions-=r

set ic 
"Tags
let g:indexer_ctagsDontSpecifyFilesIfPossible = 1
autocmd BufWritePost $MYVIMRC source $MYVIMRC
nnoremap <silent>,v :tabnew $MYVIMRC<CR>
nnoremap <silent>,t :NERDTreeToggle<cr>
nnoremap <silent>,f :TlistToggle<cr>

nnoremap <C-j> :tabnext<cr>
nnoremap <C-k> :tabprevious<cr>
nnoremap <C-m> :tabclose<cr>

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
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
"call vundle#scripts#reload()
"
Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/nerdtree.git'
Plugin 'Buffergator'
Plugin 'project.tar.gz'
"Plugin 'Valloric/YouCompleteMe'
Plugin 'taglist.vim'
Plugin 'snipmate'

"let g:ycm_global_ycm_extra_conf = '/Volumes/Data/.ycm_extra_conf.py'
"let g:ycm_key_invoke_completion = '<C-a>'
hi SpellBad ctermfg=016 ctermbg=052 guifg=#5f0000 guibg=#000000
hi SpellCap ctermfg=016 ctermbg=052 guifg=#5f0000 guibg=#000000
nnoremap <C-w>d :YcmCompleter GoToDefinitionElseDeclaration<CR>

filetype plugin indent on 

""""""""""""""""""""""""""""""""""""""""""""""
"Vundle set repos
" github

Bundle 'scrooloose/syntastic'

Bundle 'tpope/vim-fugitive'
Bundle 'lokaltog/vim-easymotion'
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}

" vim-scripts
Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'rails.vim'
Bundle 'molokai'


""""""""""""""""""""""""""""""""""""""""""""""

"turn on syntax highlighting
syntax on
filetype plugin indent on

"some stuff to get the mouse going in term
set mouse=a
set ttymouse=xterm2
set nu
colorscheme molokai

"tell the term has 256 colors
set t_Co=256

"hide buffers when not displayed
set hidden

highlight Pmenu ctermfg=green ctermbg=black
highlight PmenuSel ctermfg=blue ctermbg=black
highlight Search ctermfg=black ctermbg=green


" Clang Complete Settings
"" let g:clang_use_library=1
"" let g:clang_complete_copen=1
"" let g:clang_complete_macros=1
"" let g:clang_complete_patterns=0
"" let g:clang_memory_percent=70
"" let g:clang_user_options=' -std=c++11 || exit 0'
"" let g:clang_auto_select=1
"" set conceallevel=2
"" set concealcursor=vin
"" let g:clang_snippets=1
"" let g:clang_conceal_snippets=1
"" let g:clang_library_path='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib'
if isdirectory('/usr/include/c++/4.9.1')
    set path+=/usr/include/c++/4.9.1
    set path+=/usr/include/c++/4.9.1/tr1
    set path+=/usr/include/c++/4.9.1/tr2
endif

let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]

""""""""""""""""Set font""""""""""""""""
if has("gui")
  if has("win32")
    set guifont=Consolas:h16:cANSI
  endif
  if has("unix")
      set guifont=Lucida_COnsole:h14
  endif
endif


"dont load csapprox if we no gui support - silences an annoying warning
if !has("gui")
    let g:CSApprox_loaded = 1
endif

map <F9> <Plug>ToggleProject
imap <F9> <Plug>ToggleProject
nmap <F9> <Plug>ToggleProject

if has("win32")
    map <F12> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
endif

"""""""""""""""""CTags mapping""""""""""""""""""""""
map <F4> [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

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
"build
:nnoremap <F5> :<C-U>make %:r && ./%:r<CR>

"make <c-l> clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

"map to fuzzy finder text mate stylez
nnoremap <c-f> :FuzzyFinderTextMate<CR>

"map Q to something useful
noremap Q gq

"make Y consistent with C and D
nnoremap Y y$

"mark syntax errors with :signs
let g:syntastic_enable_signs=1


" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview


"snipmate setup
"source ~/.vim/snippets/support_functions.vim
"autocmd vimenter * call s:SetupSnippets()
"function! s:SetupSnippets()

    "if we're in a rails env then read in the rails snippets
"    if filereadable("./config/environment.rb")
"        call ExtractSnips("~/.vim/snippets/ruby-rails", "ruby")
"        call ExtractSnips("~/.vim/snippets/eruby-rails", "eruby")
"    endif

"    call ExtractSnips("~/.vim/snippets/html", "eruby")
"    call ExtractSnips("~/.vim/snippets/html", "xhtml")
"    call ExtractSnips("~/.vim/snippets/html", "php")
"endfunction

"visual search mappings
function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>


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

"Settings for OMNI

