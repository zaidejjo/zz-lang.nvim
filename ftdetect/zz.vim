" zz-lang.nvim — filetype detection for ZZ

autocmd BufRead,BufNewFile *.zz setfiletype zz
autocmd BufRead,BufNewFile *.zz setlocal comments=://,:///,://!,:/*
autocmd BufRead,BufNewFile *.zz setlocal commentstring=//\ %s
