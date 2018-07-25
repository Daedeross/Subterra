--===================================--
-- building.lua
--===================================--
-- Handle build/mine/destroy for
-- Subterra entities.
--===================================--

require ("util")
require 'scripts/utils'

surface_build_events = {}
underground_build_events = {}
remove_events = {}

-- check for and remove ghost proxies
function check_ghosts(layer, quadtree, bounding_box)
    local found_proxy = quadtree:remove_proxy(bounding_box)
    if found_proxy then
        local top_ghost = found_proxy.top_ghost
        if top_ghost and top_ghost.valid then
            top_ghost.destroy()
        end
        local bottom_ghost = found_proxy.bottom_ghost
        if bottom_ghost and bottom_ghost.valid then
            bottom_ghost.destroy()
        end
        if found_proxy.top_layer == layer then
            return found_proxy.bottom_layer
        else
            return found_proxy.top_layer
        end
    end
    return false
end

function check_all_ghosts(layer, bounding_box)
    if not layer then return end
    -- pads
    local paired_layer = check_ghosts(layer, layer.pad_ghosts, bounding_box)
    if paired_layer then
        check_ghosts(paired_layer, paired_layer.pad_ghosts, bounding_box)
    end
    -- belts
    paired_layer = check_ghosts(layer, layer.belt_ghosts, bounding_box)
    if paired_layer then
        check_ghosts(paired_layer, paired_layer.belt_ghosts, bounding_box)
    end
    -- power
    paired_layer = check_ghosts(layer, layer.power_ghosts, bounding_box)
    if paired_layer then
        check_ghosts(paired_layer, paired_layer.power_ghosts, bounding_box)
    end
end

register_event(defines.events.on_built_entity,
function (event)
    local p_index = event.player_index
    local player = game.players[p_index]
    local surface = player.surface
    local layer = global.layers[surface.name]
    -- if not layer then
    --     handle_other_placement(event, player)
    -- else
    if (not layer) or (layer.index == 1) then
        handle_surface_placement(event.created_entity, player, layer)
    else
        handle_underground_placement(event.created_entity, player, layer)
    end
end)

register_event(defines.events.script_raised_built, handle_script_built)
register_event(defines.events.script_raised_revive, handle_script_built)

function handle_script_built(event)
    local p_index = event.player_index
    local player = p_index and game.players[p_index]
    local entity = event.created_entity
    
    if not entity then
        return -- cant get the entity from this event, so nothing I can do
    end

    local surface
    if player then
        surface = player.surface
    elseif event.created_entity then
        surface = event.created_entity.surface
    end

    if not surface then
        return -- cant get the surface from this event, so nothing I can do
    end

    if (not layer) or (layer.index == 1) then
        handle_surface_placement(entity, player, layer)
    else
        handle_underground_placement(entity, player, layer)
    end
end

register_event(defines.events.on_robot_built_entity,
function (event)
    local robot = event.robot
    local entity = event.created_entity
    local surface = robot.surface
    local layer = global.layers[surface.name]

    if (not layer) or (layer.index == 1) then
        handle_surface_placement(entity, robot, layer)
    else
        handle_underground_placement(entity, robot, layer)
    end
end)

function destroy_and_return(built_entity, creator)
    if creator then
        local prod
        if built_entity.prototype.mineable_properties.products then
            prod = built_entity.prototype.mineable_properties.products[1].name
        else
            prod = built_entity.name
        end
        if prod ~= "entity-ghost" then
            creator.insert{name = prod, count = 1}
        end
    end
    built_entity.destroy()
end

function handle_surface_placement(entity, creator, layer)
    -- clean up any ghost proxies
    check_all_ghosts(layer, entity.bounding_box)

    local ent_name = entity.name
    if ent_name == "entity-ghost" then
        ent_name = entity.ghost_prototype.name
    end

    if global.belt_elevators[ent_name] then
        ent_name = "belt-elevator"
    end

    local player
    if creator and creator.is_player() then
        player = creator
    end

    local callback = surface_build_events[ent_name]
    if callback then
        if not layer then
            if player then player.print{"building-surface-blacklist", {"entity-name."..ent_name}} end
            destroy_and_return(entity, creator)
        else
            local result, message = callback(entity, creator.surface, creator) 
            if not result then
                if player then
                    if message then
                        player.print(message)
                    else
                        player.print{"message.building-conflict", {"entity-name."..ent_name}}
                    end
                end
                destroy_and_return(entity, creator)
            end
        end
    end
end

function handle_underground_placement(entity, creator, layer)
    -- clean up any ghost proxies
    check_all_ghosts(layer, entity.bounding_box)

    local player
    if creator and creator.is_player() then
        player = creator
    end

    local ent_name = entity.name
    if ent_name == "entity-ghost" then
        ent_name = entity.ghost_prototype.name
    end
    
    if global.belt_elevators[ent_name] then
        ent_name = "belt-elevator"
    end
    
    local callback = underground_build_events[ent_name]
    if callback then
        local result, message = callback(entity, creator.surface, creator)
        if not result then
            if player and message then player.print(message) end
            destroy_and_return(entity, creator)
        end
    else
        -- print("Tried to place:" .. ent_name)
        if not global.underground_whitelist[ent_name] then
            if player then player.print{"message.building-blacklist", {"entity-name."..ent_name}} end
            destroy_and_return(entity, creator)
        end
    end
end

underground_build_events["entity-ghost"] = add_ghost

function add_telepad_proxy(pad, surface, creator)
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

underground_build_events["subterra-telepad-up"] = add_telepad_proxy
underground_build_events["subterra-telepad-down"] = add_telepad_proxy
surface_build_events["subterra-telepad-up"] = add_telepad_proxy
surface_build_events["subterra-telepad-down"] = add_telepad_proxy

function add_belt_proxy(belt, surface, creator)
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

underground_build_events["belt-elevator"] = add_belt_proxy
surface_build_events["belt-elevator"] = add_belt_proxy

function add_power_proxy(placed, surface, creator)
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

    -- print(target_layer.index)

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

underground_build_events["subterra-power-up"] = add_power_proxy
underground_build_events["subterra-power-down"] = add_power_proxy
surface_build_events["subterra-power-up"] = function() return false end
surface_build_events["subterra-power-down"] = add_power_proxy

function add_locomotive(entity, surface)
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

surface_build_events["subterra-locomotive-1"] = add_locomotive
surface_build_events["subterra-locomotive-2"] = add_locomotive
surface_build_events["subterra-locomotive-3"] = add_locomotive
surface_build_events["subterra-locomotive-4"] = add_locomotive
surface_build_events["subterra-locomotive-5"] = add_locomotive
underground_build_events["subterra-locomotive-1"] = add_locomotive
underground_build_events["subterra-locomotive-2"] = add_locomotive
underground_build_events["subterra-locomotive-3"] = add_locomotive
underground_build_events["subterra-locomotive-4"] = add_locomotive
underground_build_events["subterra-locomotive-5"] = add_locomotive

register_event(defines.events.on_entity_died,
function (event)
    local ent_name = event.entity.name
    if global.belt_elevators[ent_name] then
        ent_name = "belt-elevator"
    end

    local callback = remove_events[ent_name]
    if callback then
        callback(event.entity)
    end
end)

register_event(defines.events.on_player_mined_entity,
function (event)
    local ent_name = event.entity.name
    if global.belt_elevators[ent_name] then
        ent_name = "belt-elevator"
    end

    local callback = remove_events[ent_name]
    if callback then
        callback(event.entity, game.players[event.player_index], event.buffer)
    end
end)

-- register_event(defines.events.on_pre_player_mined_item,
-- function (event)
--     local ent = event.entity
--     local callback = remove_events[ent.prototype.name]
--     if callback then
--         callback(ent, game.players[event.player_index])
--     end
-- end)

register_event(defines.events.on_robot_mined_entity,
function (event)
    local ent_name = event.entity.name
    if global.belt_elevators[ent_name] then
        ent_name = "belt-elevator"
    end

    local callback = remove_events[ent_name]
    if callback then
        callback(event.entity, event.robot, event.buffer)
    end
end)

register_event(defines.events.script_raised_destroy,
function (event)
    local ent_name = event.entity.name
    if global.belt_elevators[ent_name] then
        ent_name = "belt-elevator"
    end
    local callback = remove_events[ent_name]
    if callback then
        callback(event.entity, event.robot, event.buffer)
    end
end)

function handle_remove_telepad(entity)
    local sname = entity.surface.name
    local pads = global.layers[sname].telepads
    local proxy = pads:remove_proxy(entity.bounding_box)
    proxy.target_layer.telepads:remove_proxy(proxy.target_pad.entity.bounding_box)
    proxy.target_pad.entity.destroy()
end

function handle_remove_belt_elevator(belt, removing_entity, buffer)
    local proxy = global.belt_inputs[belt.unit_number] or global.belt_outputs[belt.unit_number]
    local in_id = proxy.input.unit_number
    local out_id = proxy.output.unit_number
    local mine_results = proxy.input.name -- naming convention, entity is named same as item that places it
    global.belt_inputs[in_id].removed = true
    global.belt_outputs[out_id].removed = true
    global.belt_inputs[in_id] = nil
    global.belt_outputs[out_id] = nil

    if belt ~= proxy.input then
        proxy.input.destroy()
    else 
        proxy.output.destroy()
    end

    if removing_entity then
        if buffer then
            buffer.clear()
            buffer.insert({name=mine_results})
        else
            removing_entity.insert({name=mine_results})
        end
    end
end

function handle_remove_power_interface(mined, removing_entity, buffer)
    local proxy = global.power_inputs[mined.unit_number] or global.power_outputs[mined.unit_number]
    local top_id = proxy.top.unit_number
    local bottom_id = proxy.output.unit_number
    local mine_results = mined.name  -- naming convention, entity is named same as item that places it
    global.power_inputs[top_id] = nil
    global.power_outputs[bottom_id] = nil

    proxy.input.destroy()
    proxy.output.destroy()
    proxy.pole_top.destroy()
    proxy.pole_bottom.destroy()

    if mined == proxy.top then
        proxy.bottom.destroy()
    else 
        proxy.top.destroy()
    end

    if buffer then
        buffer.clear()
        buffer.insert({name=mine_results})
    elseif removing_entity then
        removing_entity.insert({name=mine_results})
    end
end

remove_events["subterra-telepad-up"] = handle_remove_telepad
remove_events["subterra-telepad-down"] = handle_remove_telepad
remove_events["belt-elevator"] = handle_remove_belt_elevator
remove_events["subterra-power-up"] = handle_remove_power_interface
remove_events["subterra-power-down"] = handle_remove_power_interface

-- callback for entity-ghost to remove paired ghosts if present
remove_events["entity-ghost"] = function(entity)
    local surface = entity.surface
    if surface then
        local layer = global.layers[surface.name]
        if layer then 
            check_all_ghosts(layer, entity.bounding_box)
        end
    end
end

-- function simple_build(entity, surface)
--     return true
-- end

-- if subterra.config.underground_entities then
--     for name, _ in pairs(subterra.config.underground_entities) do
--         if not underground_build_events[name] then
--             print("Allowing '".. name .. "' to be built underground")
--             underground_build_events[name] = simple_build
--         end
--     end
-- end