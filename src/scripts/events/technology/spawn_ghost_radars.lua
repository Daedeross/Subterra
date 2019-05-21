local add_hidden_radar = require("__subterra__.scripts.events.building.callbacks.add_hidden_radar")

local spawn_ghost_radars = function(force, level)
    debug("spawn_ghost_radars")

    local layer = global.layers[level]
    local target_surface = layer and layer.surface
    if not target_surface then
        return
    end

    local all_radars = game.surfaces['nauvis'].find_entities_filtered{
        force = force,
        type = "radar"
    }

    for _, radar in pairs(all_radars) do
        local hidden_name = "subterra-hidden-" .. radar.name
        if game.entity_prototypes[hidden_name] then
            add_hidden_radar(force, hidden_name, target_surface, radar.position) 
        else
            debug("No underground radar found to place")
        end
    end
end

return spawn_ghost_radars