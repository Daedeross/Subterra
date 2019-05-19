local draw_nearby_boxes = require("__subterra__.scripts.events.updates.draw_nearby_boxes")

local draw_radius = (subterra and subterra.config and subterra.config.HAND_DRAW_RADIUS) or 20
local duration = ((subterra and subterra.config and subterra.config.BOX_DURATION) or 60) + 1

local do_player_drawing = function (event)
    local player_proxies = global.player_proxies

    for i, p in pairs(player_proxies) do
        if p.draw_surface then
            local player = p.player
            if player.connected then
                if player.character then
                    local target_surface = p.draw_surface
                    if target_surface then
                        local current_surface = player.surface
                        if current_surface then
                            draw_nearby_boxes(player, current_surface, target_surface, draw_radius, duration)
                        end
                    end
                else
                    p.draw_surface = nil
                end
            else
                player_proxies[i] = nil
            end
        end
    end
end

return do_player_drawing