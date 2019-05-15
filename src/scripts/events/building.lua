--===================================--
-- building.lua
--===================================--
-- Handle build/mine/destroy for
-- Subterra entities.
--===================================--

require ("util")
require 'scripts/utils'

local on_built_entity = require("__subterra__.scripts.events.building.on_built_entity")
local handle_script_built = require("__subterra__.scripts.events.building.handle_script_built")
local on_robot_built_entity = require("__subterra__.scripts.events.building.on_robot_built_entity")
local on_entity_died = require("__subterra__.scripts.events.building.on_entity_died")
local on_player_mined_entity = require("__subterra__.scripts.events.building.on_player_mined_entity")
local on_robot_mined_entity = require("__subterra__.scripts.events.building.on_robot_mined_entity")
local script_raised_destroy = require("__subterra__.scripts.events.building.script_raised_destroy")

-- build events
register_event(defines.events.on_built_entity, on_built_entity)
register_event(defines.events.script_raised_built, handle_script_built)
register_event(defines.events.script_raised_revive, handle_script_built)
register_event(defines.events.on_robot_built_entity, on_robot_built_entity)

-- remove events
register_event(defines.events.on_entity_died, on_entity_died)
register_event(defines.events.on_player_mined_entity, on_player_mined_entity)
register_event(defines.events.on_robot_mined_entity, on_robot_mined_entity)
register_event(defines.events.script_raised_destroy, script_raised_destroy)