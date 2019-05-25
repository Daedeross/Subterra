local add_hidden_radar = require("__subterra__.scripts.events.building.callbacks.add_hidden_radar")

local spawn_ghost_radars = function(force, level)
    debug("spawn_ghost_radars")

    local layer = global.layers[level]
    local target_surface = layer and layer.surface
    if not target_surface then
        return
    end

    local force_array = global.radar_proxy_forces[force.name]
    if not force_array then
        return
    end

    local count = # force_array
    if count < 1 then
        return
    end

    for i=1, count do
        local proxy = force_array[i]
        local radars = proxy.radars
        if radars[level] then  -- defensive check
            radars[level] = add_hidden_radar(force, proxy.hidden_name, target_surface, proxy.top.position)
        end
    end
end

return spawn_ghost_radars