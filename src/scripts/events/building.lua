--===================================--
-- building.lua
--===================================--
-- Handle build/mine/destroy for
-- Subterra entities.
--===================================--

require ("util")
require 'scripts/utils'

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
    -- debug("place")
    -- debug(ent.name)
    -- debug(string.find(ent.name, "subterra%-belt"))
    if string.find(ent.name, "telepad") ~= nil then
        if not add_telepad_proxy(ent, p.surface) then
            destroy_and_return(ent, p)
        end
    elseif string.find(ent.name, "subterra%-belt") ~= nil then
        debug("belt")
        if not add_belt_proxy(ent, p.surface) then
            destroy_and_return(ent, p)
        end
    end
end

function handle_underground_placement(event, p, level)
    local ent = event.created_entity

    if global.underground_entities[ent.name] then
        if string.find(ent.name, "telepad") ~= nil then
            if not add_telepad_proxy(ent, p.surface) then
                destroy_and_return(ent, p)
            end
        elseif string.find(ent.name, "subterra%-belt") ~= nil then
            if not add_belt_proxy(ent, p.surface) then
                destroy_and_return(ent, p)
            end
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

function add_belt_proxy(belt, surface)
    local sname = surface.name
    local is_down = string.find(belt.name, "%-down") ~= nil
    --local is_in = string.find(belt.name, "%-in") ~= nil
    local layer = global.layers[sname]

    local target_layer = is_down and layer.layer_below or layer.layer_above
    local target_name = "subterra-belt-out" -- later if I add more speeds, this will actually be variable
    
    -- debug(target_layer)
    -- check if target layer exists
    if target_layer == nil then
        return false
    end

    -- debug("placing")
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
    -- debug("placed target")
    -- debug(target_entity)
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

    for i, v in pairs(belt_proxy) do
        print(i .. ":" .. tostring(v))
    end

    global.belt_inputs[belt.unit_number] = belt_proxy
    global.belt_outputs[target_entity.unit_number] = belt_proxy
    return true
end

register_event(defines.events.on_entity_died,
function (event)
    local name = event.entity.prototype.name
    if string.find(name, "telepad") ~= nil then
        handle_remove_telepad(event.entity)
    elseif string.find(name, "subterra%-belt") ~= nil then
        handle_remove_belt_elevator(event.entity)
    end
end)

register_event(defines.events.on_pre_player_mined_item,
function (event)
    local name = event.entity.prototype.name
    if string.find(name, "telepad") ~= nil then
        handle_remove_telepad(event.entity)
    elseif string.find(name, "subterra%-belt") ~= nil then
        debug(event.player_index)
        handle_remove_belt_elevator(event.entity, game.players[event.player_index])
    end
end)

register_event(defines.events.on_robot_pre_mined,
function (event)
    local name = event.entity.prototype.name
    if string.find(name, "telepad") ~= nil then
        handle_remove_telepad(event.entity)
    elseif string.find(name, "subterra%-belt") ~= nil then
        handle_remove_belt_elevator(event.entity)
    end
end)

function handle_remove_telepad(entity)
    local sname = entity.surface.name
    local pads = global.layers[sname].telepads
    local proxy = pads:remove_proxy(entity.bounding_box)
    proxy.target_layer.telepads:remove_proxy(proxy.target_pad.entity.bounding_box)
    proxy.target_pad.entity.destroy()
end

function handle_remove_belt_elevator(belt, entity)
    local proxy = global.belt_inputs[belt.unit_number] or global.belt_outputs[belt.unit_number]
    local in_id = proxy.input.unit_number
    local out_id = proxy.output.unit_number
    local mine_results = proxy.input.name -- naming convention, entity is named same as item that places it
    global.belt_inputs[in_id] = nil
    global.belt_outputs[out_id] = nil
    if belt ~= proxy.input then
        proxy.input.destroy()
    else 
        proxy.output.destroy()
    end
    -- debug(entity)
    if entity ~= nil then
        entity.insert({name=mine_results})
    end
end