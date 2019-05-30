require("__subterra__.scripts.utils")
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

    local force_array = global.radar_proxy_forces[radar.force.name]
    local radar_proxies = global.radar_proxies
    local proxy_array = global.radar_proxy_array

    remove_item(proxy_array, proxy)
    remove_item(force_array, proxy)
    radar_proxies[unit_number] = nil
end

return remove_radar