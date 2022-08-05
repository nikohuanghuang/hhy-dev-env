function! myspacevim#before() abort
    let g:NERDTreeIgnore = ['\.o', '\.dsp', '\.dsw', '\.opt', '\.plg', '\~$']
    let g:ale_linters = {
          \ 'c': ['clangd', 'cppcheck'],
          \ 'javascript' : ['eslint'],
          \ 'javascriptreact' : ['eslint'],
          \ 'html' : ['tidy'],
          \}
    let g:ale_c_cppcheck_options = '--enable=style --std=c99'
endfunction
