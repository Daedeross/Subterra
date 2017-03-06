--===================================--
-- building.lua
--===================================--
-- 
--===================================--

require ("util")

function OnBuiltEntity(event)
    handle_placement(event)
end

function handle_placement(event)
    local p = game.players[event.player_index]
    local ent = event.created_entity
    if string.find(ent.name, "subterra-u", 1, true) then
        p.print("u")
        if p.surface.name ~= "underground_1" then
            local prod = ent.prototype.mineable_properties.products[1].name
            p.insert{name = prod, count = 1}
            ent.destroy()
        elseif ent.name == "subterra-u-telepad-up" then
            AddTelepadProxy(ent, p.surface)
        end
    else
        if p.surface.name == "underground_1" then
            local prod = ent.prototype.mineable_properties.products[1].name
            p.insert{name = prod, count = 1}
            ent.destroy()
        elseif ent.name == "subterra-telepad-down" then
            AddTelepadProxy(ent, p.surface)
        end
    end
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