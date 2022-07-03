if exists('g:loaded_toyplayplug0')
    finish
endif
let g:loaded_toyplayplug0 = 1

command! ToyPlayPlug0 lua require'toyplayplug0'.setup()

augroup toyplayplug0keybind
    autocmd! toyplayplug0keybind
    autocmd Filetype lua nno <buffer> <silent> <F9> :lua require'toyplayplug0'.setup()<CR>
augroup end
