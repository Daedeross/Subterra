--============================================================================--
-- generation.lua
--============================================================================--
-- for handling terrain generation in underground layer(s)
--============================================================================--

require 'util'
require 'scripts/utils'

function OnChunkGenerated(event)
    local bb = event.area
    local surface = event.surface
    local pos = {bb.left_top.x + 16, bb.left_top.y + 16 }
    if surface.name == "nauvis" then
        -- generate below-ground chunk if necessary
        if not game.surfaces["underground_1"].is_chunk_generated(pos) then
            game.surfaces["underground_1"].request_to_generate_chunks(pos, 1)
        end
    elseif surface.name == "underground_1" then
        --game.print("Gen")
        
        -- generate above-ground chunk if necessary
        if not game.surfaces["nauvis"].is_chunk_generated(pos) then
            game.surfaces["nauvis"].request_to_generate_chunks(pos, 1)
        end
        
        local entities = surface.find_entities(bb)
        for k, e in pairs(entities) do
            if e.type ~= 'player' then  -- just in case someone is walking there when it's generating...
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
    end
end

