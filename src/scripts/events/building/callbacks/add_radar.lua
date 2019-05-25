local add_radar_proxy = require("__subterra__.scripts.events.building.callbacks.add_radar_proxy")
--============================================================================--
-- add_radar(belt, surface, creator)
--
-- callback for when a telepad (i.e. Stairs) is placed
--
-- param radar (LuaEntity): The placed entity or ghost
-- param surface (LuaSurface): The surface the elevator is placed on
-- param creator (LuaEntity): The entity (player or robot) that placed the
--      new entity. nil if placed by other means (i.e. via script)
-- 
-- returns (boolean, LocalisedString):
--  1: true if the entity and its paired entity are successfully placed
--  2: The message to display if unable to place
--
--============================================================================--
local add_radar = function(radar, surface, creator)
    debug("add_radar")
    local hidden_name = "subterra-hidden-" .. radar.name
    local hidden_prototype = game.entity_prototypes[hidden_name]
    if not hidden_prototype then
        debug("unknown radar placed")
        return
    end

    if surface.name ~= "nauvis" then
        debug("Radar not placed on 'nauvis'")
        return true
    end

    local force = creator and get_member_safe(creator, "force")
    local tech = force.technologies["subterra-mapping"]
    local level = tonumber(tech.level)
    debug("level: " .. level)

    add_radar_proxy(radar, force, hidden_prototype, level)

    return true
end

return add_radar