require("__subterra__.scripts.utils")
--============================================================================--
-- add_power_proxy(placed, surface, creator)
--
-- callback for when a telepad (i.e. Stairs) is placed
--
-- param placed (LuaEntity): The placed power-converter entity or ghost
-- param surface (LuaSurface): The surface the entity is placed on
-- param creator (LuaEntity): The entity (player or robot) that placed the
--      new entity. nil if placed by other means (i.e. via script)
-- 
-- returns (boolean, LocalisedString):
--  1: true if the entity and its paired entity are successfully placed
--  2: The message to display if unable to place (nil if above is true)
--
--============================================================================--
local add_locomotive = function (entity, surface)
    local ent_name = entity.name
    local is_ghost = ent_name == "entity-ghost"

    if is_ghost then
        ent_name = entity.ghost_name
    end
    
    local min_index = subterra.config.locomotive_levels[ent_name]
    if not min_index then
        return false
    end
    
    local sname = surface.name   
    local layer = global.layers[sname]
    -- to prevent entity from being buld on non-allowed surfaces
    if not (layer and layer.index >= min_index) then
        return false, {"message.building-locomotive-level", {"entity-name."..ent_name}, min_index - 1}
    end

    return true
end

return add_locomotive