require 'util'
require("__subterra__.scripts.utils")

--============================================================================--
-- on_chunk_generated(event)
--
-- generates corresponding chunks on above and below layers (if any) when a
--      chunk is generated on a surface
--
-- param event (table): { area, surface }
--
-- remarks: 
--============================================================================--
local on_chunk_generated = function (event)
    local bb = event.area
    local left = bb.left_top.x
    local right = bb.right_bottom.x
    local top = bb.left_top.y
    local bottom = bb.right_bottom.y 

    local surface = event.surface
    local layer = global.layers[surface.name]
    -- if the surface name is not a key in global.layers
    -- then it is a surface from another mod and will be ignored
    if not layer then
        return
    end

    local index = layer.index    
    local pos = { left + 16, top + 16 }

    -- genreate chunk on other layers if necessary
    for i, other_layer in pairs(global.layers) do
        if i ~= index then
            local l_surface = other_layer.surface
            --if l_surface.is_chunk_generated(pos) then
                l_surface.request_to_generate_chunks(pos, 0)
            --end
        end
    end

    local whitelist = global.underground_whitelist

    -- clear entities and set tiles if this is a below ground chunk
    if index ~= 1 then
        local entities = surface.find_entities(bb)
        for k, e in pairs(entities) do
            if not(   e.type == 'player' -- just in case someone is walking there when it's generating...
                   or e.type == 'item'
                   or whitelist[e.name])
               then  
                e.destroy()
            end
        end
        -- replace whatever tiles are there with underground tile(s)
        local new_tiles = {}
        for i=left, right do
            for j=top, bottom do
                local old_tile = surface.get_tile(i, j).name
                if index > 2 then
                    table.insert(new_tiles, {name="sub-dirt", position={i,j}})
                elseif old_tile == "water" or old_tile == "water-green" or old_tile == "deepwater" or old_tile == "deepwater-green" then
                    table.insert(new_tiles, {name="deepwater", position={i,j}})
                else
                    table.insert(new_tiles, {name="sub-dirt", position={i,j}})
                end
            end
        end
        surface.set_tiles(new_tiles)
        -- remove decoratives
        surface.destroy_decoratives(bb)
    end
end

return on_chunk_generated