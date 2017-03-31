rotate_funcs = {}

function OnPlayerRotatedEntity(event)
    local entity = event.entity
    local func = rotate_funcs[entity.name]

    if func != nil then
        func(entity)
    end
end

function swap_belt_elevator(belt_proxy)
    local input = belt_proxy.input
    local output = belt_proxy.output

    local is_down  = string.find(input.name, "%-down") ~= nil
    local in_sname = input.surface.name
    local in_pos = input.position
    local out_pos = output.position

    -- destroy input (it has to swap directions)
    global.belt_inputs[input.unit_number] = nil
    belt_proxy.input = nil
    input.destroy()
    -- move output to old input
    output.teleport(in_pos, in_sname)
    -- create new input
    input = belt_proxy.target_layer.surface.create_entity{
        name = "subterra-belt-" .. (is_down and "up" or "down"),
        position = out_pos,
        force = output.force
    }
    belt_proxy.input = input
    global.belt_inputs[input.unit_number] = input

    -- update target layer
    belt_proxy.target_layer = global.layers[in_sname]
end

rotate_belt = function (belt)
    local proxy = global.belt_inputs[belt.unit_number]
    if proxy == nil then
        proxy = global.belt_outputs[belt.unit_number] 
    end
    if proxy ~= nil then
        swap_belt_elevator(proxy)
    end
end
rotate_funcs["subterra-belt-up"] = rotate_belt
rotate_funcs["subterra-belt-down"] = rotate_belt
rotate_funcs["subterra-belt-out"] = rotate_belt