local callbacks = require("__subterra__.scripts.events.building.callbacks.callbacks")
require("__subterra__.scripts.utils")
--============================================================================--
-- on_player_mined_entity(event)
--
-- event handler for defines.events.on_player_mined_entity
--
-- param entity (table): see factorio api docs for definition of event args
-- 
--============================================================================--
local on_player_mined_entity = function (event)
    local ent_name = event.entity.name
    if global.belt_elevators[ent_name] then
        ent_name = "belt-elevator"
    end

    local callback = callbacks.remove[ent_name]
    if callback then
        callback(event.entity, game.players[event.player_index], event.buffer)
    end
end

return on_player_mined_entity