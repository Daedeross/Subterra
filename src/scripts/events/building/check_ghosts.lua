--============================================================================--
-- check_ghosts(layer, quadtree, bounding_box)
--
-- check for and remove ghost proxies within an area
--
-- param layer (table): The entry from the global.layers table
--      see TODO for definition
-- param quadtree (Quadtree): The container to check
-- param bounding_box (BoundingBox): the bounding box the check
--
--============================================================================--
local check_ghosts = function (layer, quadtree, bounding_box)
    local found_proxy = quadtree:remove_proxy(bounding_box)
    if found_proxy then
        local top_ghost = found_proxy.top_ghost
        if top_ghost and top_ghost.valid then
            top_ghost.destroy()
        end
        local bottom_ghost = found_proxy.bottom_ghost
        if bottom_ghost and bottom_ghost.valid then
            bottom_ghost.destroy()
        end
        if found_proxy.top_layer == layer then
            return found_proxy.bottom_layer
        else
            return found_proxy.top_layer
        end
    end
    return false
end

return check_ghosts