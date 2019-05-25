-- This file contains all callbacks to be registerd (by name) to handle when
-- research is finished
-- each callback must conform to the following signature:
--============================================================================--
-- function (research, by_script)
--
-- research (LuaTechnology): The researched technology
-- by_script (boolean): If the technology was researched by script.
-- 
--============================================================================--
local underground_radars = require("__subterra__.scripts.events.technology.underground_radars")
local underground_building = require("__subterra__.scripts.events.technology.underground_building")

local callbacks = {}

callbacks["subterra-mapping"] = underground_radars
callbacks["underground-building"] = underground_building

local max_depth = settings.startup["subterra-max-depth"].value
for i=1, max_depth do
    -- callbacks["subterra-mapping-"..i] = underground_radars
    callbacks["underground-building"..1] = underground_building
end

return callbacks