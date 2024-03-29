local M = {}
local default_provider = "local"
local uv = vim.uv
local pack_folder = "soundpacks/"
vim.cmd("set shellquote=\"")

local import_sound = {
   ["local"] = function(sound, destination) -- local file
      function import_source(source, destination) 
	 if string.match(source, "#") then return end
         local command = string.format("!cp %s ~/%s", vim.fn.shellescape(source), destination)
         vim.cmd(command) 
      end

      if not (string.sub(sound, -1) == "/") then 
         import_source(sound, destination)
         return
      end

      local dir = uv.fs_scandir(string.sub(sound, #sound-1))

      if dir then 
         repeat 
            local file_name, type = uv.fs_scandir_next(dir)
            if file_name and type == "file" then
               import_source(sound .. file_name, destination)
            end
         until not file_name
      end
   end,

   ["youtube"] = function(sound, destination) end,
}

function M.setup(soundpacks)
   if soundpacks == nill then return end
   if vim.fn.isdirectory(pack_folder) == 0 then
      vim.fn.mkdir(pack_folder, 'p')
   else 
      vim.fn.system("rm -rf " .. pack_folder)
      vim.fn.mkdir(pack_folder) 
   end

   for _k, soundpack in pairs(soundpacks) do
      local sounds = soundpack["sounds"]
      vim.fn.mkdir(pack_folder .. soundpack["name"])
      for k, sound in pairs(sounds) do
         local provider = "local"
         if string.match(sound, "youtube.com") then provider = "youtube" end
         import_sound[provider](sound, pack_folder .. soundpack["name"])
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
