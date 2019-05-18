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
local add_power_proxy = function (placed, surface, creator)
    local force = creator and get_member_safe(creator, "force")

    local ent_name = placed.name
    local is_ghost = ent_name == "entity-ghost"

    if is_ghost then
        ent_name = placed.ghost_name
    end

    local is_down = string.find(ent_name, "%-down") ~= nil

    local layer, target_layer, message = check_layer(surface, ent_name, is_down, force)
    if message then
        return false, message
    end

    local target_name = "subterra-power-" .. (is_down and "up" or "down")

    -- check if target location is free
    local target_surface = target_layer.surface
    if not target_surface.can_place_entity{name = target_name, position = placed.position} then
        return false, {"message.building-conflict", {"entity-name."..ent_name}}
    end

    if is_ghost then 
        -- create target ghost
        local target_entity = target_surface.create_entity{
            name = "entity-ghost",
            inner_name = target_name,
            position = placed.position,
            force = placed.force
        }

        local top = is_down and placed or target_entity
        local bottom = is_down and target_entity or placed

        -- create ghost proxies
        local ghost_proxy = {
            bbox = top.bounding_box,
            top_ghost = top,
            bottom_ghost = bottom,
            top_layer = is_down and layer or target_layer,
            bottom_layer = is_down and target_layer or layer
        }

        layer.power_ghosts:add_proxy(ghost_proxy)
        target_layer.power_ghosts:add_proxy(ghost_proxy)
    else

        local target_entity = target_surface.create_entity{
            name = target_name,
            position = placed.position,
            force = placed.force,
            direction = placed.direction
        }

        -- electic interfaces
        local input = surface.create_entity{
            name = "subterra-power-in",
            position = placed.position,
            force = placed.force,
            direction = placed.direction
        }

        local output = target_surface.create_entity{
            name = "subterra-power-out",
            position = placed.position,
            force = placed.force,
            direction = placed.direction
        }

        local top_surface = is_down and surface or target_surface
        local bottom_surface = is_down and target_surface or surface
        -- hidden power poles
        local pole_top = top_surface.create_entity{
            name = "subterra-power-pole",
            position = placed.position,
            force = placed.force,
            direction = placed.direction
        }
        local pole_bottom = bottom_surface.create_entity{
            name = "subterra-power-pole",
            position = placed.position,
            force = placed.force,
            direction = placed.direction
        }
        
        local power_proxy = {
            input = input,
            output = output,
            top = is_down and placed or target_entity,
            bottom = is_down and target_entity or placed,
            pole_top = pole_top,
            pole_bottom = pole_bottom,
            target_layer = target_layer
        }

        global.power_inputs[placed.unit_number] = power_proxy
        global.power_outputs[target_entity.unit_number] = power_proxy
    end
    return true
end

return add_power_proxy