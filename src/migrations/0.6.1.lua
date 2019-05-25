local radar_proxies = {}
local radar_proxy_arrays = {}
local radar_proxy_forces = {}

-- get all radars on nauvis
local nauvis = game.surfaces['nauvis']

-- this could take a while...
local all_radars = game.surfaces['nauvis'].find_entities_filtered{
    type = "radar"
}

local try_add_radar_proxy = function(radar)
    local hidden_name = "subterra-hidden-" .. radar.name
    if not game.entity_prototypes[hidden_name] then
        return  -- radar prototype must have been added after subterra's data-updates thus cannot use it
    end

    local force = radar.force
    local f_name = force.name
    local force_array = radar_proxy_forces[f_name] 
    if not force_array then
        force_array = {}
        radar_proxy_forces[f_name] = force_array
    end

    local index = # proxy_array + 1
    local f_index = # force_array + 1
    local unit_number = radar.unit_number

    local proxy = {
        index = index,
        force_index = f_index,
        force = radar.force,
        hidden_name = hidden_name,
        top = radar,
        radars = { radar }, -- underground radar tech also added this version so it cannot already be researched.
        max_level = 1       -- Thus only the top radar is in the proxy and max_level is 1
    }

    radar_proxies[unit_number] = proxy
    table.insert(radar_proxy_arrays, proxy)
    table.insert(force_array, proxy)
end

for _, radar in pairs(all_radars) do
    try_add_radar_proxy(radar)
end