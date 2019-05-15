local handle_surface_placement = require("__subterra__.scripts.events.building.handle_surface_placement")
local handle_underground_placement = require("__subterra__.scripts.events.building.handle_underground_placement")

--============================================================================--
-- handle_script_built(event)
--
-- event handler for defines.events.script_raised_built and script_raised_revive
--
-- param entity (table): see factorio api docs for definition of event args
-- 
-- remarks: This is called when a player places an entity
--============================================================================--
local handle_script_built = function(event)
    debug("script built")
    local p_index = event.player_index
    local player = p_index and game.players[p_index]
    local entity = event.created_entity -- or event.entity
    
    if not entity then
        debug("No entity in event")
        return -- can't get the entity from this event, so nothing I can do
    end

    local surface
    if player then
        surface = player.surface
    elseif event.created_entity then
        surface = event.created_entity.surface
    end

    if not surface then
        return -- can't get the surface from this event, so nothing I can do
    end

    local layer = global.layers[surface.name]

    if (not layer) or (layer.index == 1) then
        handle_surface_placement(entity, player, layer)
    else
        handle_underground_placement(entity, player, layer)
    end
end

return handle_script_built