local M = {}
local default_provider = "local"

local import_sound = {
   ["local"] = function(sound) -- local file
   end,
   ["youtube"] = function(sound) end,
   ["spotify"] = function(sound) end
}

function M.setup(soundpacks)
   if soundpacks == nill then return end
   for soundpack_index = 1, #soundpacks do
      local soundpack = soundpacks[soundpack_index]
      local sounds = soundpack["sounds"]

      for sound_index = 1, #sounds do
         local sound = sounds[sound_index]
	      if soundpack["provider"] == nil then
	         soundpack["provider"] = default_provider
         end
         import_sound[soundpack["provider"]](sound)
      end
   end
end

function M.get_sounds()
   return 
end

function M.choose_sound(sound)
   return
end

return M
