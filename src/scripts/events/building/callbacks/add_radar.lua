local add_hidden_radar = require("__subterra__.scripts.events.building.callbacks.add_hidden_radar")
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
    if not game.entity_prototypes[hidden_name] then
        debug("No underground radar found to place")
        return true
    end

    if surface.name ~= "nauvis" then
        debug("Radar not placed on 'nauvis'")
        return true
    end

    local force = creator and get_member_safe(creator, "force")
    local tech = force.technologies["subterra-mapping"]
    local level = tech.level
    debug("level: " .. level)  
    if level < 2 then
        debug("tech not researched")
        return true
    end
    
    -- -- all layers except top
    local layers = global.layers
    for i=2, level do
        local layer = layers[i]
        if layer then
            local surface = layer.surface
            add_hidden_radar(force, hidden_name, surface, radar.position)
        end
    end

    return true
end

return add_radar