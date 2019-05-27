local update_radar_proxies = require("__subterra__.scripts.events.technology.update_radar_proxies")
--============================================================================--
-- underground_radars_researched(research, by_script)
--
-- Helper method that gets the current level of a player proxy
--
-- param research (LuaTechnology): The tech just researched
--      (should be one of the "underground-radars-x" techs).
-- param research (boolean): true of the research was triggered by a script/
--
-- remarks: At this time, just a pass through method. I am still leaving it
--      for reasons of naming conventions and I might add other effects later.
--============================================================================--
local underground_radars_researched = function(research, by_script)
    update_radar_proxies(research.force, research.level)
end

return underground_radars_researched