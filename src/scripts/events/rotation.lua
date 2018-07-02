rotate_funcs = {}

function swap_belt_elevator(belt_proxy, direction)
    local input = belt_proxy.input
    local output = belt_proxy.output

    local is_down  = string.find(input.name, "%-down") ~= nil
    local in_surface = input.surface
    local in_sname = in_surface.name
    local in_pos = input.position
    local out_pos = output.position
    local force = input.force

    -- destroy input (it has to swap directions)
    global.belt_inputs[input.unit_number] = nil
    global.belt_outputs[output.unit_number] = nil
    belt_proxy.input = nil
    input.destroy()

    -- move output to old input
    -- TODO: switch back to .teleport() when it in implemented
    -- in Factorio
    --output.teleport(in_pos, in_sname)
    belt_proxy.output = nil
    output.destroy()
    output = in_surface.create_entity{
        name = "subterra-belt-out",
        position = in_pos,
        force = force,
        direction = direction
    }

    -- create new input
    input = belt_proxy.target_layer.surface.create_entity{
        name = "subterra-belt-" .. (is_down and "up" or "down"),
        position = out_pos,
        force = force,
        direction = direction
    }
    belt_proxy.input = input
    belt_proxy.output = output
    belt_proxy.in_line1 = input.get_transport_line(1)
    belt_proxy.in_line2 = input.get_transport_line(2)
    belt_proxy.out_line1 = output.get_transport_line(1)
    belt_proxy.out_line2 = output.get_transport_line(2)
    -- update target layer
    belt_proxy.target_layer = global.layers[in_sname]

    global.belt_inputs[input.unit_number] = belt_proxy
    global.belt_outputs[output.unit_number] = belt_proxy
end

function rotate_belt (belt)
    local direction
    local proxy = global.belt_inputs[belt.unit_number]
    if proxy == nil then
        proxy = global.belt_outputs[belt.unit_number] 
    end
    if proxy ~= nil then
        if proxy.rotated_last then
            direction = (belt.direction + 6) % 8
            proxy.rotated_last = false
        else
            direction = belt.direction
            proxy.rotated_last = true
        end
        --game.players[1].print(tostring(direction))
        --game.players[1].print("swap")
        swap_belt_elevator(proxy, direction)
    end
end

rotate_funcs["subterra-belt-up"] = rotate_belt
rotate_funcs["subterra-belt-down"] = rotate_belt
rotate_funcs["subterra-belt-out"] = rotate_belt

register_event(defines.events.on_player_rotated_entity,
function (event)
    local entity = event.entity
    local func = rotate_funcs[entity.name]
    if func ~= nil then
        func(entity)
    end
end)
