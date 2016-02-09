# Markdown notes management in vim

## Introduction
Provides a simple and flexible infrastructure within vim to manage notes. The
aim is to provide simple and flexible commands to assist in finding notes,
finding text in notes and in creation of new notes either at the top level of
the notes database folder or in any subdirectory of choice.

## Features supported
The below features are currently implemented
   * Binding to recursively look for an expression in the notes database
   * Finding a note in the database
   * Binding to create a note in the notes database

## Installation
The plug-in can be installed by cloning or adding as submodule, the git
repository to the directory maintained by Pathogen. Alternatively, the contents
of the plug-in folder can be copied to the vim runtime folder in the home
directory.

## Configuration
Two variables g:NotesDir and g:HtmlDir need to be defined in the vimrc. They
should point to the root directory of the folder in which you wish to maintain
notes and the top folder for HTML exports respectively.  Both variables have the below defaults.

    let g:NotesDir =  '~/Documents/notes'
    let g:HtmlDir = '~/Documents/html-notes'

It is also useful to have the below default mappings

    nmap <Leader>nn :call NewNoteWithPath()<CR> 
    nmap <Leader>fn :call FindNote()<CR>
    nmap <Leader>sn :call FindInNote()<CR>


