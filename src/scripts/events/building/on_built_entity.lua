local handle_surface_placement = require("__subterra__.scripts.events.building.handle_surface_placement")
local handle_underground_placement = require("__subterra__.scripts.events.building.handle_underground_placement")

--============================================================================--
-- on_built_entity(event)
--
-- event handler for defines.events.on_built_entity
--
-- param entity (table): see factorio api docs for definition of event args
-- 
-- remarks: This is called when a player places an entity
--============================================================================--
local on_built_entity = function (event)
    local p_index = event.player_index
    local player = game.players[p_index]
    local surface = player.surface
    local layer = global.layers[surface.name]

    -- if not layer then
    --     handle_other_placement(event, player)
    -- else
    if (not layer) or (layer.index == 1) then
        handle_surface_placement(event.created_entity, player, layer)
    else
        handle_underground_placement(event.created_entity, player, layer)
    end
end

return on_built_entity