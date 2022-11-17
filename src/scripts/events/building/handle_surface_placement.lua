require("__subterra__.scripts.utils")

local check_all_ghosts = require("__subterra__.scripts.events.building.check_all_ghosts")
local destroy_and_return = require("__subterra__.scripts.events.building.destroy_and_return")
local name_callbacks = require("__subterra__.scripts.events.building.callbacks.name_callbacks")
local type_callbacks = require("__subterra__.scripts.events.building.callbacks.type_callbacks")

--============================================================================--
-- handle_surface_placement(entity, creator, layer)
--
-- handle entity placement for the top layer (nauvis)
--
-- param entity (LuaEntity): The entity just placed
-- param creator (LuaEntity): The entity (player or robot) that placed the
--      new entity. nil if placed by other means (i.e. via script)
-- param layer (table): The Subterra layer the entity was placed on
-- 
--============================================================================--
local handle_surface_placement = function (entity, creator, layer)
    debug("handle_surface_placement. layer " .. ((layer and layer.index) or 0) .. " | entity = " .. entity.name)

    -- clean up any ghost proxies
    check_all_ghosts(layer, entity.bounding_box)

    local ent_name = entity.name
    if ent_name == "entity-ghost" then
        ent_name = entity.ghost_prototype.name
    end

    if global.belt_elevators[ent_name] then
        ent_name = "belt-elevator"
    end

    local player
    if creator and creator.is_player() then
        player = creator
    end

    -- first check of there is a callback for the specific name of the entity (i.e. name has priority)
    local callback = name_callbacks.surface_build[ent_name]
    if callback then
        if not layer then
            if player then
                fly_text(player, {"building-surface-blacklist", {"entity-name."..ent_name}}, entity.position)
            end
            destroy_and_return(entity, creator)
        else
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
        end
    else
        -- then check by type
        callback = type_callbacks.surface_build[entity.type]
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
        end
    end
end

return handle_surface_placement