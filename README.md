# Markdown notes management in vim

## Introduction
Provides a simple and flexible infrastructure within vim to manage notes. The
aim flexible commands to assist in finding notes, finding text within notes and
in creation of new notes either at the top level of the notes database or in any
subdirectory of choice. Based on your note taking approach, sub folders can be
viewed as projects or notebooks or just logical compartments for notes.

## Feature Overview
The below features are currently implemented
   * Binding to recursively look for an expression in the notes database irrespective of the current working directory in vim.
   * Mechanism to find a note in the notes database.
   * Mapping to created a new note at the root folder of the notes database or in any subfolder without having to bother about folder management.
   * Exporting note as an HTML document

## Installation
The plug-in can be installed by cloning or adding as sub-module, the git
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

## Features in detail

### Creating new notes
_<Leader>nn_ would prompt the user to enter the file name for the new note. The
vim command line is pre-filled with the base path of the notes database and
supports filename completion. So this mechanism can be used to open existing
notes as well.  Notes creation handles below cases.
   * If a series of sub-directories are specified in the path to the new note, these directories would be created.
      * This enables new projects (or just folders based on your approach to note taking) to be defined on the go.
      * File name auto completion helps you select a project/sub-project.
      * CTRL-D can be used to view alternatives since vim supports this natively for filename completion.
   * File names need not have an extension.  The plug-in takes care of appending .md to the file while saving it.

### Finding an expression in notes
When _<Leader>sn_ in input, you would be asked to key in a search string. The
search string is directly passed to vimgrep, so any valid vimgrep expression is
supported.  The search results are populated in the quick fix window.

### Finding notes
You can look for a note in the notes database using _<Leader>fn_. Vim will
perform a case insensitive search for filenames matching the search query. The
results are again populated in the quick-fix list and vim would just to the
first occurrence in the list. _Search is performed using grep and not vimgrep in
this case_.

## Limitations and action items
The plug-in has be below limitations at the moment
   * The find and grep commands are used to find notes at the moment.  So this feature might not work in windows. 
   * The file extension can only be _.md_.  This needs to be made configurable.
   * Markdown to HTML support needs to be incorporated.

