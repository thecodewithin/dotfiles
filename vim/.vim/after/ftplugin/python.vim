" https://www.youtube.com/watch?v=Gs1VDYnS-Ac
" https://github.com/leeren/dotfiles

set shiftwidth=4 tabstop=4 softtabstop=4 autoindent smartindent

setlocal path=.,**

setlocal include=^\\s*\\(from\\\|import\\)\\s*\\zs\\(\\S\\+\\s\\{-}\\)*\\ze\\($\\\|\ as\\)
setlocal define=^\\s*\\\\(def\\\|class\\)\\>
setlocal includeexpr=PyInclude(v:fname)

" Convertir, per exemple, 'import conv.metrics' en 'conv/metrics.py' (1)
" Convertir, per exemple, 'from conv import conversion as conv' en 
" 'conv/conversion.py' i 'conv.py' (2)

function! PyInclude(fname)
  let parts = split(a:fname, ' import ') " (1) [conv.metrics], (2) [conv,conversion]
  let l = parts[0] " (1) conv.metrics, (2) conv
  if len(part) > 1
    let r = parts[1] " conversion
    let joined = join ([l, r], '.') "conv.conversion
    let fp = substitute(joined, '\.', '/', 'g') . '.py'
    let found = glob(fp,1)
    if len(found)
      return found
    endif
  endif
    return substitute(l, '\.', '/', 'g') . '.py'
endfunction

