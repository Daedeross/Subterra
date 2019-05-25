local RADAR_POWER = 60  -- 60 Watts, i.e. 1 Joule per tick
local BUFFER_DURATION = 10  -- how long the buffer should last if unpowered and updated every tick

local update_radars = function (event)
    local radar_proxy_array = global.radar_proxy_array
    local count = # radar_proxy_array
    if count < 1 then return end

    local max_depth = settings.startup["subterra-max-depth"].value
    local radar_chunk = settings.startup["subterra-radar-update-chunk"].value or 1

    local buffer_size = radar_chunk * BUFFER_DURATION * RADAR_POWER

    local layers = global.layers
    local surfaces = {}
    for i = 1, max_depth + 1 do
        surfaces[i] = layers[i].surface
    end

    local start = event.tick % radar_chunk + 1
    for i = start, count, radar_chunk do
        local proxy = radar_proxy_array[i]
        local max_level = proxy.max_level
        if max_level > 1 then
            local force = proxy.force
            for j = 2, max_level do
                force.chart(surfaces[j], proxy.chart_area)
            end
        end
    end
end