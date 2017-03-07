--===================================--
-- building.lua
--===================================--
-- 
--===================================--

require ("util")

function OnBuiltEntity(event)
    local p_index = event.player_index
    --local p = game.players[p_index]
    local surface = game.players[p_index].surface
    local level = string.match(surface.name"underground_(%d)")
    if level == nil then
        handle_surface_placement(event)
    else
        handle_underground_placement(event, level)
    end
end

function handle_surface_placement(event)
    local ent = event.created_entity
    if string.find(ent.name, "subterra-u", 1, true) then
        --p.print("u")
        local prod = ent.prototype.mineable_properties.products[1].name
        p.insert{name = prod, count = 1}
        ent.destroy()
    elseif ent.name == "subterra-telepad-down" then
        AddTelepadProxy(ent, p.surface)
    end
end

function handle_underground_placement(event, level)
    local ent = event.created_entity
    if string.find(ent.name, "subterra-u", 1, true) == nil then
        local prod = ent.prototype.mineable_properties.products[1].name
        p.insert{name = prod, count = 1}
        ent.destroy()
    elseif ent.name == "subterra-u-telepad-up" then
        AddTelepadProxy(ent, p.surface)
    end
-- =======
--     if not string.find(ent.name, "subterra_u-") then
--         local prod = ent.prototype.mineable_properties.products[1].name
--         p.insert{name = prod, count = 1}
--         ent.destroy()
--     else
--         if ent.name == "subterra_belt-up" then
--             -- check above-ground spot
--             local newEnt = {
--                 name = "subterra_belt-down",
--                 position = ent.position,
--                 direction = ent.direction,
--                 force = ent.force,
--             }
--             if game.surfaces["nauvis"].can_place_entity{
--                 } then
--                 game.surfaces
--             end
--             local proxy = {
--                 input = ent,
--                 bbox = ent.bounding_box,
--             }
--             global.underground.belt_telepads.add_proxy(proxy)
-- >>>>>>> eded83eb5a99b4e9f0c3f829b055f2873e0679d9
end

function AddTelepadProxy(pad, surface)
    local sname = surface.name
    -- first check for collision up/downstairs
    -- nah, I'll do that later

    -- add padd to proxies
    local id = math.random(2147483647);

    local pad_proxy = {
        name = "proxy_" .. string.format("%010d", id),
        entity = pad,
        bbox = pad.bounding_box
    }
    global.telepads[sname]:add_proxy(pad_proxy)

    -- add pad to other surface
    -- if string.find(sname, "underground", 1, true) then
        
    -- end
end