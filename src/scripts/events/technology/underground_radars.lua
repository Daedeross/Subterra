local spawn_ghost_radars = require("__subterra__.scripts.events.technology.spawn_ghost_radars")

local underground_radars = function(research, by_script)
    spawn_ghost_radars(research.force, research.level)
end

return underground_radars