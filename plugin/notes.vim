scriptencoding utf-8

function! s:set(var, default)
  if !exists(a:var)
    if type(a:default)
      execute 'let' a:var '=' string(a:default)
    else
      execute 'let' a:var '=' a:default
    endif
  endif
endfunction

call s:set('g:NotesDir', $HOME .'/Documents/notes')
call s:set('g:HtmlDir', $HOME .'/Documents/html-notes')

function! FindInNote( )
   let l:SearchPattern = input( "Search String: " )
  execute "vimgrep /" . l:SearchPattern . "/j" . g:NotesDir . "/**/*.md"
  copen
endfunction


function! FindNote( )
   let l:SearchPattern = input( "Search String: " )
   set errorformat+=%f
  execute "cexpr system(\'find " . g:NotesDir . " -type f \\| grep -i \"". l:SearchPattern . "\"\')" 
   set errorformat-=%f
endfunction


function! NewNoteWithPath()
   let l:NoteFile = input( "Open: ", g:NotesDir . "/", "file" )
   let l:NoteRoot = substitute( l:NoteFile, '\(.*\)\/.*', '\1', 'g' )
   let l:NoteFile = substitute( l:NoteFile, '\ ','\\\ ', 'g') 
   if !isdirectory( l:NoteRoot )
      call mkdir( l:NoteRoot,'p')
   endif
   if l:NoteFile !~ '\.md$'
      execute "edit " . l:NoteFile . "\.md"
   else
      execute "edit " . l:NoteFile
   endif
endfunction

function! PythonMarkDownToHtml()
   let l:Output = g:HtmlDir . "/" . expand("%:p:t:r") . ".html"
   let l:Stylesheet = g:HtmlDir . "/vimNotesStyleSheet.css"
   execute "!python ~/markdownCSS_py.py \"" . expand("%:p") . "\" \"" . l:Stylesheet . "\""  . " \"".  l:Output . "\""
endfunction

command! NewNote call NewNoteWithPath()
