local remove_hidden_radars = require("__subterra__.scripts.events.building.callbacks.remove_hidden_radars")
--============================================================================--
-- remove_radar(belt, surface, creator)
--
-- callback for when a telepad (i.e. Stairs) is placed
--
-- param radar (LuaEntity): The removed entity or ghost
-- param surface (LuaSurface): The surface the elevator is placed on
-- param creator (LuaEntity): The entity (player or robot) that placed the
--      new entity. nil if placed by other means (i.e. via script)
-- 
-- returns (boolean, LocalisedString):
--  1: true if the entity and its paired entity are successfully placed
--  2: The message to display if unable to place
--
--============================================================================--
local remove_radar = function(radar)
    local surface = radar.surface
    local force = radar.force

    local hidden_name = "subterra-hidden-" .. radar.name
    if not game.entity_prototypes[hidden_name] then
        debug("No underground radar found to remove")
        return
    end

    if surface.name ~= "nauvis" then
        debug("Radar not placed on 'nauvis'")
        return
    end

    local force = creator and get_member_safe(creator, "force")
    if force and (not force.technologies["subterra-mapping"].researched) then
        return
    end
    
    remove_hidden_radars(force, hidden_name, radar.position)

    return true
end

return remove_radar