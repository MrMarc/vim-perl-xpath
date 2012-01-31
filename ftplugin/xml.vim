if exists("b:did_ftplugin")
  finish
endif

let g:vim_perl_xpath_script = expand('<sfile>:p:h:h') . '/scripts/xpath-vim.pl'

if !exists("*Xpath")
  function! Xpath()
    " Needs to get the real file name for the quickfix window
    let realname = bufname( "%" )

    " Write the buffer to a temp file
    let filename = tempname()
    let lines = getline( 1, "$" )
    call writefile( lines, filename )

    let xpath    = input("XPath: ")

    let tmp1=&grepprg
    let tmp2=&grepformat
    let plugin_dir  = expand("<sfile>:p:h:h")

    let &grepformat="%f:%l %m"
    let &grepprg = g:vim_perl_xpath_script

    silent exe "grep ".escape(filename, ' \')." \"".xpath."\" ".escape(realname, ' \')
    let &grepprg=tmp1
    let &grepformat=tmp2

    :copen
  endfunction
endif

:nnoremap ,xp :call Xpath()<cr>

finish
