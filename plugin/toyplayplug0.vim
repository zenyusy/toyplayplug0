if exists('g:loaded_toyplayplug0')
    finish
endif
let g:loaded_toyplayplug0 = 1

command! ToyPlayPlug0 lua require'toyplayplug0'.setup()
