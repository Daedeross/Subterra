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
    
    remove_hidden_radars(proxy)

    table.remove(global.radar_proxies, unit_number)
    table.remove(global.radar_proxy_arrays, proxy.index)
    table.remo

    return
end

return remove_radar