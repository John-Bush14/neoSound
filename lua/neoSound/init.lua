local M = {}
local default_provider = "local"
local builtin_fields = {formatted = true, opts = true, waitlist = true}
local default_repeat = 0
local defaults_shuffle = false

local play_sound = {
   ["local"] = function(sound) -- local file
   end,
   ["youtube"] = function(sound) end,
   ["soundcloud"] = function(sound) end
}

function M.setup(soundpacks)
   if soundpacks == nill then return end
   vim.g.soundpacks = soundpacks
   opts = soundpacks.opts
   vim.g["repeat"] = opts["repeat"] or default_repeat --repeat is a keyword :'(
   vim.g.shuffle = opts.shuffle or default_shuffle
end

function M.get_sounds()
   soundpacks = vim.g.soundpacks
   if soundpacks.formatted == nil then 
      soundpacks.formatted = ""
      for spname, soundpack in pairs(soundpacks) do
         if builtin_fields[spname] then goto continue end
         soundpacks.formatted = soundpacks.formatted .. spname .. ": \n\n"
         for sname, sound in pairs(soundpack) do 
            if builtin_fields(spname) then goto continue end
            soundpacks.formatted = soundpacks.formatted .. sname .. ": " .. sound .. "\n"
         end
         ::continue::
      end
      vim.g.soundpacks = soundpacks
   end
   print(vim.g.soundpacks.formatted)
end

function table.find(tbl, value)
    for k, v in pairs(tbl) do
        if v == value then
            return k
        end
    end
    return nil
end

function table.len(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

function M.play(playable)
   if playable == "cur" then
      playable = vim.g.cur_soundp.waitlist[tostring(vim.g.cur_soundp.waitlist.index)]
   end
   if vim.g.soundpacks[playable] ~= nil then
      vim.g.cur_soundp = vim.g.soundpacks[playable]
      local soundp = vim.g.soundpacks[playable]
      
      local waitlist = {}
      if vim.g.shuffle then
         for _soundn, sound in pairs(soundp) do
            ::randomize::
            local index = math.random(table.len(soundp))
            if waitlist[tostring(index)] ~= nil then goto randomize end
            waitlist[tostring(index)] = sound
         end
         goto shuffleskip
      end 
      waitlist = soundp
      ::shuffleskip::
 
      waitlist[tostring(table.len(waitlist)+1)] = "END"
      playable = waitlist["1"]
      waitlist.index = 0
      soundp.waitlist = waitlist
      vim.g.cur_soundp = soundp
   end
   if type(vim.g.cur_soundp) == "table" and (vim.g.cur_soundp[playable] ~= nil or table.find(vim.g.cur_soundp, playable) ~= nil) then
      local sound = vim.g.cur_soundp[playable]
      if sound == nil then
         sound = playable
      end
      vim.cmd("FloatermNew! --name=test --autoclose=1 --silent mpv -oa " .. sound .. " &")
   end
end

function M.skip(amount)
   vim.g.cur_soundp.waitlist.index = vim.g.cur_soundp.waitlist.index + amount
   if vim.g.cur_soundp.waitlist[tostring(vim.g.cur_soundp.waitlist.index)] == "END" or vim.g.cur_soundp.waitlist[tostring(vim.g.cur_soundp.waitlist.index)] == nil then
      vim.g.cur_soundp.waitlist.index = 0
   end
end

return M
