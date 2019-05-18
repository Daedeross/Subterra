require("__subterra__.scripts.utils")
--============================================================================--
-- check_telepads(event)
--
-- checks every n-th tick (default 5) to see if a player stepped on a
--      telepad. If so, teleports them to a new layer.
--
-- param event (NthTickEvent): { tick, nth_tick }
--
-- remarks: player_proxy.on_pad corresponds to the unit_number of the pad the
--      player was standing on last time it was checked. Will only teleport
--      the player if this is not equal to the unit number of the pad the
--      player is now standing on. -1 means no pad.
--============================================================================--
local check_telepads = function (event)
    local player_proxies = global.player_proxies
    for i, p in pairs(player_proxies) do
        local player = p.player
        if player.connected then
            if player.character then
                local sname = player.surface.name
                local layer = global.layers[sname]
                local qt = layer and layer.telepads
                if qt then
                    local pad = qt:check_proxy_collision(player.character.bounding_box)
                    if pad then
                        if p.on_pad ~= pad.entity.unit_number then
                            player.teleport(player.position, pad.target_layer.surface.name)
                            debug("Teleported player:" .. player.name)
                            p.on_pad = pad.target_pad.entity.unit_number
                        end
                    else
                        p.on_pad = -1
                    end
                else
                    p.on_pad = -1
                end
            else
                p.on_pad = -1
            end
        else
            player_proxies[i] = nil
        end
    end
end

return check_telepads