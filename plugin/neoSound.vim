if exists("g:loaded_neoSound")
    finish
endif
let g:loaded_neoSound = 1

command! -nargs=0 GetSounds lua require("neoSound").get_sounds()
command! -nargs=1 Play call v:lua.require("neoSound").play_user(<f-args>)
command! -nargs=1 Skip lua require("neoSound").skip(<f-args>)
command! -nargs=1 Shuffle let g:shuffle = <args>
command! -nargs=1 Repeat let g:repeat = <args>
command! -nargs=1 Help lua print("<f-args>")
command! -nargs=0 Vid lua require("neoSound").vid()
