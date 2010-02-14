if has("gui_running")
  if has("gui_macvim")
    set gfn=M+1VM+IPAG_circle:h14
    set pfn=M+2VM+IPAG_circle:h14
    set fuoptions=maxvert,maxhorz
    set fullscreen
    set transparency=8
    set imdisable
    set showtabline=2
  elseif has("gui_gtk2")

  elseif has("gui_win32")
    set gfn=M+1VM+IPAG_circle:h12
    set pfn=M+2VM+IPAG_circle:h12
  endif
endif

source ~/.vimrc

" vim:set fileencoding=UTF-8 expandtab :
