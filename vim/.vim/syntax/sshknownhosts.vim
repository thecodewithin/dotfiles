setlocal iskeyword="@,48-57,_,192-255,#,-

syntax match sshknownhostspubkey "AAAA[0-9a-zA-Z+/]\+[=]\{0,2}"
highlight def link sshknownhostspubkey Special

syntax keyword sshalg ssh-rsa
highlight def link sshalg Identifier

syntax keyword shaalg ecdsa-sha2
highlight def link shaalg Identifier

syntax match sshknownhostsip "\<\(\d\{1,3}\.\)\{3}\d\{1,3}\>"
highlight def link shknownhostsip Constant

