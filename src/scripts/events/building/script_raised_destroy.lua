require("__subterra__.scripts.utils")

local name_callbacks = require("__subterra__.scripts.events.building.callbacks.name_callbacks")
local type_callbacks = require("__subterra__.scripts.events.building.callbacks.type_callbacks")
--============================================================================--
-- script_raised_destroy(event)
--
-- event handler for defines.events.script_raised_destroy
--
-- param entity (table): see factorio api docs for definition of event args
-- 
--============================================================================--
local script_raised_destroy = function (event)
    local ent_name = event.entity.name
    if global.belt_elevators[ent_name] then
        ent_name = "belt-elevator"
    end

    local callback = name_callbacks.remove[ent_name] or type_callbacks.remove[ent_name]
    if callback then
        callback(event.entity)
    end
end

return script_raised_destroy