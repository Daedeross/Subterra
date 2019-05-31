require("__subterra__.scripts.utils")
--============================================================================--
-- add_radar_proxy(radar, force, hidden_prototype, level)
--
-- Adds a radar proxy for a just placed radar on nauvis.
-- Adds the proxy to the relevant indices.
--
-- param radar (LuaEntity): The placed entity.
-- param force (LuaSurface): The force that owns the radar.
-- param hidden_prototype (LuaEntity): Dynamicaly generated prototype with
--      max_health equal the the vision range of the radar.
-- param level (int): The current max level of the underground-radars technology
--      for the owning force.
--
-- returns nil
--
--============================================================================--
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

    local unit_number = radar.unit_number
    local center = chunk_to_position(position_to_chunk(radar.position))
    local range = hidden_prototype.max_health   -- haaaaak
    if range <= 1 then
        return
    end

    local proxy = {
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