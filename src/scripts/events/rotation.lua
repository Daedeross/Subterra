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
    -- update target layer
    belt_proxy.target_layer = global.layers[in_sname]

    global.belt_inputs[input.unit_number] = belt_proxy
    global.belt_outputs[output.unit_number] = belt_proxy

    belt_proxy.swapped_last = true
end

function rotate_belt (belt)
    local direction = (belt.direction + 6) % 8
    local proxy = global.belt_inputs[belt.unit_number]
    if proxy == nil then
        proxy = global.belt_outputs[belt.unit_number] 
    end
    if proxy ~= nil then
        if proxy.swapped_last then
            game.players[1].print(tostring(direction))
            proxy.input.direction = (direction + 2) % 8
            proxy.output.direction = proxy.input.direction
            proxy.swapped_last = false
        else
            game.players[1].print(tostring(direction))
            game.players[1].print("swap")
            swap_belt_elevator(proxy, direction)
            proxy.swapped_last = true
        end
    end
end

rotate_funcs["subterra-belt-up"] = rotate_belt
rotate_funcs["subterra-belt-down"] = rotate_belt
rotate_funcs["subterra-belt-out"] = rotate_belt

-- function swap_telepads (proxy)

-- end

-- function rotate_telepad(pad)
--     local q_tree = global.layers[pad.surface.name].swap_telepads
--     local proxy = q_tree:
-- end

function OnPlayerRotatedEntity(event)
    local entity = event.entity
    local func = rotate_funcs[entity.name]
    if func ~= nil then
        func(entity)
    end
end