-- This file contains all callbacks to be registerd (by name) to handle entity placement
-- each callback must conform to the following signature:
--============================================================================--
-- function (entity, surface, creator)
--
-- param entity (LuaEntity): The placed entity
-- param surface (LuaSurface): The surface the entity is placed on
-- param creator (LuaEntity): The entity (player or robot) that placed the
--      new entity. nil if placed by other means (i.e. via script)
-- 
-- returns (boolean, LocalisedString):
--  1: true if the entity and its paired entity are successfully placed
--  2: The message to display if unable to place (nil if above is true)
--
--============================================================================--

local add_radar = require("__subterra__.scripts.events.building.callbacks.add_radar")
local remove_radar = require("__subterra__.scripts.events.building.callbacks.remove_radar")

local surface_build_events = {}
local underground_build_events = {}
local remove_events = {}

-- radars
surface_build_events["radar"] = add_radar
-- underground_build_events["radar"] = add_radar    -- TODO: Might want special underground radar instead
remove_events["radar"] = remove_radar

local callbacks = {}

callbacks.surface_build = surface_build_events
callbacks.underground_build = underground_build_events
callbacks.remove = remove_events

return callbacks