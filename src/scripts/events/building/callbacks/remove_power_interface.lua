require("__subterra__.scripts.utils")

local function destroy_hidden_entities(proxy, mined, max_level)
    local unit_numbers = {}
    local inputs = proxy.inputs
    local outputs = proxy.outputs
    local columns = proxy.columns
    local poles = proxy.poles
    
    for i = 1, max_level do
        local column = columns[i]
        if column then
            unit_numbers[i] = column.unit_number
            if column ~= mined and column.valid then
                column.destroy({raise_destroy=true})
            end
            -- not raising destroy for hidden entities
            if inputs[i].valid then inputs[i].destroy() end
            if outputs[i].valid then outputs[i].destroy() end
            if poles[i].valid then poles[i].destroy() end
        else
            unit_numbers[i] = mined.unit_number
        end
    end

    return unit_numbers
end

--============================================================================--
-- handle_remove_power_interface(mined, removing_entity, buffer)
--
-- callback for when a power-interface is removed
--
-- param mined (LuaEntity): The removed power transferer
-- param removing_entity (LuaSurface): The entity that removed it (can be nil)
-- param buffer (LuaEntity): The buffer inventory of the remover (or nil)
--
--============================================================================--
local handle_remove_power_interface = function (mined, removing_entity, buffer)
    if not mined.valid then
        return
    end
    local power_proxies = global.power_proxies
    local proxy = power_proxies[mined.unit_number]

    if not proxy then
        return
    end

    if (proxy.destroying) then
        return
    end

    proxy.destroying = true          -- to prevent re-entry for same proxy
    local mine_results = mined.name  -- naming convention, entity is named same as item that places it

    local max_level = settings.startup["subterra-max-depth"].value + 1  -- level is depth + 1 (i.e. nauvis = depth 0 & level 1)
    local unit_numbers = destroy_hidden_entities(proxy, mined, max_level)

    -- remove proxy from index
    for _, unit_number in pairs(unit_numbers) do
        power_proxies[unit_number] = nil
    end
    local power_array = global.power_array
    for i = 1, # power_array do
        if power_array[i] == proxy then
            table.remove(power_array, i)
            break
        end
    end

    if buffer then
        buffer.clear()
        buffer.insert({name=mine_results})
    elseif removing_entity then
        removing_entity.insert({name=mine_results})
    end
end

return handle_remove_power_interface