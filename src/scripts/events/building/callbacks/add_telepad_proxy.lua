require("__subterra__.scripts.utils")
--============================================================================--
-- add_telepad_proxy(pad, surface, creator)
--
-- callback for when a telepad (i.e. Stairs) is placed
--
-- param pad (LuaEntity): The placed pad entity or ghost
-- param surface (LuaSurface): The surface the pad is placed on
-- param creator (LuaEntity): The entity (player or robot) that placed the
--      new entity. nil if placed by other means (i.e. via script)
-- 
-- returns (boolean, LocalisedString):
--  1: true if the entity and its paired entity are successfully placed
--  2: The message to display if unable to place (nil if above is true)
--
--============================================================================--
local add_telepad_proxy = function (pad, surface, creator)
    local force = creator and get_member_safe(creator, "force")

    local ent_name = pad.name
    local is_ghost = ent_name == "entity-ghost"

    if is_ghost then
        ent_name = pad.ghost_name
    end

    local is_down = string.find(ent_name, "%-down") ~= nil

    local layer, target_layer, message = check_layer(surface, ent_name, is_down, force)
    if message then
        return false, message
    end

    local target_name = "subterra-telepad-" .. (is_down and "up" or "down")

    -- check if target location is free
    local target_surface = target_layer.surface
    if not target_surface.can_place_entity{name = target_name, position = pad.position} then
        return false, {"message.building-conflict", {"entity-name."..ent_name}}
    end

    if is_ghost then
        -- create target ghost
        local target_entity = target_surface.create_entity{
            name = "entity-ghost",
            inner_name = target_name,
            position = pad.position,
            force = pad.force
        }

        local top = is_down and pad or target_entity
        local bottom = is_down and target_entity or pad

        -- create ghost proxies
        local ghost_proxy = {
            bbox = top.bounding_box,
            top_ghost = top,
            bottom_ghost = bottom,
            top_layer = is_down and layer or target_layer,
            bottom_layer = is_down and target_layer or layer
        }

        layer.pad_ghosts:add_proxy(ghost_proxy)
        target_layer.pad_ghosts:add_proxy(ghost_proxy)
    else
        -- create target pad entity
        local target_entity = target_surface.create_entity{
            name = target_name,
            position = pad.position,
            force = pad.force
        }
        -- add padd to proxies
        local pad_proxy = {
            name = "proxy_" .. string.format("%010d", pad.unit_number),
            entity = pad,
            target_layer = target_layer,
            bbox = pad.bounding_box,
            --players = {}    -- TODO: for tracking status of players standing on pad after teleporting, to prevent loops
        }
        layer.telepads:add_proxy(pad_proxy)

        -- add target pad
        local target_proxy = {
            name = "proxy_" .. string.format("%010d", target_entity.unit_number),
            entity = target_entity,
            target_layer = layer,
            target_pad = pad_proxy,
            bbox = target_entity.bounding_box,
        }
        pad_proxy.target_pad = target_proxy
        target_layer.telepads:add_proxy(target_proxy)
    end
    return true
end

return add_telepad_proxy