

function OnTick(event)
    local tick = event.tick

    if tick % 30 == 0 then
        CheckPads()
    end    
end

function CheckPads()
    for _, p in pairs(global.player_proxies) do
        if p.surface.name == "underground-1" then
            if global.underground.belt_telepads.check_proxy_collision(p.bounding_box) then
                p.teleport("nauvis", p.position)
            end
        elseif p.surface.name == "nauvis" then
            if global.nauvis.belt_telepads.check_proxy_collision(p.bounding_box) then
                p.teleport("nauvis", p.position)
            end
        end
    end
end

