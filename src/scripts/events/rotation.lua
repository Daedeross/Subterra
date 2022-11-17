rotate_funcs = {}

function swap_belt_elevator(belt_proxy, direction)
    local input = belt_proxy.input
    local old_in_name = input.name
    local output = belt_proxy.output

    local target_name, subs = string.gsub(old_in_name, "-down", "-out")
    local is_down
    local new_in_name

    if subs > 0 then 
        is_down = true
        new_in_name = string.gsub(target_name, "-out", "-up")
    else
        is_down = false
        target_name, subs = string.gsub(old_in_name, "-up", "-out")
        new_in_name = string.gsub(target_name, "-out", "-down")
    end

    local in_surface = input.surface
    local in_sname = in_surface.name
    local in_pos = input.position
    local out_pos = output.position
    local force = input.force

    -- save inventories
    local in1 = belt_proxy.in_line1
    local in2 = belt_proxy.in_line2
    local out1 = belt_proxy.out_line1
    local out2 = belt_proxy.out_line2

    local new_in1 = {}
    local new_in2 = {}
    local new_out1 = {}
    local new_out2 = {}

    local cin1 = # in1
    local cin2 = # in2
    local cout1 = # out1
    local cout2 = # out2

    if cin1 > 0 then
        for i=1, cin1 do
            new_out1[i] = in1[i].name
        end
    end
    if cin2 > 0 then
        for i=1, cin2 do
            new_out2[i] = in2[i].name
        end
    end
    if cout1 > 0 then
        for i=1, cout1 do
            new_in1[i] = out1[i].name
        end
    end
    if cout2 > 0 then
        for i=1, cout2 do
            new_in2[i] = out2[i].name
        end
    end

    -- destroy input (it has to swap directions)
    global.belt_inputs[input.unit_number] = nil
    global.belt_outputs[output.unit_number] = nil
    belt_proxy.input = nil
    input.destroy()

    -- move output to old input
    -- TODO: switch back to .teleport() when it is implemented
    -- in Factorio
    --output.teleport(in_pos, in_sname)
    belt_proxy.output = nil
    output.destroy()
    output = in_surface.create_entity{
        name = target_name,
        position = in_pos,
        force = force,
        direction = direction
    }

    -- create new input
    input = belt_proxy.target_layer.surface.create_entity{
        name = new_in_name,
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

    -- re-insert items
    if cin1 > 0 then
        for i = 1, cin1 do
            belt_proxy.in_line1.insert_at(i, {name=new_out1[i]})
        end
    end
    if cin2 > 0 then
        for i = 1, cin2 do
            belt_proxy.in_line1.insert_at(i, {name=new_out2[i]})
        end
    end
    if cout1 > 0 then
        for i = 1, cout1 do
            belt_proxy.in_line1.insert_at(i, {name=new_in1[i]})
        end
    end
    if cout2 > 0 then
        for i = 1, cout2 do
            belt_proxy.in_line1.insert_at(i, {name=new_in2[i]})
        end
    end

    global.belt_inputs[input.unit_number] = belt_proxy
    global.belt_outputs[output.unit_number] = belt_proxy
end

function rotate_belt (belt)
    local direction
    local proxy = global.belt_inputs[belt.unit_number]
    if proxy == nil then
        proxy = global.belt_outputs[belt.unit_number] 
    end
    if proxy then
        if proxy.rotated_last then
            direction = (belt.direction + 6) % 8
            proxy.rotated_last = false
        else
            direction = belt.direction
            proxy.rotated_last = true
        end
        
        swap_belt_elevator(proxy, direction)
    end
end

rotate_funcs["belt-elevator"] = rotate_belt

-- register_event(defines.events.on_player_rotated_entity,
-- function (event)
--     local entity = event.entity
--     local ent_name = entity.name

--     if global.belt_elevators[ent_name] then
--         ent_name = "belt-elevator"
--     end

--     local func = rotate_funcs[ent_name]
--     if func then
--         func(entity)
--     end
-- end)
