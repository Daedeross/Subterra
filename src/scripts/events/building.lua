--===================================--
-- building.lua
--===================================--
-- 
--===================================--

require ("util")

function OnBuiltEntity(event)
    local p_index = event.player_index
    local player = game.players[event.player_index]
    --local p = game.players[p_index]
    local surface = player.surface
    local level = string.match(surface.name, "underground_(%d)")
    if level == nil then
        handle_surface_placement(event, player)
    else
        handle_underground_placement(event, player, level)
    end
end

function destroy_and_return(built_entity, placing_entity)
    local prod = built_entity.prototype.mineable_properties.products[1].name
    placing_entity.insert{name = prod, count = 1}
    built_entity.destroy()
end

function handle_surface_placement(event, p)
    local ent = event.created_entity
    debug("place")
    debug(ent.name)
    debug(string.find(ent.name, "subterra%-belt"))
    if string.find(ent.name, "telepad") ~= nil then
        if not AddTelepadProxy(ent, p.surface) then
            destroy_and_return(ent, p)
        end
    elseif string.find(ent.name, "subterra%-belt") ~= nil then
        debug("belt")
        if not add_belt_proxy(ent, p.surface) then
            destroy_and_return(ent, p)
        end
    end
end

function handle_underground_placement(event, p, level)
    local ent = event.created_entity

    if global.underground_entities[ent.name] then
        if string.find(ent.name, "telepad") ~= nil then
            if not AddTelepadProxy(ent, p.surface) then
                destroy_and_return(ent, p)
            end
        elseif string.find(ent.name, "subterra%-belt") ~= nil then
            if not add_belt_proxy(ent, p.surface) then
                destroy_and_return(ent, p)
            end
        end
    else
        destroy_and_return(ent, p)
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
    local is_down = string.find(pad.name, "down") ~= nil
    local layer = global.layers[sname]
    local target_layer
    
    --debug(layer)
    if is_down then
        target_layer = layer.layer_below
    else
        target_layer = layer.layer_above
    end
    
    --debug(target_layer)
    -- check if target layer exists
    if target_layer == nil then
        return false
    end

    -- first check for collision up/downstairs
    -- nah, I'll do that later

    -- add padd to proxies
    local pad_proxy = {
        name = "proxy_" .. string.format("%010d", pad.unit_number),
        target_layer = target_layer,
        entity = pad,
        bbox = pad.bounding_box,
        players = {}    -- TODO: for tracking status of players standing on pad after teleporting, to prevent loops
    }
    global.layers[sname].telepads:add_proxy(pad_proxy)

    -- add pad to other surface
    -- if string.find(sname, "underground", 1, true) then
        
    -- end
    return true
end

function add_belt_proxy(belt, surface)
    local sname = surface.name
    local is_down = string.find(belt.name, "%-down") ~= nil
    local is_in = string.find(belt.name, "%-in") ~= nil
    local layer = global.layers[sname]

    local target_layer
    local target_name

    --debug(layer)
    if is_down then
        target_layer = layer.layer_below
        target_name = "subterra-belt-down-" .. (is_in and "out" or "in")
    else
        target_layer = layer.layer_above
        target_name = "subterra-belt-up-" .. (is_in and "out" or "in")
    end
    
    --debug(target_layer)
    -- check if target layer exists
    if target_layer == nil then
        return false
    end

    debug("placing")

    -- check if target location is free
    local target_surface = target_layer.surface
    if not target_surface.can_place_entity{name = target_name, position = belt.position} then
        return false
    end

    local target_entity = target_surface.create_entity{
        name = target_name,
        position = belt.position,
        force = belt.force
    }

    debug("placed target")
    debug(target_entity)

    local belt_proxy = {
        id = belt.unit_number,
        input = is_in and belt or target_entity,
        output = is_in and target_entity or belt,
        target_layer = target_layer,
    }
    global.belt_elevators[belt.unit_number] = belt_proxy
    return true
end

function OnEntityDied(event)
    if string.find(event.entity.prototype.name, "telepad") ~= nil then
        handle_remove_telepad(event.entity)
    end
end

function OnPrePlayerMinedItem(event)
    if string.find(event.entity.prototype.name, "telepad") ~= nil then
        handle_remove_telepad(event.entity)
    end
end

function OnPreRobotMinedItem(event)
    if string.find(event.entity.prototype.name, "telepad") ~= nil then
        handle_remove_telepad(event.entity)
    end
end

function handle_remove_telepad(entity)
    local sname = entity.surface.name
    local pads = global.layers[sname].telepads
    local proxy = pads:remove_proxy(entity.bounding_box)
end

function debug(x)
    game.players[1].print(tostring(x))
end