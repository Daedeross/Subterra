require("__subterra__.scripts.utils")

local name_callbacks = require("__subterra__.scripts.events.building.callbacks.name_callbacks")
local type_callbacks = require("__subterra__.scripts.events.building.callbacks.type_callbacks")
--============================================================================--
-- on_player_mined_entity(event)
--
-- event handler for defines.events.on_player_mined_entity
--
-- param entity (table): see factorio api docs for definition of event args
-- 
--============================================================================--
local on_player_mined_entity = function (event)
    local entity = event.entity
    local ent_name = entity.name
    if global.belt_elevators[ent_name] then
        ent_name = "belt-elevator"
    end

    local callback = name_callbacks.remove[ent_name] or type_callbacks.remove[ent_name]
    if callback then
        callback(entity, game.players[event.player_index], event.buffer)
    end
end

return on_player_mined_entity