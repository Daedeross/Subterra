require 'util'
require ('config')
require 'scripts/utils'

-- migrate v > 0.2.0
register_configuration_event(
function (config)
    local mod = config.mod_changes["subterra"]
    if mod then
        return mod.old_version and mod.old_version < "0.3.0"
    end
    return false
end,
function (config)
    print("Migrating global table to 0.3.0")
    if not global.power_inputs then global.power_inputs = {} end
    if not global.power_outputs then global.power_outputs = {} end
end)