require("__subterra__.scripts.utils")

local on_chunk_charted = function (event)
    local surface = game.surfaces[event.surface_index]
    local sname = surface.name
    if sname ~= "nauvis" then return end
    local layers = global.layers
    local layer = layers[sname]
    
    -- if the surface name is not a key in global.layers
    -- then it is a surface from another mod and will be ignored
    if not layer then
        return
    end

    local force = event.force
    local tech = force.technologies["subterra-mapping"]
    local chart_depth = tech.level
    if chart_depth < 2 then
        return
    end

    local position = event.position
    debug("CHART: " .. position.x .. ", " .. position.y)
    
    
    local area = chunk_to_area(position)
    for i = 2, chart_depth do
        local layer_surface = layers[i].surface
        local layer_name = layer_surface.name
        --if not (layer_name == sname or force.is_chunk_visible(layer_surface, position)) then
            debug("CHARTING: " .. layer_name)
            force.chart(layer_surface, area)
        --end
    end
end

return on_chunk_charted