local draw_nearby_boxes = require("__subterra__.scripts.events.updates.draw_nearby_boxes")

local duration = ((subterra and subterra.config and subterra.config.BOX_DURATION) or 60) + 1
local draw_radius = (subterra and subterra.config and subterra.config.HAND_DRAW_RADIUS) or 20

local check_entities = {}

check_entities["subterra-telepad-up"] = 1
check_entities["subterra-telepad-down"] = -1

check_entities["subterra-power-up"] = 1
check_entities["subterra-power-down"] = -1

-- TODO: change when belt-elevators become dynamicly generated
check_entities["subterra-transport-belt-up"] = 1
check_entities["subterra-fast-transport-belt-up"] = 1
check_entities["subterra-express-transport-belt-up"] = 1
check_entities["subterra-transport-belt-down"] = -1
check_entities["subterra-fast-transport-belt-down"] = -1
check_entities["subterra-express-transport-belt-down"] = -1

local on_player_cursor_stack_changed = function(event)
    debug("on_player_cursor_stack_changed")
    local player_proxies = global.player_proxies
    local p_index = event.player_index
    local proxy = player_proxies[p_index]
    if not proxy then
        return
    end

    local player = proxy.player
    local cursor_stack = player.cursor_stack
    local old_surface = proxy.draw_surface
    local new_surface
    local player_surface

    if cursor_stack and cursor_stack.valid_for_read then
        local name = cursor_stack.name
        debug("name: " .. name)
        local direction = check_entities[name]
        debug("direction: " .. tostring(direction))
        if direction then
            player_surface = player.surface
            local sname = player_surface.name
            debug("sname: " .. sname)

            local layer = global.layers[sname]
            local target_layer = layer and ((direction == 1 and layer.layer_above) or (direction == -1 and layer.layer_below))
            if target_layer then
                new_surface = target_layer.surface
            else
                new_surface = nil
            end
        else
            new_surface = nil
        end
    else
        new_surface = nil
    end

    proxy.draw_surface = new_surface
    -- if new_surface and (old_surface ~= new_surface) then
    --     local remaining_ticks = event.tick % duration
    --     if remaining_ticks > 0 then
    --         draw_nearby_boxes(player, player_surface, new_surface, draw_radius, remaining_ticks)
    --     end
    -- end
end

return on_player_cursor_stack_changed