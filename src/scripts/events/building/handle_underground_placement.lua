require("__subterra__.scripts.utils")

local check_all_ghosts = require("__subterra__.scripts.events.building.check_all_ghosts")
local destroy_and_return = require("__subterra__.scripts.events.building.destroy_and_return")
local name_callbacks = require("__subterra__.scripts.events.building.callbacks.name_callbacks")
local type_callbacks = require("__subterra__.scripts.events.building.callbacks.type_callbacks")
--============================================================================--
-- handle_underground_placement(entity, creator, layer)
--
-- handle entity placement for underground layers
--
-- param entity (LuaEntity): The entity just placed
-- param creator (LuaEntity): The entity (player or robot) that placed the
--      new entity. nil if placed by other means (i.e. via script)
-- param layer (table): The Subterra layer the entity was placed on
-- 
--============================================================================--
local handle_underground_placement = function (entity, creator, layer)
    debug("handle_underground_placement. layer " .. ((layer and layer.index) or 0) .. " | entity = " .. entity.name)
    -- clean up any ghost proxies
    check_all_ghosts(layer, entity.bounding_box)

    local player
    if creator and creator.is_player() then
        player = creator
    end

    local ent_name = entity.name
    if ent_name == "entity-ghost" then
        ent_name = entity.ghost_prototype.name
    end
    
    if global.belt_elevators[ent_name] then
        ent_name = "belt-elevator"
    end
    
    local callback = name_callbacks.underground_build[ent_name]
    if callback then
        local result, message = callback(entity, creator.surface, creator)
        if not result then
            if player and message then 
                fly_text(player, message, entity.position)
            end
            destroy_and_return(entity, creator)
        end
    else
        callback = type_callbacks.underground_build[entity.type]
        if callback then
            local result, message = callback(entity, creator.surface, creator) 
            if not result then
                if player then
                    if message then
                        fly_text(player, message, entity.position)
                    else
                        fly_text(player, {"message.building-conflict", {"entity-name."..ent_name}}, entity.position)
                    end
                end
                destroy_and_return(entity, creator)
            end
        else
            debug("Tried to place:" .. ent_name)
            if not global.underground_whitelist[ent_name] then
                if player then
                    fly_text(player, {"message.building-blacklist", {"entity-name."..ent_name}}, entity.position)
                end
                -- game.players[1].debug("dest: " .. ent_name)
                destroy_and_return(entity, creator)
            end
        end
    end
end

return handle_underground_placement