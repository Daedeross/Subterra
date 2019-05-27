require("__subterra__.scripts.utils")

local function get_line_items (proxy)
    local all_items = {}

    for name, count in pairs(proxy.in_line1.get_contents()) do
        if all_items[name] then
            all_items[name] = all_items[name] + count
        else
            all_items[name] = count
        end
    end
    for name, count in pairs(proxy.in_line2.get_contents()) do
        if all_items[name] then
            all_items[name] = all_items[name] + count
        else
            all_items[name] = count
        end
    end
    for name, count in pairs(proxy.out_line1.get_contents()) do
        if all_items[name] then
            all_items[name] = all_items[name] + count
        else
            all_items[name] = count
        end
    end
    for name, count in pairs(proxy.out_line2.get_contents()) do
        if all_items[name] then
            all_items[name] = all_items[name] + count
        else
            all_items[name] = count
        end
    end

    return all_items
end

--============================================================================--
-- handle_remove_belt_elevator(belt, removing_entity, buffer)
--
-- callback for when a belt-elevator is removed
--
-- param belt (LuaEntity): The removed belt-elevator
-- param removing_entity (LuaSurface): The entity that removed it (can be nil)
-- param buffer (LuaEntity): The buffer inventory of the remover (or nil)
--
--============================================================================--
local handle_remove_belt_elevator = function (belt, removing_entity, buffer)
    local proxy = global.belt_inputs[belt.unit_number] or global.belt_outputs[belt.unit_number]
    
    if not proxy then
        return
    end

    local in_id = proxy.input.unit_number
    local out_id = proxy.output.unit_number
    local mine_results = proxy.input.name -- naming convention, entity is named same as item that places it

    local original_mined = belt.prototype.mineable_properties.products[1].name -- belt-elevators always have only 1 mine result

    local contents = get_line_items(proxy)

    global.belt_inputs[in_id].removed = true
    global.belt_outputs[out_id].removed = true
    global.belt_inputs[in_id] = nil
    global.belt_outputs[out_id] = nil

    if belt ~= proxy.input then
        proxy.input.destroy({raise_destroy=true})
    else 
        proxy.output.destroy({raise_destroy=true})
    end

    if removing_entity then
        if buffer then  -- first try and insert into event buffer
            buffer.remove(original_mined)
            buffer.insert({name=mine_results})
            for name, count in pairs(contents) do
                buffer.insert({name=name, count=count})
            end
        else -- then try and insert into entity
            removing_entity.insert({name=mine_results})
            for name, count in pairs(contents) do
                removing_entity.insert({name=name, count=count})
            end
        end
    else -- last try and spill onto surface
        local surface = belt.surface
        if surface then
            local position = belt.position
            for name, count in pairs(contents) do
                surface.spill_item_stack(position, {name=name, count=count})
            end
        end
    end
end

return handle_remove_belt_elevator