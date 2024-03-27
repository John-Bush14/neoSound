if exists("g:loaded_neoSound")
    finish
endif
let g:loaded_neoSound = 1

command! -nargs=0 GetSounds lua require("neoSound").get_sounds()
command! -nargs=1 Sound lua require("neoSound").choose_sound(<args>)
