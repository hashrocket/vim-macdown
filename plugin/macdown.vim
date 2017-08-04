" macdown.vim - write markdown in Vim with live-reloads in MacDown
" Author: Dillon Hafer, Josh Branchaud (hashrocket.com)
" Version: 0.1


if exists('g:loaded_vim_macdown')
  finish
endif
let g:loaded_vim_macdown = 1

if !has('macunix') || !(system('uname') =~ "Darwin")
  echo 'macdown.vim only works on a Mac'
  finish
endif

" check if Macdown is available on this machine

let s:save_cpo = &cpo
set cpo&vim


" - can <leader>p open the macdown preview if it isn't already open?
" - what do we do with a new markdown file, markdown files that haven't been
"   opened in macdown yet, etc?


function! s:MacDownMarkdownPreview()
  let path = expand("%p")
  let refresh = "osascript -e 'tell application \"MacDown\" to close window 1' ; open -g -F ".path." -a \"MacDown\""
  call job_start(["bash", "-c", refresh])
endfunction

nnoremap <leader>p :call <SID>MacDownMarkdownPreview()<cr>


let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set sw=2 sts=2:
