--============================================================================--
-- get_player_level(proxy)
--
-- Helper method that gets the current level of a player proxy
--
-- param proxy (PlayerProxy): The player proxy.
--
-- returns (int): The numeric index of the player's current level, nil in not
--      on a SubTerra surface.
--
--============================================================================--
local get_player_level = function (proxy)
    local player = proxy.player
    if player and player.connected then
        local surface = player.surface
        if surface then
            local layer = global.layers[surface.name]
            if layer then
                return layer.index
            end
        end
    end

    return nil
end

return get_player_level