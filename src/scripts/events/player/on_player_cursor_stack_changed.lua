local draw_nearby_boxes = require("__subterra__.scripts.events.ui.draw_nearby_boxes")
local get_adjacent_surfaces = require("__subterra__.scripts.events.player.get_adjacent_surfaces")
local get_all_subterra_surfaces = require("__subterra__.scripts.events.player.get_all_subterra_surfaces")
local get_player_level = require("__subterra__.scripts.events.player.get_player_level")

local duration = ((subterra and subterra.config and subterra.config.BOX_DURATION) or 60) + 1
local draw_radius = (subterra and subterra.config and subterra.config.HUD_DRAW_RADIUS) or 20
local power_radius = math.floor(draw_radius / 2)

-- helper callback functions
local above_callback = function(surface)
    return get_adjacent_surfaces (surface, 1)
end
local below_callback = function(surface)
    return get_adjacent_surfaces (surface, -1)
end
local get_all_but = function (current_surface)
    -- debug("current: " .. current_surface.name)
    local surfaces = {}
    local all_surfaces = get_all_subterra_surfaces()
    for i = 1, #all_surfaces do
        local surface_tuple = all_surfaces[i]
        -- debug(surface_tuple[1].name)
        if surface_tuple[1] ~= current_surface then
            table.insert(surfaces, surface_tuple)
        end
    end
    return surfaces
end

-- callbacks based on entity name
local check_entities = {}
check_entities["subterra-telepad-up"] = above_callback
check_entities["subterra-telepad-down"] = below_callback

check_entities["subterra-power-up"] = get_all_but
check_entities["subterra-power-column"] = get_all_but

-- TODO: change when belt-elevators become dynamicly generated
check_entities["subterra-transport-belt-up"] = above_callback
check_entities["subterra-fast-transport-belt-up"] = above_callback
check_entities["subterra-express-transport-belt-up"] = above_callback
check_entities["subterra-transport-belt-down"] = below_callback
check_entities["subterra-fast-transport-belt-down"] = below_callback
check_entities["subterra-express-transport-belt-down"] = below_callback
--============================================================================--
-- on_player_cursor_stack_changed(event)
--
-- Called when a player changes their cursor stack or when changing surfaces
--
-- param event (table): { player_index }
--
-- remarks: This sets the proxy's draw_surfaces and current_level properties
--      which are used to draw the "HUD" that aids entity placement.
--============================================================================--
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
    local draw_surfaces
    local player_surface

    if cursor_stack and cursor_stack.valid_for_read then
        local tech = player.force.technologies["subterra-mapping"]
        if tech.level > 1 then
            local name = cursor_stack.name
            debug("name: " .. name)
            local callback = check_entities[name]
            if callback then
                player_surface = player.surface
                draw_surfaces = callback(player_surface)
            end
        end
    end

    proxy.draw_surfaces = draw_surfaces
    proxy.current_level = (draw_surfaces and get_player_level(proxy)) or nil

    local drawing_players = global.drawing_players
    local count = # drawing_players
    local current_index
    if count > 0 then
        for i = 1, count do
            if drawing_players[i] == proxy then
                current_index = i
                break
            end
        end
    end
    if draw_surfaces and # draw_surfaces > 0 then
        if not current_index then
            table.insert(drawing_players, proxy)
        end
    else
        if current_index then
            table.remove(drawing_players, current_index)
        end
    end
    -- if new_surface and (old_surface ~= new_surface) then
    --     local remaining_ticks = event.tick % duration
    --     if remaining_ticks > 0 then
    --         draw_nearby_boxes(player, player_surface, new_surface, draw_radius, remaining_ticks)
    --     end
    -- end
end

return on_player_cursor_stack_changed