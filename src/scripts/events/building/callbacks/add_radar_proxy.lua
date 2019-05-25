require("__subterra__.scripts.utils")
local add_hidden_radar = require("__subterra__.scripts.events.building.callbacks.add_hidden_radar")

local max_depth = settings.startup["subterra-max-depth"].value

local add_radar_proxy = function(radar, force, level)
    local f_name = force.name
    local proxy_array = global.radar_proxy_arrays
    local force_array = global.radar_proxy_forces[f_name]
    -- initialize force's array if needed
    if not force_array then
        proxy_array = {}
        global.radar_proxy_arrays[f_name] = proxy_array
    end

    local index = # proxy_array + 1
    local f_index = # force_array + 1
    local center = chunk_to_position(position_to_chunk(radar.position))
    local range = radar.prototype.radar_range * 32

    local proxy = {
        index = index,
        force_index = f_index,
        force = force,
        radar = radar,
        chart_area = { { center.x - range, center.y - range }, { center.x + range, center.y + range } }
        max_level = level
    }

    global.radar_proxies[unit_number] = proxy
    table.insert(radar_proxy_arrays, proxy)
    table.insert(force_array, proxy)
end 

return add_radar_proxy