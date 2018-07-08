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

register_event(defines.events.on_built_entity,
function (event)
    local p_index = event.player_index
    local player = game.players[p_index]
    local surface = player.surface
    local level = string.match(surface.name, "underground_(%d)")
    if not level then
        handle_surface_placement(event, player)
    else
        handle_underground_placement(event, player, level)
    end
end)

register_event(defines.events.script_raised_built,
function (event)
    local p_index = event.player_index
    local player = game.players[p_index]
    local surface = player.surface
    local level = string.match(surface.name, "underground_(%d)")
    if not level then
        handle_surface_placement(event, player)
    else
        handle_underground_placement(event, player, level)
    end
end)

register_event(defines.events.script_raised_revive,
function (event)
    local p_index = event.player_index
    local player = game.players[p_index]
    local surface = player.surface
    local level = string.match(surface.name, "underground_(%d)")
    if not level then
        handle_surface_placement(event, player)
    else
        handle_underground_placement(event, player, level)
    end
end)

function destroy_and_return(built_entity, placing_entity)
    local prod
    if built_entity.prototype.mineable_properties.products then
        prod = built_entity.prototype.mineable_properties.products[1].name
    else
        prod = built_entity.name
    end
    placing_entity.insert{name = prod, count = 1}
    built_entity.destroy()
end

function handle_surface_placement(event, p)
    local ent = event.created_entity
    local callback = surface_build_events[ent.name]
    if callback then
        if not callback(ent, p.surface) then
            destroy_and_return(ent, p)
        end
    end
end

function handle_underground_placement(event, p, level)
    local ent = event.created_entity
    local callback = underground_build_events[ent.name]
    if callback then
        if not callback(ent, p.surface) then
            destroy_and_return(ent, p)
        end
    else
        destroy_and_return(ent, p)
    end
end

function add_telepad_proxy(pad, surface)
    local sname = surface.name
    local is_down = string.find(pad.name, "%-down") ~= nil
    local layer = global.layers[sname]

    local target_layer
    if is_down then 
        target_layer = layer.layer_below
    else
        target_layer = layer.layer_above
    end
    
    -- check if target layer exists
    if target_layer == nil then
        return false
    end
    
    local target_name = "subterra-telepad-" .. (is_down and "up" or "down")

    -- check if target location is free
    local target_surface = target_layer.surface
    if not target_surface.can_place_entity{name = target_name, position = pad.position} then
        return false
    end

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
    global.layers[sname].telepads:add_proxy(pad_proxy)

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

    return true
end

underground_build_events["subterra-telepad-up"] = add_telepad_proxy
underground_build_events["subterra-telepad-down"] = add_telepad_proxy
surface_build_events["subterra-telepad-up"] = add_telepad_proxy
surface_build_events["subterra-telepad-down"] = add_telepad_proxy

function add_belt_proxy(belt, surface)
    local sname = surface.name
    local is_down = string.find(belt.name, "%-down") ~= nil
    local layer = global.layers[sname]

    local target_layer = is_down and layer.layer_below or layer.layer_above
    local target_name = "subterra-belt-out" -- later if I add more speeds, this will actually be variable

    -- check if target layer exists
    if not target_layer then
        return false
    end

    -- check if target location is free
    local target_surface = target_layer.surface
    if not target_surface.can_place_entity{name = target_name, position = belt.position} then
        return false
    end

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

    global.belt_inputs[belt.unit_number] = belt_proxy
    global.belt_outputs[target_entity.unit_number] = belt_proxy
    return true
end

underground_build_events["subterra-belt-up"] = add_belt_proxy
underground_build_events["subterra-belt-down"] = add_belt_proxy
underground_build_events["subterra-belt-out"] = add_belt_proxy
surface_build_events["subterra-belt-up"] = add_belt_proxy
surface_build_events["subterra-belt-down"] = add_belt_proxy
surface_build_events["subterra-belt-out"] = add_belt_proxy

function add_power_proxy(placed, surface)
    local sname = surface.name
    local is_down = string.find(placed.name, "%-down") ~= nil
    local layer = global.layers[sname]

    local target_layer = is_down and layer.layer_below or layer.layer_above
    local target_name = "subterra-power-" .. (is_down and "up" or "down")

    -- check if target layer exists
    if not target_layer then
        return false
    end

    -- check if target location is free
    local target_surface = target_layer.surface
    if not target_surface.can_place_entity{name = target_name, position = placed.position} then
        return false
    end

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
    return true
end

underground_build_events["subterra-power-up"] = add_power_proxy
underground_build_events["subterra-power-down"] = add_power_proxy
surface_build_events["subterra-power-up"] = function() return false end
surface_build_events["subterra-power-down"] = add_power_proxy

register_event(defines.events.on_entity_died,
function (event)
    local ent = event.entity
    local callback = remove_events[ent.prototype.name]
    if callback then
        callback(ent)
    end
end)

register_event(defines.events.on_player_mined_entity,
function (event)
    local ent = event.entity
    local callback = remove_events[ent.prototype.name]
    if callback then
        callback(ent, game.players[event.player_index], event.buffer)
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
    local ent = event.entity
    local callback = remove_events[ent.prototype.name]
    if callback then
        callback(ent, event.robot, event.buffer)
    end
end)

register_event(defines.events.script_raised_destroy,
function (event)
    local ent = event.entity
    local callback = remove_events[ent.prototype.name]
    if callback then
        callback(ent, event.robot, event.buffer)
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

    if removing_entity then
        if buffer then
            buffer.clear()
            buffer.insert({name=mine_results})
        else
            removing_entity.insert({name=mine_results})
        end
    end
end

remove_events["subterra-telepad-up"] = handle_remove_telepad
remove_events["subterra-telepad-down"] = handle_remove_telepad
remove_events["subterra-belt-up"] = handle_remove_belt_elevator
remove_events["subterra-belt-down"] = handle_remove_belt_elevator
remove_events["subterra-belt-out"] = handle_remove_belt_elevator
remove_events["subterra-power-up"] = handle_remove_power_interface
remove_events["subterra-power-down"] = handle_remove_power_interface

function simple_build(entity, surface)
    return true
end

if subterra.config.underground_entities then
    for name, _ in pairs(subterra.config.underground_entities) do
        if not underground_build_events[name] then
            print("Allowing '".. name .. "' to be built underground")
            underground_build_events[name] = simple_build
        end
    end
end