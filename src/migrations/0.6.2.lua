require("__subterra__.scripts.utils")
local radar_proxies = {}
local radar_proxy_array = {}
local radar_proxy_forces = {}

-- get all radars on nauvis
-- this could take a while...
local nauvis = game.surfaces['nauvis']
local all_radars = nauvis.find_entities_filtered{
    type = "radar"
}

local insert = table.insert

local try_add_radar_proxy = function(radar)
    local hidden_name = "subterra-hidden-" .. radar.name
    local hidden_prototype = game.entity_prototypes[hidden_name]
    if not hidden_prototype then
        return  -- radar prototype must have been added after subterra's data-updates thus cannot use it
    end

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
    if range <= 1 then
        return
    end

    local proxy = {
        force = radar.force,
        radar = radar,
        chart_area = { { center.x - range, center.y - range }, { center.x + range, center.y + range } },
        max_level = 1       -- underground radar tech also added this version so it cannot already be researched.
    }                       -- Thus only the top radar is in the proxy and max_level is 1

    radar_proxies[unit_number] = proxy
    insert(radar_proxy_array, proxy)
    insert(force_array, proxy)
end

for _, radar in pairs(all_radars) do
    try_add_radar_proxy(radar)
end

debug("Fixed Radars")
debug(#radar_proxy_array)

global.radar_proxies = radar_proxies
global.radar_proxy_array = radar_proxy_array 
global.radar_proxy_forces = radar_proxy_forces