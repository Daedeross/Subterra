require("__subterra__.scripts.utils")
local get_subway_level = function (force)
    for i=1, 5 do
        local tech = force.technologies["subway-"..i]
        if not tech.researched then
            return i - 1
        end
    end
    return 5
end

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
local add_locomotive = function (entity, surface, creator)
    local ent_name = entity.name
    local is_ghost = ent_name == "entity-ghost"

    if is_ghost then
        ent_name = entity.ghost_name
    end
    
    local sname = surface.name
    local layer = global.layers[sname]
    -- to prevent entity from being built on non-allowed surfaces
    if not (layer and layer.index > 1) then
        game.print(layer.index)
        return false, {"message.building-locomotive-level", {"entity-name."..ent_name}, 1 }
    end

    local force = creator and creator.force
    local max_depth = 5
    if force then
        max_depth = get_subway_level(force)
    end

    local depth = layer.index - 1
    if not (depth <= max_depth) then
        debug("too deep")
        return false, {"message.building-locomotive-level-max", {"entity-name."..ent_name}, max_depth }
    end

    local player = creator.is_player() and creator
    debug(force.name)

    -- do the entity switch
    local params = {
        name = "subterra-locomotive-" .. depth,
        position = entity.position,
        direction = entity.direction,
        force = force,
        fast_replace = true,
        player = player,
        --raise_built = true
    }

    entity.destroy()
    debug("Trying to create locomotive")
    local new_locomotive = surface.create_entity(params)
    debug(new_locomotive)
    return true
end

return add_locomotive