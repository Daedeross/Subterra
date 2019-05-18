require("__subterra__.scripts.utils")

if not subterra.tick_events then subterra.tick_events = {} end

local check_telepads = require("__subterra__.scripts.events.updates.check_telepads")
local update_belt_elevators = require("__subterra__.scripts.events.updates.update_belt_elevators")
local update_power = require("__subterra__.scripts.events.updates.update_power")
local cleanup_ghosts = require("__subterra__.scripts.events.updates.cleanup_ghosts")

-- Teleports players if standing on stairs
-- event fired every 12th of a second by default
local pad_interval = (subterra and subterra.config and subterra.config.TELEPAD_UPDATE_INTERVAL) or 5
register_nth_tick_event (pad_interval, check_telepads)

-- update belts
register_event(defines.events.on_tick, update_belt_elevators)

-- power
register_event(defines.events.on_tick, update_power)

-- cleans up invalid ghosts
-- event fired every 10th of a second by default
local ghost_interval = (subterra and subterra.config and subterra.config.GHOST_CLEANUP_INTERVAL) or 6
register_nth_tick_event (ghost_interval, cleanup_ghosts)
