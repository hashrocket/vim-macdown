" macdown.vim - write markdown in Vim with live-reloads in MacDown
" Author: Dillon Hafer, Josh Branchaud (hashrocket.com)
" Version: 0.1


if exists('g:loaded_vim_macdown')
  finish
endif
let g:loaded_vim_macdown = 1
let g:macdown_enabled = 1

if !has('macunix') && !(system('uname') =~ "Darwin")
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
  if g:macdown_enabled == 0
    return 0
  endif

  let path = expand("%p")
  let refresh = "osascript -e 'tell application \"MacDown\" to close window 1' ; open -g -F ".path." -a \"MacDown\""
  if has('nvim')
    call jobstart(["bash", "-c", refresh], {"exit_cb": "MacDownHandleScriptFinished"})
  else
    call job_start(["bash", "-c", refresh], {"exit_cb": "MacDownHandleScriptFinished"})
  endif
endfunction

function! MacDownHandleScriptFinished(job, status)
  if a:status == 0
    call s:EchoSuccess("MacDown refreshed ♻️ ")
  else
    call s:EchoError("[FAIL] Run :InstallMacDown to download MacDown")
  endif
endfunction

function! s:EchoSuccess(msg)
  redraw | echohl Function | echom "vim-macdown: " . a:msg | echohl None
endfunction

function! s:EchoError(msg)
  redraw | echohl ErrorMsg | echom "vim-macdown: " . a:msg | echohl None
endfunction

function! s:EchoProgress(msg)
  redraw | echohl Identifier | echom "vim-macdown: " . a:msg | echohl None
endfunction

function! s:InstallMacDown()
  call s:EchoProgress("MacDown is downloading ⏳ ")
  let tmpdir   = "~/.md-tmp"
  let zipfile  = tmpdir."/macdown.zip"

  let mkdir    = "mkdir -p ".tmpdir." && "
  let download = "curl -L https://github.com/MacDownApp/macdown/releases/download/v0.7.1/MacDown.app.zip -o ".zipfile." && "
  let unzip    = "unzip -o ".zipfile." -d ".tmpdir." >> /dev/null 2>&1"." && "
  let cleanup  = "rm -f ".zipfile." && "
  let link     = "ln -Ffs /Applications ".tmpdir."/Applications"." && "
  let install  = "open ".tmpdir


  let full_command = mkdir.download.unzip.cleanup.link.install
  if has('nvim')
    call jobstart(["bash", "-c", full_command], {"exit_cb": "MacDownHandleDownloadFinished"})
  else
    call job_start(["bash", "-c", full_command], {"exit_cb": "MacDownHandleDownloadFinished"})
  endif
endfunction

function! MacDownHandleDownloadFinished(job, status)
  if a:status == 0
    call s:EchoSuccess("MacDown downloaded ✅  ")
  else
    call s:EchoError("[FAIL] MacDown could not be downloaded. ".a:job)
  endif
endfunction

function! s:MacDownClose()
  if g:macdown_enabled == 0
    return 0
  endif

  let close_cmd = "osascript -e 'tell application \"MacDown\" to close window 1'"
  if has('nvim')
    call jobstart(["bash", "-c", close_cmd], {"exit_cb": "MacDownHandleCloseFinished"})
  else
    call job_start(["bash", "-c", close_cmd], {"exit_cb": "MacDownHandleCloseFinished"})
  endif
endfunction

function! MacDownHandleCloseFinished(job, status)
  if a:status == 0
    call s:EchoSuccess("MacDown closed")
  else
    call s:EchoError("[FAIL] Run :MacDownClose to close MacDown")
  endif
endfunction

function! s:MacDownExit()
  if g:macdown_enabled == 0
    return 0
  endif

  " Necessary when exiting vim.  If use job_start, Vim will exit and MacDown
  " will not close
  let tmp = system("bash -c \"osascript -e 'tell application \"'\"'\"MacDown\"'\"'\" to close window 1'\"")
endfunction

function! s:MacDownOn()
  let g:macdown_enabled = 1
    call s:EchoSuccess("MacDown enabled")
endfunction

function! s:MacDownOff()
  let g:macdown_enabled = 0
    call s:EchoSuccess("MacDown disabled")
endfunction


command InstallMacDown :execute s:InstallMacDown()
command MacDownPreview :call <SID>MacDownMarkdownPreview()
command MacDownClose :call <SID>MacDownClose()
command MacDownExit :call <SID>MacDownExit()
command MacDownOff :call <SID>MacDownOff()
command MacDownOn :call <SID>MacDownOn()

nnoremap <leader>p :MacDownPreview<cr>


let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set sw=2 sts=2:
