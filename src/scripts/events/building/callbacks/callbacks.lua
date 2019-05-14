-- This file contains all callbacks to be registerd to handle entity placement
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

local add_belt_proxy = require("__subterra__.scripts.events.building.callbacks.add_belt_proxy")
local add_telepad_proxy = require("__subterra__.scripts.events.building.callbacks.add_telepad_proxy")
local add_power_proxy = require("__subterra__.scripts.events.building.callbacks.add_power_proxy")
local add_locomotive = require("__subterra__.scripts.events.building.callbacks.add_locomotive")

local remove_telepad = require("__subterra__.scripts.events.building.callbacks.remove_telepad")
local remove_belt_elevator = require("__subterra__.scripts.events.building.callbacks.remove_belt_elevator")
local remove_power_interface = require("__subterra__.scripts.events.building.callbacks.remove_power_interface")

local surface_build_events = {}
local underground_build_events = {}
local remove_events = {}

-- belt-elevators
underground_build_events["belt-elevator"] = add_belt_proxy
surface_build_events["belt-elevator"] = add_belt_proxy
remove_events["belt-elevator"] = remove_belt_elevator

-- telepads
underground_build_events["subterra-telepad-up"] = add_telepad_proxy
underground_build_events["subterra-telepad-down"] = add_telepad_proxy
surface_build_events["subterra-telepad-up"] = add_telepad_proxy
surface_build_events["subterra-telepad-down"] = add_telepad_proxy
remove_events["subterra-telepad-up"] = remove_telepad
remove_events["subterra-telepad-down"] = remove_telepad

-- power convertes
underground_build_events["subterra-power-up"] = add_power_proxy
underground_build_events["subterra-power-down"] = add_power_proxy
surface_build_events["subterra-power-up"] = function() return false end
surface_build_events["subterra-power-down"] = add_power_proxy
remove_events["subterra-power-up"] = remove_power_interface
remove_events["subterra-power-down"] = remove_power_interface

-- locomotives
surface_build_events["subterra-locomotive"] = add_locomotive
-- surface_build_events["subterra-locomotive-1"] = add_locomotive
-- surface_build_events["subterra-locomotive-2"] = add_locomotive
-- surface_build_events["subterra-locomotive-3"] = add_locomotive
-- surface_build_events["subterra-locomotive-4"] = add_locomotive
-- surface_build_events["subterra-locomotive-5"] = add_locomotive
underground_build_events["subterra-locomotive"] = add_locomotive
-- underground_build_events["subterra-locomotive-1"] = add_locomotive
-- underground_build_events["subterra-locomotive-2"] = add_locomotive
-- underground_build_events["subterra-locomotive-3"] = add_locomotive
-- underground_build_events["subterra-locomotive-4"] = add_locomotive
-- underground_build_events["subterra-locomotive-5"] = add_locomotive

-- ghosts, requires access to all previously registered remove_events
remove_events["entity-ghost"] = function(entity)
    local ghost_name = entity.ghost_name
    if ghost_name and remove_events[ghost_name] then
        local surface = entity.surface
        if surface then
            local layer = global.layers[surface.name]
            if layer then 
                check_all_ghosts(layer, entity.bounding_box)
            end
        end
    end
end

local callbacks = {}

callbacks.surface_build = surface_build_events
callbacks.underground_build = underground_build_events
callbacks.remove = remove_events

return callbacks