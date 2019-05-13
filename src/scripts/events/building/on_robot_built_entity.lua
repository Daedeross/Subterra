local handle_surface_placement = require("__subterra__.scripts.events.building.handle_surface_placement")
local handle_underground_placement = require("__subterra__.scripts.events.building.handle_underground_placement")

--============================================================================--
-- on_robot_built_entity(event)
--
-- event handler for defines.events.on_robot_built_entity
--
-- param entity (table): see factorio api docs for definition of event args
-- 
--============================================================================--
local on_robot_built_entity = function (event)
    local robot = event.robot
    local entity = event.created_entity
    local surface = robot.surface
    local layer = global.layers[surface.name]

    if (not layer) or (layer.index == 1) then
        handle_surface_placement(entity, robot, layer)
    else
        handle_underground_placement(entity, robot, layer)
    end
end

return on_robot_built_entity