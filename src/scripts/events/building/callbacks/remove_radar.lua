local remove_hidden_radars = require("__subterra__.scripts.events.building.callbacks.remove_hidden_radars")
--============================================================================--
-- remove_radar(radar)
--
-- callback for when a radar is removed
--
-- param radar (LuaEntity): The removed entity or ghost
-- 
-- returns nil
--
--============================================================================--
local remove_radar = function(radar)
    local surface = radar.surface

    local unit_number = radar.unit_number
    local proxy = global.radar_proxies[unit_number]
    if not proxy then
        return
    end
    
    -- remove_hidden_radars(proxy)
    local force_array = global.radar_proxy_forces[radar.force.name]

    table.remove(global.radar_proxies, unit_number)
    table.remove(global.radar_proxy_array, proxy.index)
    table.remove(force_array, proxy.force_index)
end

return remove_radar