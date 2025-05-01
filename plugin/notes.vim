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
call s:set('g:NoteSuffix', '.md' )

function! FindInNote( )
   let l:SearchPattern = input( "Search String: " )
   if empty( l:SearchPattern )
      return 1
   endif
   let l:SearchPattern = "\"" .  l:SearchPattern . "\""
   execute "grep -R --include \\\*" . g:NoteSuffix . ' ' . l:SearchPattern . " " . g:NotesDir
   let l:FileList = getqflist()
   if !empty( l:FileList )
      copen
      1cc
   endif
endfunction


function! FindNote( )
   let l:SearchPattern = input( "Search String: " )
   if empty( l:SearchPattern )
      return 1
   endif
   let l:FindCommand = "find -L \"" . g:NotesDir . "\" -type f -name '*" . g:NoteSuffix . "' | grep -i \"" . l:SearchPattern . "\""
   let l:Mylist = systemlist( l:FindCommand )
	let fileList = []
   for item in l:Mylist
      "get file name
      let Dict = {}
      let Dict['filename'] = item
      let Dict['lnum'] = 1
      call add( fileList , Dict )
   endfor
   call setqflist( fileList, 'r' )
   if !empty( fileList )
      copen
      1cc
   endif
endfunction


function! NewNoteWithPath()
   let l:NoteFile = input( "Open: ", g:NotesDir . "/", "file" )
   let l:NoteName = substitute( l:NoteFile, g:NotesDir . '\/', "",  'g' )
   let l:NoteName = substitute( l:NoteName, '\ *', "", 'g' )
   if  empty( l:NoteName )
      return 1
   endif
   let l:NoteRoot = substitute( l:NoteFile, '\(.*\)\/.*', '\1', 'g' )
   let l:NoteFile = substitute( l:NoteFile, '\ ','\\\ ', 'g') 
   if !isdirectory( l:NoteRoot )
      call mkdir( l:NoteRoot,'p')
      call mkdir( l:NoteRoot . '/images','p')
      call mkdir( l:NoteRoot . '/files','p')
   endif
   if l:NoteFile !~ g:NoteSuffix
      execute "edit " . l:NoteFile . g:NoteSuffix
   else
      execute "edit " . l:NoteFile
   endif
endfunction

function! DeleteNote()
   let l:FilePath = expand("%")
   bd!
   execute "!rm \"" . l:FilePath . "\""
endfunction

function! NoteRoot( )
   let l:NoteFile = expand( '%' )
   if l:NoteFile !~ '/'
      let l:NoteRoot = '.'
   else
      let l:NoteRoot = substitute( l:NoteFile, '\(.*\)\/.*', '\1', 'g' )
   endif
   return l:NoteRoot
endfunction

function! FindAndCopyFile( fileName, dest )
   let l:NoteRoot = NoteRoot()
   let l:FileDest = l:NoteRoot . '/' . a:dest
   silent! let l:MimeTypes = systemlist( 'xclip -selection clip -t TARGETS -o' )
   let l:Path = ''
   for item in l:MimeTypes
      if item =~ 'uri-list'
         silent! let l:Path = system('xclip -selection clip -t text/uri-list -o')
         break
      endif
   endfor
   let l:Extn = substitute( l:Path, '..*\.\(.*\)\r.*', '\1', 'g')
   let l:Path = substitute( l:Path, 'file:\/\/\(.*\)\r.*', '\1', 'g')
   silent! call system('xclip -i ' . l:Path)
   if !isdirectory( fnameescape(l:FileDest) )
      call mkdir( fnameescape(l:FileDest), 'p' )
   endif
   let l:fullPath = shellescape(l:FileDest . '/' . a:fileName . '.' . l:Extn )
   silent! call system( 'xclip -o >' . l:fullPath )
   return l:Extn
endfunction

function! AddImage( fileName )
   let l:NoteRoot = NoteRoot()
   let l:ImageDest = l:NoteRoot . '/images'
   if !isdirectory( fnameescape(l:ImageDest) )
      call mkdir( fnameescape(l:ImageDest), 'p' )
   endif
   let l:fullPath = l:ImageDest . '/' . a:fileName
   silent! let l:MimeTypes = systemlist( 'xclip -selection clip -t TARGETS -o' )
   let l:Mime = ''
   for item in l:MimeTypes
      if item =~ 'image'
         let l:Mime = item
         break
      endif
   endfor
   let l:Extn = ''
   if l:Mime =~ 'png'
      let l:Extn = 'png'
   elseif l:Mime =~ 'jpeg'
      let l:Extn = 'jpg'
   endif
   if '' != l:Extn
      let l:Expr = 'xclip -selection clip -t ' . l:Mime. ' -o > ' . l:fullPath . '.' . l:Extn
      silent! call system( l:Expr )
   else
      let l:Extn = FindAndCopyFile( a:fileName, 'images' )
   endif
   if 0 == v:shell_error
      let l:Link = "![](./images/" . a:fileName . '.' . l:Extn . ")"
      put =l:Link
   endif
endfunction

function! AddFile()
   let l:text = input( "Link Text: " )
   let l:fileName = input( "Save as[no extn]: " )
   let l:Extn = FindAndCopyFile( l:fileName, 'files' )
   if 0 == v:shell_error
      let l:Link = "[" . l:text . "](./files/" . l:fileName . '.' . l:Extn . ")"
      put =l:Link
      normal kJ$
   endif
endfunction

function! MarkDownToHtml()
   let l:Output = NoteRoot()
   let l:ImgDir = NoteRoot() . "/images/plantUML"
   let l:Output = l:Output . "/" . expand("%:p:t:r") . ".html"
   let l:command = "pandoc -f markdown -t html  --standalone \"" . expand("%:p") . "\" -o \"" . l:Output . "\""
   silent! call system( l:command   )
   let l:umlcmd = "mkdir -p " . l:ImgDir . "; plantuml -o " . l:ImgDir . " " . expand("%")
   silent call system( l:umlcmd   )
endfunction

command! NewNote call NewNoteWithPath()
command! DeleteNote call DeleteNote()
command! -nargs=1 AddImage call AddImage( <f-args> )
command!  AddFile call AddFile(  )
