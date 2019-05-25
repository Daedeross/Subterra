require("__subterra__.scripts.utils")
local add_hidden_radar = require("__subterra__.scripts.events.building.callbacks.add_hidden_radar")

local add_radar_proxy = function(radar, force, hidden_prototype, level)

    local radar_proxy_array = global.radar_proxy_array
    local radar_proxy_forces = global.radar_proxy_forces
    local force = radar.force
    local f_name = force.name
    local force_array = radar_proxy_forces[f_name] 
    if not force_array then
        force_array = {}
        radar_proxy_forces[f_name] = force_array
    end

    local index = # radar_proxy_array + 1
    local f_index = # force_array + 1
    local unit_number = radar.unit_number
    local center = chunk_to_position(position_to_chunk(radar.position))
    local range = hidden_prototype.max_health   -- haaaaak

    local proxy = {
        index = index,
        force_index = f_index,
        force = force,
        radar = radar,
        chart_area = { { center.x - range, center.y - range }, { center.x + range, center.y + range } },
        max_level = level
    }

    global.radar_proxies[unit_number] = proxy
    table.insert(radar_proxy_array, proxy)
    table.insert(force_array, proxy)
end 

return add_radar_proxy