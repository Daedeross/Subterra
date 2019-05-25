local update_radar_proxies = require("__subterra__.scripts.events.technology.update_radar_proxies")

local underground_radars = function(research, by_script)
    update_radar_proxies(research.force, research.level)
end

return underground_radars