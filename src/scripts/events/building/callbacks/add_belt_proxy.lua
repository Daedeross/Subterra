require("__subterra__.scripts.utils")
--============================================================================--
-- add_belt_proxy(belt, surface, creator)
--
-- callback for when a telepad (i.e. Stairs) is placed
--
-- param belt (LuaEntity): The placed entity or ghost
-- param surface (LuaSurface): The surface the elevator is placed on
-- param creator (LuaEntity): The entity (player or robot) that placed the
--      new entity. nil if placed by other means (i.e. via script)
-- 
-- returns (boolean, LocalisedString):
--  1: true if the entity and its paired entity are successfully placed
--  2: The message to display if unable to place
--
--============================================================================--
local add_belt_proxy = function(belt, surface, creator)
    local force = creator and get_member_safe(creator, "force")

    local ent_name = belt.name
    local is_ghost = ent_name == "entity-ghost"

    if is_ghost then
        ent_name = belt.ghost_name
    end

    local target_name, subs = string.gsub(ent_name, "-down", "-out")
    local is_down
    if subs > 0 then 
        is_down = true
    else
        is_down = false
        target_name, subs = string.gsub(ent_name, "-up", "-out")
    end

    --print(target_name)

    local layer, target_layer, message = check_layer(surface, ent_name, is_down, force)
    if message then
        return false, message
    end

    -- check if target location is free
    local target_surface = target_layer.surface
    if not target_surface.can_place_entity{name = target_name, position = belt.position} then
        return false, {"message.building-conflict", {"entity-name."..ent_name}}
    end

    if is_ghost then 
        -- create target ghost
        local target_entity = target_surface.create_entity{
            name = "entity-ghost",
            inner_name = target_name,
            position = belt.position,
            force = belt.force
        }

        local top = is_down and belt or target_entity
        local bottom = is_down and target_entity or belt

        -- create ghost proxies
        local ghost_proxy = {
            bbox = top.bounding_box,
            top_ghost = top,
            bottom_ghost = bottom,
            top_layer = is_down and layer or target_layer,
            bottom_layer = is_down and target_layer or layer
        }

        layer.belt_ghosts:add_proxy(ghost_proxy)
        target_layer.belt_ghosts:add_proxy(ghost_proxy)
    else

        local target_entity = target_surface.create_entity{
            name = target_name,
            position = belt.position,
            force = belt.force,
            direction = belt.direction
        }
        
        local belt_proxy = {
            input = belt,
            output = target_entity,
            target_layer = target_layer,
            in_line1 = belt.get_transport_line(1),
            in_line2 = belt.get_transport_line(2),
            out_line1 = target_entity.get_transport_line(1),
            out_line2 = target_entity.get_transport_line(2),
            rotated_last = true
        }

        -- for k, v in pairs(belt_proxy) do
        --     print(tostring(k) .. "|" ..  tostring(v))
        -- end

        global.belt_inputs[belt.unit_number] = belt_proxy
        global.belt_outputs[target_entity.unit_number] = belt_proxy
    end
    return true
end

return add_belt_proxy