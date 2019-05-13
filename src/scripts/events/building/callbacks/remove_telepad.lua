require("__subterra__.scripts.utils")
--============================================================================--
-- handle_remove_telepad(entity)
--
-- callback for when a telepad (i.e. Stairs) is removed
--
-- param entity (LuaEntity): The removed telepad
--
--============================================================================--
local handle_remove_telepad = function (entity)
    local sname = entity.surface.name
    local pads = global.layers[sname].telepads
    local proxy = pads:remove_proxy(entity.bounding_box)
    
    if not proxy then
        return
    end

    proxy.target_layer.telepads:remove_proxy(proxy.target_pad.entity.bounding_box)
    proxy.target_pad.entity.destroy({raise_destroy=true})
end

return handle_remove_telepad