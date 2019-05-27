--============================================================================--
-- get_adjacent_surfaces(current_surface, direction)
--
-- Helper method that gets nearby surfaces in a particular direction.
--
-- param current_surface (LuaSurface): The surface the player is on
-- param direction (int): The direction in which to get the nearby surfaces
--      nil - returns nill
--      -1  - returns surface below
--      1   - returns surface above
--
-- returns: Array of surfaces
--
--============================================================================--
local get_adjacent_surfaces = function(current_surface, direction)
    if not direction then
        return nil
    end
    local sname = current_surface.name
    local layer = global.layers[sname]
    if layer then
        local target_layer = (direction == 1 and layer.layer_above) or (direction == -1 and layer.layer_below)
        if target_layer then
            return { { target_layer.surface, target_layer.index } }
        elseif direction == 0 then
            return { { current_surface, layer.index } }
        end
    end
    return nil
end

return get_adjacent_surfaces