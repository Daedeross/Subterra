--===================================--
-- building.lua
--===================================--
-- 
--===================================--

require ("util")

function OnBuiltEntity(event)
    if game.players[event.player_index].surface.name == "underground-1" then
        handle_placement(event)
    end
end

function handle_placement(event)
    local p = game.players[event.player_index]
    local ent = event.created_entity
    if not string.find(ent.name, "subterra_") then
        local prod = ent.prototype.mineable_properties.products[1].name
        p.insert{name = prod, count = 1}
        ent.destroy()
    end
end