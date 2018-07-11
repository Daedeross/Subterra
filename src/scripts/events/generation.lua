--============================================================================--
-- generation.lua
--============================================================================--
-- for handling terrain generation in underground layer(s)
--============================================================================--

require 'util'
require 'scripts/utils'

register_event(defines.events.on_chunk_generated,
function (event)
    local bb = event.area
    local surface = event.surface
    local pos = {bb.left_top.x + 16, bb.left_top.y + 16 }
    local layer = global.layers[surface.name]
    -- if the surface name is not a key in global.layers,
    -- then it is a surface from another mod and will be ignored
    if not layer then
        return
    end
    local index = layer.index
    -- genreate chunk on other layers if necessary
    for i = 1, subterra.config.MAX_LAYER_COUNT do
        if i ~= index then
            local l_surface = global.layers[i].surface
            if l_surface.is_chunk_generated(pos) then
                l_surface.request_to_generate_chunks(pos, 0)
            end
        end
    end

    -- clear entities and set tiles if this is a below ground chunk
    if index ~= 1 then

        local entities = surface.find_entities(bb)
        for k, e in pairs(entities) do
            if e.type ~= 'player' and -- just in case someone is walking there when it's generating...
               e.type ~= 'item' and
               not global.underground_whitelist[e.name]
               then  
                entities[k].destroy()
            end
        end
        -- replace whatever tiles are there with underground tile(s)
        local new_tiles = {}
        for i=bb.left_top.x, bb.right_bottom.x do
            for j=bb.left_top.y, bb.right_bottom.y do
                --local old_tile = surface.get_tile(i, j).name
                --if not (old_tile == "water" or old_tile == "water-green" or old_tile == "deepwater" or old_tile == "deepwater-green") then
                    table.insert(new_tiles, {name="sub-dirt", position={i,j}})
                --end
            end
        end
        surface.set_tiles(new_tiles)
        -- remove decoratives
        surface.destroy_decoratives(bb)
    end
end)
