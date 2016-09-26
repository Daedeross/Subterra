--===================================--
-- building.lua
--===================================--
-- 
--===================================--

require ("util")

function OnBuiltEntity(event)
    local p_index = event.player_index
    local p = game.players[p_index]
    local surface = game.players[event.player_index].surface
    if surface.name == "underground-1" then
        handle_sub_placement(event)
    elseif surface.name == "nauvis" then
        handle_surface_placement(event)
    end
end

function handle_sub_placement(event)
    local ent = event.created_entity
    if not string.find(ent.name, "subterra_") then
        local prod = ent.prototype.mineable_properties.products[1].name
        p.insert{name = prod, count = 1}
        ent.destroy()
    else
        if ent.name == "subterra_belt-telepad" then
            local proxy = {
                entity = ent,
                bbox = ent.bounding_box,
            }
            global.underground.belt_telepads.add_proxy(proxy)
        end
    end
end