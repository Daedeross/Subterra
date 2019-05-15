--============================================================================--
-- players.lua
-- events and functions for managing players in SubTerra
--============================================================================--

require 'util'
require ('config')
require 'scripts/utils'

local display_level = require("__subterra__.scripts.events.ui.display_level")

--============================================================================--
-- on_player_joined()
--
-- add player to needed data structures
--============================================================================--
register_event(defines.events.on_player_joined_game,
function (event)
    local player_index = event.player_index

    add_player_proxy(player_index, nil)

    local player = game.players[player_index]
    display_level(player)
end)

--============================================================================--
-- on_player_respawned()
--
-- add player to needed data structures
--============================================================================--
register_event(defines.events.on_player_respawned,
function (event)
    local player_index = event.player_index

    add_player_proxy(event.player_index, nil)

    local player = game.players[player_index]
    display_level(player)
end)

--============================================================================--
-- on_player_left_game()
--
-- remove player proxy from player_proxies to save computation
--============================================================================--
register_event(defines.events.on_player_left_game,
function (event)
    global.player_proxies[event.player_index] = nil
end)

--============================================================================--
-- on_player_died()
--
-- remove player proxy from player_proxies to save computation
--============================================================================--
register_event(defines.events.on_player_died,
function (event)
    global.player_proxies[event.player_index] = nil
end)

--============================================================================--
-- on_player_changed_surface()
--
-- update the ui when a player changes surfaces
--============================================================================--
register_event(defines.events.on_player_changed_surface,
function (event)
    local player = game.players[event.player_index]
    display_level(player)
end)

-- register_nth_tick_event(600,
-- function (event)
--     for i, proxy in pairs(global.player_proxies) do
--         if proxy.player then
--             display_level(proxy.player)
--         end
--     end
-- end))

register_event("subterra-flip-rolling-stock",
function (event)
    local player = game.players[event.player_index]

    local selected = player and player.selected
    if not (selected and selected.train) then
        return
    end

    debug("disconnect_rolling_stock")
    local front = selected.disconnect_rolling_stock(defines.rail_direction.front)
    local back = selected.disconnect_rolling_stock(defines.rail_direction.back)

    selected.rotate({ by_player = player })

    -- re-connect the stock, but reversed directions
    if front then
        selected.connect_rolling_stock(defines.rail_direction.back)
    end
    if back then
        selected.connect_rolling_stock(defines.rail_direction.front)
    end
end)