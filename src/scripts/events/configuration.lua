require 'util'
require ('config')
require 'scripts/utils'
require 'scripts/quadtree'
require 'initialization'

function subterra_version(config, version)
    local mod = config.mod_changes["subterra"]
    if mod then
        return mod.old_version and mod.old_version < version
    end
    return false
end

-- migrate v > 0.2.0
register_configuration_event(
function (config)
    return subterra_version(config, "0.3.0")
end,
function (config)
    print("Migrating global table to 0.3.0")
    if not global.power_inputs then global.power_inputs = {} end
    if not global.power_outputs then global.power_outputs = {} end
end)

-- migrate v -> 0.3.3
register_configuration_event(
function (config)
    return subterra_version(config, "0.3.3")
end,
function(config)
    print("Migrate Sebterra to v0.3.3: Adding underground white-list")
    initialize_underground_whitelist()
end)

register_configuration_event(
function (config)
    return subterra_version(config, "0.4.0")
end,
function (config)
    print("Migrate Sebterra to v0.4.0: Adding ghost proxies and qaudtree index")
    for i, layer in pairs(global.layers) do
        if not layer.pad_ghosts then layer.pad_ghosts = Quadtree:new() end
        if not layer.belt_ghosts then layer.belt_ghosts = Quadtree:new() end
        if not layer.power_ghosts then layer.power_ghosts = Quadtree:new() end

        -- fix index and count
        layer.telepads:rebuild_index()
        layer.pad_ghosts:rebuild_index()
        layer.belt_ghosts:rebuild_index()
        layer.power_ghosts:rebuild_index()
    end
end)