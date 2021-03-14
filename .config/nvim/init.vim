" vim: fdm=marker foldlevel=0 foldenable sw=2 ts=2 sts=2
"----------------------------------------------------------------------------------------
" Title:		Neovim configuration
" Author:		Vikram Venkataramanan
" Description:  Should work out of the box on most mac/unix machines
"----------------------------------------------------------------------------------------

if exists('g:vscode')

    set clipboard=unnamedplus

    nnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
    xnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
    nnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
    xnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
    nnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
    xnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
    nnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>
    xnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>

    xmap gc  <Plug>VSCodeCommentary
    nmap gc  <Plug>VSCodeCommentary
    omap gc  <Plug>VSCodeCommentary
    nmap gcc <Plug>VSCodeCommentaryLine

    xmap cm  <Plug>VSCodeCommentary
    nmap cm  <Plug>VSCodeCommentary
    omap cm  <Plug>VSCodeCommentary
    nmap cml <Plug>VSCodeCommentaryLine

    command! Rg                 call VSCodeNotify('extension.ripgrep')
    command! Refactor           call VSCodeNotify('keyboard-quickfix.openQuickFix')
    command! Reload             call VSCodeNotify('workbench.action.reloadWindow')
    command! TogglePrettySymbol call VSCodeNotify('conceal.togglePrettySymbols')
    command! Browse             call VSCodeNotify('file-browser.open')
    command! BToggle            call VSCodeNotify('bookmarks.toggle')
    command! BAnnotate          call VSCodeNotify('bookmarks.toggleLabeled')
    command! BList              call VSCodeNotify('bookmarks.list')
    command! Git                :!smerge .<CR>

    nmap <silent> <BS> :Find<CR>
    nmap <silent> <Tab> :tabn<CR>

    AlterCommand o[pen] Find

    let mapleader = "\<SPACE>"
else

    " general {{{
    " Always support UTF-8
    set encoding=utf-8
    set fileencoding=utf-8
    set fileencodings=utf-8

    " I'll handle backups myself, thank you
    set noswapfile
    set nobackup
    set nowritebackup

    " More modern view
    set cmdheight=2            " give more space for displaying messages
    set noshowcmd              " don't show last command
    set wildmode=longest,list  " get bash-like tab completions
    set shortmess+=c           " don't pass messages to |ins-completion-menu|.

    " searching
    set incsearch
    set nohlsearch	           " highlight search results
    set inccommand=nosplit     " THIS IS AMAZING! :O
    set gdefault               " by default, swap out all instances in a line

    set signcolumn=yes

    " }}}
    " setup vim-plug {{{
    let g:ale_disable_lsp = 1
    let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
    let g:plug_home = stdpath('data') . '/plugged'

    if !filereadable(autoload_plug_path)
    silent execute '!curl -fLo ' . autoload_plug_path . '  --create-dirs
        \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
    PlugInstall --sync | source $MYVIMRC
    endif
    unlet autoload_plug_path

    " }}}
    "
    call plug#begin(plug_home)
    "
    " clipboards {{{
    set clipboard+=unnamedplus " map nvim clipboard to system clipboard

    " Sync with system clipboard files
    if has('macunix') && executable("pbcopy")
    vmap <C-x> :!pbcopy<CR>
    vmap <C-c> :w !pbcopy<CR><cr>
    endif
    " }}}
    " text objects {{{
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-repeat'
    Plug 'kristijanhusak/vim-multiple-cursors'
    " }}}
    " tabs {{{
    "
    " Set 'tabstop' and 'shiftwidth' to whatever you prefer and use 'expandtab'. 
    " This way you will always insert spaces. The formatting will never be 
    " messed up when 'tabstop' is changed.
    set expandtab autoindent smartindent

    function! SetTabSize(size)
    execute "setlocal tabstop=".a:size
    execute "setlocal shiftwidth=".a:size
    endfunction

    " }}}
    " keybindings {{{

    " Quickly exit insert mode
    ino jj <esc>
    cno jj <c-c>

    nnoremap ; :
    vnoremap ; :

    " Easier moving of code blocks
    vnoremap <Tab>   >><Esc>gv
    vnoremap <S-Tab> <<<Esc>gv

    " Quick get that register!
    nnoremap Q @q
    vnoremap Q :normal @q

    " Redo with U instead of Ctrl+R
    noremap U <C-R>

    " Splits
    nnoremap <C-J> <C-W><C-J>
    nnoremap <C-K> <C-W><C-K>
    nnoremap <C-L> <C-W><C-L>
    nnoremap <C-H> <C-W><C-H>

    " Buffers
    nnoremap <S-h> :bprevious<CR>
    nnoremap <S-l> :bnext<CR>

    " }}}
    " leader mappings {{{
    Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

    let mapleader      = "\<SPACE>"
    let maplocalleader = "\\"

    let g:leader_key_map      =  {}
    let g:localleader_key_map =  {}

    autocmd! User vim-which-key call which_key#register('<Space>', "g:leader_key_map")
    autocmd! User vim-which-key call which_key#register('\', "g:localleader_key_map")

    nnoremap <silent> <leader>      :<c-u>WhichKey       '<space>'<CR>
    vnoremap <silent> <leader>      :<c-u>WhichKeyVisual '<space>'<CR>
    nnoremap <silent> <localleader> :<c-u>WhichKey       '\'<CR>
    vnoremap <silent> <localleader> :<c-u>WhichKeyVisual '\'<CR>

    let g:leader_key_map.t = {
        \ 'name' : '+toggle' ,
        \	's' : ['set !spell', 'spelling'],
        \ }


    nnoremap <leader><space> :b#<CR>
    let g:leader_key_map['SPC'] = 'previous-buffer'

    nnoremap <leader>/ :%s/
    vnoremap <leader>/ :s/
    let g:leader_key_map['/'] = 'find-&-replace'

    autocmd! FileType which_key
    autocmd  FileType which_key set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

    " }}}
    " version control {{{
    Plug 'tpope/vim-fugitive'
    Plug 'jreybert/vimagit'
    Plug 'mhinz/vim-signify'
    Plug 'junegunn/gv.vim'

    let g:signify_mapping_next_hunk = '<leader>gn'
    let g:signify_mapping_prev_hunk = '<leader>gp'

    let g:signify_sign_add               = '▏'
    let g:signify_sign_delete            = '┊'
    let g:signify_sign_change            = '▏'
    let g:signify_sign_change_delete     = '▏'
    let g:signify_sign_delete_first_line = '▏'

    let g:magit_default_fold_level = 0
    let g:leader_key_map.M = 'which_key_ignore'
    noremap <leader>gs :MagitOnly<CR>

    let g:leader_key_map.g = {
        \ 'name' : '+git' ,
            \	's'    : ['MagitOnly', 'status'],
        \ }

    " }}}
    " bookmarks {{{
    Plug 'MattesGroeger/vim-bookmarks'
    let g:bookmark_auto_close = 1
    let g:bookmark_sign = '♥'
    let g:bookmark_annotation_sign = '☰'

    let g:leader_key_map.b = {
        \ 'name' : '+bookmarks' ,
        \ 't' : ['BookmarkToggle',   'toggle-bookmark'],
        \ 'a' : ['BookmarkAnnotate', 'rename-bookmark'],
        \ 'b' : ['BookmarkShowAll',  'open-bookmark'],
        \ }

    " Shortcuts for frequently accessed files
    command! Vimrc e $MYVIMRC
    command! PU PlugUpdate | PlugUpgrade

    if !empty(glob('/Volumes/vikram/planner/app.txt'))
        command! J e /Volumes/vikram/planner/app.txt
    endif

    if executable('zsh')
        command! Shell e $ZDOTDIR/.zshrc
        command! Env   e $ZDOTDIR/.zshenv
    elseif executable('bash')
        command! Shell e $HOME/.bashrc
        command! Env   e $HOME/.profile
    endif

    if executable('brew')
        command! Brew  e $HOMEBREW_BUNDLE_FILE
    endif

    if !empty(glob('$XDG_CONFIG_HOME/yadm/bootstrap'))
        command! Yadm  e $XDG_CONFIG_HOME/yadm/bootstrap
    elseif !empty(glob('.yadm/bootstrap'))
        command! Yadm  e .yadm/bootstrap
    endif

    "}}}
    " remember position {{{
    augroup remember_position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    augroup END
    " }}}

    " elixir {{{
    Plug 'elixir-editors/vim-elixir',     { 'for': 'elixir' }
    Plug 'carlosgaldino/elixir-snippets', { 'for': 'elixir' }
    Plug 'avdgaag/vim-phoenix',           { 'for': 'elixir' }
    Plug 'mmorearty/elixir-ctags',        { 'for': 'elixir'}
    Plug 'mattreduce/vim-mix',            { 'for': 'elixir'}
    Plug 'BjRo/vim-extest',               { 'for': 'elixir'}
    Plug 'frost/vim-eh-docs',             { 'for': 'elixir'}
    " }}}
    " golang {{{
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

    " syntax highlighting
    let g:go_highlight_fields = 1
    let g:go_highlight_functions = 1
    let g:go_highlight_function_calls = 1
    let g:go_highlight_extra_types = 1
    let g:go_highlight_operators = 1

    " Auto formatting and importing
    let g:go_fmt_autosave = 1
    let g:go_fmt_command = "goimports"

    " Status line types/signatures
    let g:go_auto_type_info = 1

    " Run :GoBuild or :GoTestCompile based on the go file
    function! s:build_go_files()
    let l:file = expand('%')
    if l:file =~# '^\f\+_test\.go$'
        call go#test#Test(0, 1)
    elseif l:file =~# '^\f\+\.go$'
        call go#cmd#Build(0)
    endif
    endfunction

    let golang_linters = ['gofmt', 'govet']
    let golang_key_map = {
    \ '\' : ['TestLast', '+rerun_test'],
    \ 't' : ['TestNearest', '+test'],
    \ 'c' : ['Tags', '+c-tags'],
    \ 'i' : ['GoInfo', '+info'],
    \ 'l' : ['GoLint', '+lint'],
    \ 'r' : ['GoRun', '+run'],
    \ 'b' : '+build',
    \ 'd' : '+goto_definition',
    \ }

    augroup golang_settings
    autocmd!
    autocmd Filetype go nnoremap <buffer> <localleader>b :<C-u>call <SID>build_go_files()<CR>
    autocmd Filetype go nnoremap <buffer> <localleader>d :sp <CR>:exe "GoDef"<CR>
    augroup END
    " }}}
    " haskell {{{
    Plug 'eagletmt/neco-ghc'
    Plug 'dag/vim2hs'
    " }}}
    " latex {{{
    Plug 'lervag/vimtex'
    augroup filetype_latex
        autocmd!
        autocmd BufRead,BufNewFile *.pgf       set filetype=tex
        autocmd BufRead,BufNewFile *.tikz      set filetype=tex
        autocmd BufRead,BufNewFile *.pdf_tex   set filetype=tex
        autocmd BufRead,BufNewFile .latexmkrc  set filetype=perl
    augroup END
    " }}}
    " markdown {{{
    Plug 'plasticboy/vim-markdown'
    augroup filetype_markdown
        autocmd!
        autocmd filetype markdown :iabbrev <buffer> h1 #
        autocmd FileType markdown :iabbrev <buffer> h2 ##
        autocmd FileType markdown :iabbrev <buffer> h3 ###
        autocmd FileType markdown :iabbrev <buffer> h4 ####
    augroup END
    "}}}
    " python {{{
    Plug 'tmhedberg/SimpylFold', { 'for': 'python' }
    " }}}
    " rust {{{
    Plug 'racer-rust/vim-racer', { 'for': 'rust' }
    Plug 'rust-lang/rust.vim', { 'for': 'rust' }

    let g:rustfmt_autosave = 1
    "  }}}
    "  terraform {{{
    Plug 'hashivim/vim-terraform'
    "  }}}
    " typescript {{{
    Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
    Plug 'HerringtonDarkholme/yats.vim', { 'for': 'typescipt' }

    let g:yats_host_keyword = 1

    augroup filetype_typescript
        autocmd!
        autocmd BufWritePre,TextChanged,InsertLeave *.ts,*.tsx PrettierAsync
    augroup END

    " }}}

    " filetype_settings {{{
    Plug 'sheerun/vim-polyglot'

    augroup filetype_typescript
        autocmd!
        autocmd BufRead,BufNewFile *.md       setlocal filetype=markdown   syntax =markdown

        autocmd BufRead,BufNewFile *.ts       setlocal filetype=typescript syntax =typescript

        autocmd BufRead,BufNewFile *.pgf      setlocal filetype=tex        syntax =tex
        autocmd BufRead,BufNewFile *.tikz     setlocal filetype=tex        syntax =tex
        autocmd BufRead,BufNewFile *.pdf_tex  setlocal filetype=tex        syntax =tex
        autocmd BufRead,BufNewFile .latexmkrc setlocal filetype=perl       syntax =perl
    augroup END

    augroup filetype_settings
    autocmd!
    autocmd Filetype c call SetTabSize(4)
    autocmd Filetype c let g:localleader_key_map = {}

    autocmd Filetype cpp call SetTabSize(4)
    autocmd Filetype cpp let g:localleader_key_map = {}

    autocmd Filetype go call SetTabSize(4)
    autocmd Filetype go let g:localleader_key_map = golang_key_map

    autocmd Filetype make call SetTabSize(8)
    autocmd Filetype make let g:localleader_key_map = {}

        autocmd Filetype markdown setlocal spell nofoldenable

    autocmd Filetype python call SetTabSize(4)
    autocmd FileType python setlocal textwidth=79 colorcolumn=81
    autocmd Filetype python let g:localleader_key_map = {}

    autocmd Filetype typescript call SetTabSize(2)
    autocmd Filetype typescript let g:localleader_key_map = {}

    autocmd Filetype vim call SetTabSize(2)
    autocmd Filetype vim let g:localleader_key_map = {}

    augroup END
    " }}}

    " ale {{{
    Plug 'dense-analysis/ale'

    let g:ale_set_highlights = 0
    let g:ale_sign_error = 'e'
    let g:ale_sign_warning = 'w'

    let g:ale_linters = {
    \ 'go': golang_linters,
    \ }

    " }}}
    " async {{{
    Plug 'skywind3000/asyncrun.vim'
    Plug 'albertomontesg/lightline-asyncrun'
    " }}}
    " coc {{{

    if executable("python") && executable("yarn")
        Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
    endif

    let g:coc_global_extensions = [
        \ 'coc-css',
        \ 'coc-clangd',
        \ 'coc-eslint',
        \ 'coc-elixir',
        \ 'coc-go',
        \ 'coc-html',
        \ 'coc-json',
        \ 'coc-rls',
        \ 'coc-sh',
        \ 'coc-snippets',
        \ 'coc-stylelint',
        \ 'coc-tslint',
        \ 'coc-tsserver',
    \ 'coc-snippets',
    \ 'coc-ultisnips',
        \ 'coc-vimlsp',
        \ 'coc-vimtex',
        \ 'coc-yaml',
        \ ]

    inoremap <silent><expr> <TAB>
    \ pumvisible() ? coc#_select_confirm() :
    \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()

    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    let g:coc_snippet_next = '<tab>'

    imap <C-e> <Plug>(coc-snippets-expand)
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    let g:leader_key_map.c  = { 'name' : '+coc' }
    nmap <leader>cp <Plug>(coc-diagnostic-prev)
    let g:leader_key_map.c.p = 'jump-out'
    nmap <leader>cn <Plug>(coc-diagnostic-next)
    let g:leader_key_map.c.n  = 'jump-in'
    nmap <leader>cd <Plug>(coc-definition)
    let g:leader_key_map.c.d  = 'definition'
    nmap <leader>cy <Plug>(coc-type-definition)
    let g:leader_key_map.c.y  = 'type-definition'
    nmap <leader>ci <Plug>(coc-implementation)
    let g:leader_key_map.c.i  = 'implementation'
    nmap <leader>cr <Plug>(coc-references)
    let g:leader_key_map.c.r  = 'references'
    nmap <leader>cf  <Plug>(coc-fix-current)
    let g:leader_key_map.c.f  = 'fix'

    " Map function and class text objects
    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap ic <Plug>(coc-classobj-i)
    omap ic <Plug>(coc-classobj-i)
    xmap ac <Plug>(coc-classobj-a)
    omap ac <Plug>(coc-classobj-a)

    " Use K for show documentation in preview window
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
    if &filetype == 'vim'
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
    endfunction

    " }}}
    " editor-config {{{
    Plug 'editorconfig/editorconfig-vim'
    let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
    " }}}
    " fzf {{{
    if executable("fzf")
    Plug '/usr/local/opt/fzf'
    else
        let fzf_program_path = stdpath('data') . '/fzf'
    Plug 'junegunn/fzf', { 'dir': fzf_program_path, 'do': './install --bin' }
    endif
    Plug 'junegunn/fzf.vim'

    " let $FZF_DEFAULT_COMMAND="find * --path=*/* -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"
    let $FZF_DEFAULT_OPTS=' --layout=reverse  --margin=1,4'
    function! FloatingFZF()
    let buf = nvim_create_buf(v:false, v:true)
    call setbufvar(buf, '&signcolumn', 'no')

    let height = float2nr(20)
    let width = float2nr(80)
    let horizontal = float2nr((&columns - width) / 2)
    let vertical = 1

    let opts = {
            \ 'relative': 'editor',
            \ 'row': vertical,
            \ 'col': horizontal,
            \ 'width': width,
            \ 'height': height,
            \ 'style': 'minimal'
            \ }

    call nvim_open_win(buf, v:true, opts)
    endfunction

    let g:fzf_layout = { 'window': 'call FloatingFZF()' }
    let g:fzf_action = { 'ctrl-s': 'split', 'ctrl-v': 'vsplit' }

    if isdirectory(".git")
    nmap <leader>p :GitFiles --cached --others --exclude-standard <CR>
    else
    nmap <leader>p :Rg<CR>
    endif

    noremap <leader>f :BLines<CR>


    let g:leader_key_map.p = '+change-file'
    let g:leader_key_map.f = ['BLines', '+snipe-line']
    " let g:localleader_key_map.t = ['Tags', '+c-tags']

    "}}}
    " file management {{{
    if executable("vifm")
    Plug 'vifm/vifm.vim'
    let g:vifm_replace_netrw = 1
    nnoremap <bs> :Vifm<CR>
    endif

    " }}}
    " formatters {{{
    Plug 'sbdchd/neoformat'
    Plug 'godlygeek/tabular'
    " }}}
    " colorscheme {{{
    Plug 'luochen1990/rainbow'
    Plug 'lifepillar/vim-gruvbox8'
    Plug 'psliwka/vim-smoothie'
    let g:rainbow_active   = 1
    let ayucolor="dark"

    function SetColors(theme, lltheme)
    execute "colorscheme ".a:theme
    let g:lightline.colorscheme = a:lltheme

    highlight clear ALEErrorSign
    highlight clear ALEWarningSign
    highlight clear Folded
        highlight clear SignColumn
    highlight clear WhichKeyFloating

    highlight ALEErrorSign                 ctermbg=red  ctermfg=red
    highlight ALEWarningSign               ctermbg=NONE ctermfg=yellow
    highlight Folded                       ctermbg=NONE ctermfg=gray
    highlight LineNr                       ctermbg=NONE ctermfg=gray
    highlight Normal                       ctermbg=NONE
    highlight NonText                      ctermbg=NONE

    highlight SignifyLineAdd               ctermbg=NONE ctermfg=green
    highlight SignifyLineChange            ctermbg=NONE ctermfg=blue
    highlight SignifyLineDelete            ctermbg=black ctermfg=red
    highlight SignifyLineDeleteFirstLine   ctermbg=black ctermfg=red
    highlight SignifySignAdd               ctermbg=NONE ctermfg=green
    highlight SignifySignChange            ctermbg=NONE ctermfg=blue
    highlight SignifySignDelete            ctermbg=NONE ctermfg=red
    highlight SignifySignDeleteFirstLine   ctermbg=NONE ctermfg=red

    highlight BookmarkSign                 ctermbg=NONE ctermfg=blue
    highlight BookmarkLine                 ctermbg=NONE ctermfg=blue
    endfunction

    "}}}
    " lightline {{{
    Plug 'itchyny/lightline.vim'
    Plug 'maximbaz/lightline-ale'

    function! LightlineReload()
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
    endfunction

    function! CurrFunction()
        return get(b:, 'coc_current_function', '')
    endfunction

    function! GitStats()
        let [added, modified, removed] = sy#repo#get_stats()
        let symbols = ['+', '-', '~']
        let stats = [added, removed, modified]  " reorder
        let statline = ''

        for i in range(3)
        if stats[i] > 0
        let statline .= printf('%s%s ', symbols[i], stats[i])
        endif
        endfor

        if !empty(statline)
        let statline = printf('%s', statline[:-2])
        endif

        return statline
    endfunction

    let g:lightline = {
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'filename', 'readonly', 'modified'],
        \             [ 'gitbranch', 'stats', 'cocstatus', 'asyncrun_status'],
        \   ],
    \   'right' : [ [ 'lineinfo' ],
    \               [ 'percent' ],
    \               [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ],
    \               [ 'filetype' ],
    \   ],
        \ },
        \ }

    let g:lightline.component_function = {
        \   'currentfunction': 'CurrFunction',
        \   'gitbranch': 'FugitiveHead',
        \   'stats': 'GitStats',
        \   'cocstatus': 'coc#status',
        \ }

    let g:lightline.mode_map = {
        \   'n' : 'N',
        \   'i' : 'I',
        \   'R' : 'R',
        \   'v' : 'V',
        \   'V' : 'VL',
        \   "\<C-v>": 'VB',
        \   'c' : 'C',
        \   's' : 'S',
        \   'S' : 'SL',
        \   "\<C-s>": 'SB',
        \   't': 'T',
        \ }

    let g:lightline.component_expand = {
    \ 'linter_checking' : 'lightline#ale#checking',
    \ 'linter_infos'    : 'lightline#ale#infos',
    \ 'linter_warnings' : 'lightline#ale#warnings',
    \ 'linter_errors'   : 'lightline#ale#errors',
    \ 'linter_ok'       : 'lightline#ale#ok',
    \ 'asyncrun_status' : 'lightline#asyncrun#status',
    \ }

    let g:lightline.component_type = {
    \ 'linter_checking' : 'right',
    \ 'linter_infos'    : 'right',
    \ 'linter_warnings' : 'warning',
    \ 'linter_errors'   : 'error',
    \ 'linter_ok'       : 'right',
    \ }

    let g:lightline#asyncrun#indicator_none = ''

    autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
    autocmd VimEnter,BufWritePost * call LightlineReload()

    " }}}
    " testing {{{
    Plug 'vim-test/vim-test'
    " }}}
    "
    call plug#end()
    call SetColors('gruvbox8', 'seoul256')


endif