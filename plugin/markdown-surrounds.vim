#!/usr/bin/env vim
" markdown-surrounds.vim - Surround with bold, italic, or strikethrough
" Version: 0.0.1
" Maintainer: S0AndS0 <https://github.com/S0AndS0>
" License: AGPL-3.0


if exists('g:markdown_surrounds__loaded') || v:version < 700
  finish
endif
let g:markdown_surrounds__loaded = 1


let s:defaults = {
    \   'file_extensions': [
    \     'markdown',
    \     'md',
    \   ],
    \   'elements': {
    \     'bold': {
    \       'preferred_index': 0,
    \       'nnoremap': {
    \         'word': '<Leader>b',
    \         'line': '<Leader>B',
    \       },
    \       'patterns': [
    \         {
    \           'regexp': '\*\*',
    \           'characters': '**',
    \         },
    \         {
    \           'regexp': '__',
    \           'characters': '__',
    \         },
    \       ],
    \     },
    \     'italic': {
    \       'preferred_index': 1,
    \       'nnoremap': {
    \         'word': '<Leader>i',
    \         'line': '<Leader>I',
    \       },
    \       'patterns': [
    \         {
    \           'regexp': '\*',
    \           'characters': '*',
    \         },
    \         {
    \           'regexp': '_',
    \           'characters': '_',
    \         },
    \       ],
    \     },
    \     'strikethrough': {
    \       'preferred_index': 0,
    \       'nnoremap': {
    \         'word': '<Leader>st',
    \         'line': '<Leader>ST',
    \       },
    \       'patterns': [
    \         {
    \           'regexp': '\~\~',
    \           'characters': '~~',
    \         },
    \       ],
    \     },
    \   },
    \ }


""
" Returns merged dictionary without mutation
" See: {docs} :help type()
" See: {link} https://vi.stackexchange.com/questions/20842/how-can-i-merge-two-dictionaries-in-vim
" Example: usage >
"   let s:defaults = {
"       \   'number': 42,
"       \   'nested': {
"       \     'stringy': 'Spam',
"       \     'inner': {
"       \       'list': [0, 1, 2],
"       \     },
"       \   },
"       \ }
"
"   let s:override = {
"       \   'number': 1,
"       \   'nested': {
"       \     'stringy': 'Canned ham',
"       \   },
"       \ }
"
"   let s:merged = s:Dict_Merge(s:defaults, s:override)
"   for [s:key, s:value] in items(s:merged)
"     echo s:key '->' s:value
"   endfor
" <
" Example: output >
"   number -> 1
"   nested -> { 'stringy': 'Canned ham', 'inner': { 'list': [0, 1, 2] } }
" <
function! s:Dict_Merge(defaults, override, ...) abort
  let l:new = copy(a:defaults)

  for [l:key, l:value] in items(a:override)
    if type(l:value) == type({}) && type(get(l:new, l:key)) == type({})
      let l:new[l:key] = s:Dict_Merge(l:new[l:key], l:value)
    else
      let l:new[l:key] = l:value
    endif
  endfor

  return l:new
endfunction


""
" See: {docs} :help fnamemodify()
" See: {docs} :help readfile()
" See: {docs} :help json_decode()
if exists('g:markdown_surrounds')
  if type(g:markdown_surrounds) == type('') && fnamemodify(g:markdown_surrounds, ':e') == 'json'
    let g:markdown_surrounds = json_decode(readfile(g:markdown_surrounds))
  endif

  if type(g:markdown_surrounds) == type({})
    let g:markdown_surrounds = s:Dict_Merge(s:defaults, g:markdown_surrounds)
  else
    let g:markdown_surrounds = s:defaults
  endif
else
  let g:markdown_surrounds = s:defaults
endif


""
" Merge custom configurations with defaults, and register re-mappings
" See: {docs} :help curly-braces-function-names
" See: {docs} :help :map-<buffer>
" See: {link} https://stackoverflow.com/questions/41433881/passing-a-dictionary-to-a-function-in-viml
" See: {link} https://stackoverflow.com/questions/890802/how-do-i-disable-the-press-enter-or-type-command-to-continue-prompt-in-vim
function! s:Registar_Normal_ReMaps() abort
  for [l:key_configurations, l:value_configurations] in items(g:markdown_surrounds['elements'])
    if exists('l:value_configurations.nnoremap')
      for [l:key_nnoremap, l:value_nnoremap] in items(l:value_configurations['nnoremap'])
        let l:function_name = 'MarkDown_Surrounds__Current_' . s:Title_Case_Word(l:key_nnoremap)
        for l:file_extension in g:markdown_surrounds['file_extensions']
          execute 'autocmd BufNewFile,BufRead *.' . l:file_extension
                \ 'nnoremap <buffer>' l:value_nnoremap ':call' l:function_name
                \ . '("' . l:key_configurations . '")<CR>'
        endfor
      endfor
    endif
  endfor
endfunction


""
"
function! s:Title_Case_Word(word) abort
  let l:first_letter = toupper(a:word[0])
  if len(a:word) > 1
    return l:first_letter . tolower(a:word[1:-1])
  else
    return l:first_letter
  endif
endfunction


""
" Toggles surrounded state for big-word
" Returns: {string}
" Parameter: {dict | string} a:key_configuration
" Parameter: {number}        a:key_configuration.preferred_index
" Parameter: {dict[]}        a:key_configuration.patterns
" Parameter: {dict | string} a:key_configuration.patterns[_]regexp
" Parameter: {dict | string} a:key_configuration.patterns[_]characters
" Parameter: {string?}       a:000[0]
" Example: input string >
"   :echo s:MarkDown_Surrounds__Toggle_Word('bold', '**foo**')
" <
" Example: toggled output >
"   foo
" <
" Example: constructed regular expression >
"   ^_[^\(_\)]\([[:print:]]*[^\(_\)]\)_$
" <
" Example: matching input >
"   _foo_
" <
" Example: non-matching input >
"   __foo__
" <
function! s:MarkDown_Surrounds__Toggle_Word(key_configuration, ...) abort
  let l:current_file_extension = expand('%:e')
  let l:current_file_type = &filetype

  if a:0 == 0
    let l:current_word = expand('<cWORD>')
  elseif type(a:000[0]) == type('')
    let l:current_word = a:000[0]
  endif

  if ( l:current_file_extension != 'md' || l:current_file_type != 'markdown' )
  \ || len(l:current_word) == 0
    return
  endif

  if type(a:key_configuration) == type({})
    let l:configuration = a:key_configuration
  elseif type(a:key_configuration) == type('')
    let l:configuration = g:markdown_surrounds['elements'][a:key_configuration]
  else
    throw 'Type error:' string(a:key_configuration) 'is not "v:t_string" or "v:t_dict"'
  endif

  for l:value in l:configuration['patterns']
    if type(l:value['regexp']) == type({})
      let l:regexp_begin = l:value['regexp']['begin']
      let l:regexp_end = get(l:value['regexp'], 'end', l:regexp_begin)
    elseif type(l:value['regexp']) == type('')
      let l:regexp_begin = l:value['regexp']
      let l:regexp_end = l:regexp_begin
    else
      throw 'Type error:' l:value 'is not "v:t_string" or "v:t_dict"'
    endif

    let l:regexp = '^' . l:regexp_begin
    let l:regexp .= '[^\(' . l:regexp_begin . '\)]'
    let l:regexp .= '\([[:print:]]*[^\(' . l:regexp_end . '\)]\)'
    let l:regexp .= l:regexp_end . '$'
    if l:current_word =~ l:regexp
      if type(l:value['characters']) == type({})
        let l:characters_begin = l:value['characters']['begin']
        let l:characters_end = get(l:value['characters'], 'end', l:characters_begin)
      elseif type(l:value['characters']) == type('')
        let l:characters_begin = l:value['characters']
        let l:characters_end = l:characters_begin
      else
        throw 'Type error: type(' . l:value['characters'] . ') is not "v:t_string" or "v:t_dict"'
      endif

      let l:new_word = l:current_word[len(l:characters_begin):-(1 + len(l:characters_end))]
      break
    endif
  endfor

  if !exists('l:new_word')
    let l:preferred_index = get(l:configuration, 'preferred_index', 0)
    if type(l:configuration['patterns'][l:preferred_index]['characters']) == type({})
      let l:characters_begin = l:configuration['patterns'][l:preferred_index]['characters']['begin']
      let l:characters_end = get(l:configuration['patterns'][l:preferred_index]['characters'], 'end', l:characters_begin)
    elseif type(l:configuration['patterns'][l:preferred_index]['characters']) == type('')
      let l:characters_begin = l:configuration['patterns'][l:preferred_index]['characters']
      let l:characters_end = l:characters_begin
    else
      throw 'Type error: type(l:configuration["patterns"][' . l:preferred_index . ']["characters"]) is not "v:t_string" or "v:t_dict"'
    endif

    let l:new_word = l:characters_begin . l:current_word . l:characters_end
  endif

  return l:new_word
endfunction


""
" Toggles surrounded state for big-word under cursor
" Parameter: {dict | string} a:key_configuration
" Parameter: {number}        a:key_configuration.preferred_index
" Parameter: {dict[]}        a:key_configuration.patterns
" Parameter: {dict | string} a:key_configuration.patterns[_]regexp
" Parameter: {dict | string} a:key_configuration.patterns[_]characters
function! MarkDown_Surrounds__Current_Word(key_configuration) abort
  let l:current_file_extension = expand('%:e')
  let l:current_file_type = &filetype
  let l:current_word = expand('<cWORD>')

  if ( l:current_file_extension != 'md' || l:current_file_type != 'markdown' )
  \ || len(l:current_word) == 0
    return
  endif

  let l:new_word = s:MarkDown_Surrounds__Toggle_Word(a:key_configuration, l:current_word)
  if len(l:new_word) == 0
    return
  endif

  let l:cursor_position = getpos('.')
  let l:column_offset = (len(l:current_word) - len(l:new_word)) / 2
  let l:cursor_position[2] -= l:column_offset

  execute 'normal! "_ciW' . l:new_word
  call setpos('.', l:cursor_position)
endfunction


""
" Toggles surrounded state for line
" Parameter: {dict | string}     a:key_configuration
" Parameter: {number}            a:key_configuration.preferred_index
" Parameter: {dict[]}            a:key_configuration.patterns
" Parameter: {dict | string}     a:key_configuration.patterns[_]regexp
" Parameter: {dict | string}     a:key_configuration.patterns[_]characters
" Parameter: {number? | string?} a:000[0]
" Example: input string >
"   :echo s:MarkDown_Surrounds__Toggle_Line('bold', '> 1. Spam flavored ham')
" <
" Example: output >
"   1. **Spam flavored ham**
" <
" Example: input dictionary >
"   :call s:MarkDown_Surrounds__Toggle_Line({
"         \   'preferred_index': 0,
"         \   'nnoremap': {
"         \     'word': '<Leader>b',
"         \     'line': '<Leader>B',
"         \   },
"         \   'patterns': [
"         \     {
"         \       'regexp': {
"         \         'begin': '\*\*',
"         \         'end': '\*\*',
"         \       },
"         \       'characters': {
"         \         'begin': '**',
"         \         'end': '**',
"         \       },
"         \     },
"         \     {
"         \       'regexp': {
"         \         'begin': '__',
"         \         'end': '__',
"         \       },
"         \       'characters': {
"         \         'begin': '__',
"         \         'end': '__',
"         \       }
"         \     },
"         \   ]
"         \ },
"         \ '1. __Spam flavored ham__')
" <
" Example: toggled output >
"   1. Spam flavored ham
" <
function! s:MarkDown_Surrounds__Toggle_Line(key_configuration, ...) abort
  let l:current_file_extension = expand('%:e')
  let l:current_file_type = &filetype

  if a:0 == 0
    let l:current_line = getline('.')
  elseif type(a:000[0]) == type(0)
    let l:current_line = getline(a:000[0])
  elseif type(a:000[0]) == type('')
    let l:current_line = a:000[0]
  endif

  if ( l:current_file_extension != 'md' || l:current_file_type != 'markdown' )
  \ || len(l:current_line) == 0
    return
  endif

  let l:matched__blockquote = matchstr(l:current_line, '^>*')
  if len(l:matched__blockquote) == 0
    let l:current_line__content = l:current_line
  else
    let l:current_line__content = l:current_line[len(l:matched__blockquote):-1]
  endif

  let l:matched__indentation = matchstr(l:current_line__content, '^[[:space:]]*')
  if len(l:matched__indentation) > 0
    let l:current_line__content = l:current_line__content[len(l:matched__indentation):-1]
  endif

  let l:matched__unordered_list = matchstr(l:current_line__content, '^\(-\|\*\)[[:space:]]\+')
  let l:matched__ordered_list = matchstr(l:current_line__content, '^[0-9]*\.[[:space:]]\+')
  if len(l:matched__unordered_list) > 0
    let l:current_line__content = l:current_line__content[len(l:matched__unordered_list):-1]
  elseif len(l:matched__ordered_list) > 0
    let l:current_line__content = l:current_line__content[len(l:matched__ordered_list):-1]
  endif

  let l:matched__trailing_space = matchstr(l:current_line__content, '[[:space:]]*$')
  if len(l:matched__trailing_space) > 0
    let l:current_line__content = l:current_line__content[0:-(1 + len(l:matched__trailing_space))]
  endif

  if len(l:current_line__content) == 0
    return
  endif

  if type(a:key_configuration) == type({})
    let l:configuration = a:key_configuration
  elseif type(a:key_configuration) == type('')
    let l:configuration = g:markdown_surrounds['elements'][a:key_configuration]
  else
    throw 'Type error:' string(a:key_configuration) 'is not "v:t_string" or "v:t_dict"'
  endif

  for l:value in l:configuration['patterns']
    if type(l:value['regexp']) == type({})
      let l:regexp_begin = l:value['regexp']['begin']
      let l:regexp_end = get(l:value['regexp'], 'end', l:regexp_begin)
    elseif type(l:value['regexp']) == type('')
      let l:regexp_begin = l:value['regexp']
      let l:regexp_end = l:regexp_begin
    else
      throw 'Type error: type(' . l:value . ') is not "v:t_string" or "v:t_dict"'
    endif

    let l:regexp = '^' . l:regexp_begin
    let l:regexp .= '[^\(' . l:regexp_begin . '\)]'
    let l:regexp .= '\([[:print:]]*[^\(' . l:regexp_end . '\)]\)'
    let l:regexp .= l:regexp_end . '$'
    if l:current_line__content =~ l:regexp
      if type(l:value['characters']) == type({})
        let l:characters_begin = l:value['characters']['begin']
        let l:characters_end = get(l:value['characters'], 'end', l:characters_begin)
      elseif type(l:value['characters']) == type('')
        let l:characters_begin = l:value['characters']
        let l:characters_end = l:characters_begin
      else
        throw 'Type error: type(' . l:value['characters'] . ') is not "v:t_string" or "v:t_dict"'
      endif

      let l:new_line__content = l:current_line__content[len(l:characters_begin):-(1 + len(l:characters_end))]
      break
    endif
  endfor

  if !exists('l:new_line__content')
    let l:preferred_index = get(l:configuration, 'preferred_index', 0)
    if type(l:configuration['patterns'][l:preferred_index]['characters']) == type({})
      let l:characters_begin = l:configuration['patterns'][l:preferred_index]['characters']['begin']
      let l:characters_end = get(l:configuration['patterns'][l:preferred_index]['characters'], 'end', l:characters_begin)
    elseif type(l:configuration['patterns'][l:preferred_index]['characters']) == type('')
      let l:characters_begin = l:configuration['patterns'][l:preferred_index]['characters']
      let l:characters_end = l:characters_begin
    else
      throw 'Type error: type(l:configuration["patterns"][' . l:preferred_index . ']["characters"]) is not "v:t_string" or "v:t_dict"'
    endif

    let l:new_line__content = l:characters_begin . l:current_line__content . l:characters_end
  endif

  let l:new_line = l:matched__blockquote . l:matched__indentation
  if len(l:matched__unordered_list) > 0
    let l:new_line .= l:matched__unordered_list
  elseif len(l:matched__ordered_list) > 0
    let l:new_line .= l:matched__ordered_list
  endif
  let l:new_line .= l:new_line__content . l:matched__trailing_space

  return l:new_line
endfunction


""
" Toggles surrounded state for current line under cursor
function! MarkDown_Surrounds__Current_Line(key_configuration) abort
  let l:current_file_extension = expand('%:e')
  let l:current_file_type = &filetype
  let l:current_line = getline('.')

  if ( l:current_file_extension != 'md' || l:current_file_type != 'markdown' )
  \ || len(l:current_line) == 0
    return
  endif

  let l:new_line = s:MarkDown_Surrounds__Toggle_Line(a:key_configuration, l:current_line)
  if len(l:new_line) == 0
    return
  endif

  let l:cursor_position = getpos('.')
  let l:column_offset = (len(l:current_line) - len(l:new_line)) / 2
  let l:cursor_position[2] -= l:column_offset

  execute 'normal! 0"_C' . l:new_line
  call setpos('.', l:cursor_position)
endfunction


""
" Register re-maps after all functions are declared
call s:Registar_Normal_ReMaps()

