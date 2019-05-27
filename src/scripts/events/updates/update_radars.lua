-- local radar_chunk = 60
--============================================================================--
-- update_radars(event)
--
-- Charts the vision in undergorund levels for each radar proxy.
--
-- param event (OnTickEvent): { tick }
--
-- remarks: smooths out the updates by only updating each radar every 60 ticks
--      (1 second) and spreads out the updates accross the second.
--============================================================================--
local update_radars = function (event)
    local radar_proxy_array = global.radar_proxy_array
    local count = # radar_proxy_array
    if count < 1 then return end

    local max_depth = settings.startup["subterra-max-depth"].value
    local radar_chunk = settings.startup["subterra-radar-update-chunk-size"].value or 60

    local layers = global.layers
    local surfaces = {}
    for i = 1, max_depth + 1 do
        surfaces[i] = layers[i].surface
    end

    local start = event.tick % radar_chunk + 1
    for i = start, count, radar_chunk do
        local proxy = radar_proxy_array[i]
        local max_level = proxy.max_level
        if max_level > 1 and proxy.radar.energy > 0 then
            local force = proxy.force
            for j = 2, max_level do
                force.chart(surfaces[j], proxy.chart_area)
            end
        end
    end
end

return update_radars