let g:vimtex_compiler_latexmk = {
        \ 'backend': 'nvim',
        \ 'background' : 1,
        \ 'build_dir' : 'latex_build',
        \ 'continuous' : 1,
        \ 'options' : [
        \   '-verbose',
        \   '-file-line-error',
        \   '-synctex=1',
        \   '-interaction=nonstopmode',
		\   '-shell-escape',
        \ ],
        \}
let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_progname = 'nvr'
let g:tex_flavor = 'latex'
let g:tex_conceal='abdmg'
let g:vimtex_syntax_conceal = {
          \ 'accents': 1,
          \ 'cites': 1,
          \ 'fancy': 1,
          \ 'greek': 1,
          \ 'math_bounds': 1,
          \ 'math_delimiters': 1,
          \ 'math_fracs': 1,
          \ 'math_super_sub': 1,
          \ 'math_symbols': 1,
          \ 'sections': 1,
          \ 'styles': 1,
          \}
set textwidth=80
