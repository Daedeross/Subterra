require 'util'
require ('config')
require 'scripts/utils'
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
    print("Migrate to v 0.3.3: Adding underground white-list")
    initialize_underground_whitelist()
end)