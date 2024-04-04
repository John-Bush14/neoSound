local M = {}
local default_provider = "local"
local builtin_field = {formatted = true}

local play_sound = {
   ["local"] = function(sound) -- local file
   end,
   ["youtube"] = function(sound) end,
   ["soundcloud"] = function(sound) end
}

function M.setup(soundpacks)
   if soundpacks == nill then return end
   vim.g.soundpacks = soundpacks
end

function M.get_sounds()
   soundpacks = vim.g.soundpacks
   if soundpacks.formatted == nil then 
      soundpacks.formatted = ""
      for spname, soundpack in pairs(soundpacks) do
         if builtin_field[spname] then goto continue end
         soundpacks.formatted = soundpacks.formatted .. spname .. ": \n\n"
         for sname, sound in pairs(soundpack) do 
            soundpacks.formatted = soundpacks.formatted .. sname .. ": " .. sound .. "\n"
         end
         ::continue::
      end
      vim.g.soundpacks = soundpacks
   end
   print(vim.g.soundpacks.formatted)
end

function M.choose_sound(sound)
   return
end

return M
