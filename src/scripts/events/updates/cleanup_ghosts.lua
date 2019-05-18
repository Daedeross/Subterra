require("__subterra__.scripts.utils")

function check_ghost_proxy(quadtree, proxy)
    local top_ghost = proxy.top_ghost
    local bottom_ghost = proxy.bottom_ghost

    if not (top_ghost and top_ghost.valid) then
        -- debug(print_bounding_box(proxy.bbox))

        quadtree:remove_proxy(proxy.bbox)
        proxy.top_ghost = nil
        proxy.bottom_ghost = nil

        if bottom_ghost then
            bottom_ghost.destroy()
            return true
        end
    else
        if not (bottom_ghost and bottom_ghost.valid) then
            quadtree:remove_proxy(proxy.bbox)
            proxy.top_ghost = nil
            proxy.bottom_ghost = nil

            if top_ghost then
                top_ghost.destroy()
                return true
            end
        end
    end

    return false
end

function check_ghost_quadtree(quadtree)
    local proxies = shallowcopy(quadtree.proxies)
    local altered = false
    for _,proxy in pairs(proxies) do
        altered = altered or check_ghost_proxy(quadtree, proxy)
    end
    if altered then
        quadtree:rebuild_index()
    end
end

--============================================================================--
-- cleanup_ghosts(event)
--
-- checks every n-th tick (default 6) to see if somehow one side of a pair
--      of ghost proxies has become invalid.
--
-- param event (NthTickEvent): { tick, nth_tick }
--
-- remarks: unsure of the performace hit. May need to increase interval or
--      find another solution.
--============================================================================--
local cleanup_ghosts = function (event)
    local layer_cache = {}

    for key, layer in pairs(global.layers) do
        if not layer_cache[layer] then
            layer_cache[layer] = true
            check_ghost_quadtree(layer.pad_ghosts)
            check_ghost_quadtree(layer.belt_ghosts)
            check_ghost_quadtree(layer.power_ghosts)
        end
    end
end

return cleanup_ghosts