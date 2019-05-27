local draw_nearby_boxes = require("__subterra__.scripts.events.ui.draw_nearby_boxes")

local draw_radius = (subterra and subterra.config and subterra.config.HUD_DRAW_RADIUS) or 20
 -- not sure why, but need this +1 to prevent flicker. TODO: smoothe out like radar updates.
local duration = ((subterra and subterra.config and subterra.config.BOX_DURATION) or 60) + 1
--============================================================================--
-- do_player_drawing(event)
--
-- checks every n-th tick (default 60) and draws the placement HUD for players
--      that need it.
--
-- param event (NthTickEvent): { tick, nth_tick }
--
--============================================================================--
local do_player_drawing = function (event)
    local drawing_players = global.drawing_players
    local count = # drawing_players

    for i = 1, count do
        local proxy = drawing_players[i]
        local player = proxy and proxy.player
        if player and player.connected then
            local player_settings = settings.get_player_settings(player)
            local show_hud = player_settings and player_settings["subterra-show-build-hud"]
            if show_hud and show_hud.value then
                local target_surfaces = proxy.draw_surfaces
                local surface_count = (target_surfaces and # target_surfaces) or 0
                if surface_count > 0 then
                    local current_surface = player.surface
                    local current_level
                    for j = 1, surface_count do
                        local target_surface = target_surfaces[j]
                        local diff = proxy.current_level - target_surface[2]
                        draw_nearby_boxes(player, current_surface, target_surface[1], draw_radius, duration, diff)
                    end
                else
                    proxy.draw_surfaces = nil
                end
            else
                proxy.draw_surfaces = nil
            end
        end
    end
end

return do_player_drawing