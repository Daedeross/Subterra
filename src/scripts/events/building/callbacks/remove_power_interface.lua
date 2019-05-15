require("__subterra__.scripts.utils")
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
    local proxy = global.power_inputs[mined.unit_number] or global.power_outputs[mined.unit_number]

    if not proxy then
        return
    end
    
    local top_id = proxy.top.unit_number
    local bottom_id = proxy.output.unit_number
    local mine_results = mined.name  -- naming convention, entity is named same as item that places it
    global.power_inputs[top_id] = nil
    global.power_outputs[bottom_id] = nil

    proxy.input.destroy({raise_destroy=true})
    proxy.output.destroy({raise_destroy=true})
    proxy.pole_top.destroy({raise_destroy=true})
    proxy.pole_bottom.destroy({raise_destroy=true})

    if mined == proxy.top then
        proxy.bottom.destroy({raise_destroy=true})
    else 
        proxy.top.destroy({raise_destroy=true})
    end

    if buffer then
        buffer.clear()
        buffer.insert({name=mine_results})
    elseif removing_entity then
        removing_entity.insert({name=mine_results})
    end
end

return handle_remove_power_interface