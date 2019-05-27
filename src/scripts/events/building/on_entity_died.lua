require("__subterra__.scripts.utils")

local name_callbacks = require("__subterra__.scripts.events.building.callbacks.name_callbacks")
local type_callbacks = require("__subterra__.scripts.events.building.callbacks.type_callbacks")
--============================================================================--
-- on_entity_died(event)
--
-- event handler for defines.events.on_entity_died
--
-- param entity (table): see factorio api docs for definition of event args
-- 
--============================================================================--
local on_entity_died = function (event)
    local ent_name = event.entity.name
    if global.belt_elevators[ent_name] then
        ent_name = "belt-elevator"
    end

    local callback = name_callbacks.remove[ent_name] or type_callbacks.remove[ent_name]
    if callback then
        callback(event.entity)
    end
end

return on_entity_died