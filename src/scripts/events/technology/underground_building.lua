--============================================================================--
-- underground_building_researched(research, by_script)
--
-- Helper method that gets the current level of a player proxy
--
-- param research (LuaTechnology): The tech just researched
--      (should be one of the "underground-building-x" techs)
-- param by_script (boolean): true of the research was triggered by a script
--
--============================================================================--
local underground_building_researched = function(research, by_script)
    local find = string.find(research.name, "underground%-building") 
    if find then
        debug("Researched LEVEL " .. research.level)
        global.current_depth[research.force.name] = research.level
    end
end

return underground_building_researched