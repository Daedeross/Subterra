--============================================================================--
-- players.lua
-- events and functions for managing players in SubTerra
--============================================================================--

require 'util'
require ('config')
require 'scripts/utils'

--============================================================================--
-- on_player_joined()
--
-- add player to needed data structures
--============================================================================--
register_event(defines.events.on_player_joined_game,
function (event)
    add_player_proxy(event.player_index, nil)
end)

--============================================================================--
-- on_player_joined()
--
-- remove player proxy from player_proxies to save computation
--============================================================================--
register_event(defines.events.on_player_left_game,
function (event)
    global.player_proxies[event.player_index] = nil
end)
