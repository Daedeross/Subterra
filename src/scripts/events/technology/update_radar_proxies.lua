local update_radar_proxies = function(force, level)
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
        proxy.max_level = level
    end
end

return update_radar_proxies