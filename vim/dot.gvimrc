if has("gui_win32")
  source ~/_vimrc
else
  source ~/.vimrc
endif

if has("gui_running")
  if has("gui_macvim")
    set guifont=M+1VM+IPAG_circle:h14
    set printfont=M+2VM+IPAG_circle:h14
    set fuoptions=maxvert,maxhorz
    set fullscreen
    set transparency=20
    set imdisable
    set showtabline=2
  elseif has("gui_gtk2")

  elseif has("gui_win32")
    set guifont=M+1VM+IPAG_circle:h9
    set printfont=M+2VM+IPAG_circle:h9
  endif
endif

""" Japanese input etc settings {{{
set noimdisable
set noimcmdline
set iminsert=1
set imsearch=1
"}}}

" vim:set fileencoding=UTF-8 expandtab :
