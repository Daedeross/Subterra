require("__subterra__.scripts.utils")
local add_hidden_radar = require("__subterra__.scripts.events.building.callbacks.add_hidden_radar")

local max_depth = settings.startup["subterra-max-depth"].value

local add_radar_proxy = function(original, force, hidden_name, level)
    local radars = {}
    radars[1] = original
    
    if level > 1 then
        local layers = global.layers
        for i = 2, level do
            local surface = layers[i].surface
            local hidden = add_hidden_radar(force, hidden_name, surface, position)
            radars[i] = hidden
        end
    end

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
    local proxy = {
        index = index,
        force_index = f_index,
        force = force,
        hidden_name = hidden_name,
        top = original,
        radars = radars,
        max_level = level
    }

    global.radar_proxies[unit_number] = proxy
    table.insert(radar_proxy_arrays, proxy)
    table.insert(force_array, proxy)
end 

return add_radar_proxy