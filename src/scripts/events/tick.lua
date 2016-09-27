

function OnTick(event)
    local tick = event.tick
    CheckBelts()
    if tick % 30 == 0 then
        CheckPads()
    end    
end

function CheckPads()
    for _, p in pairs(global.player_proxies) do
        if p.surface.name == "underground-1" then
            if global.underground.player_telepads.check_proxy_collision(p.bounding_box) then
                p.teleport("nauvis", p.position)
            end
        elseif p.surface.name == "nauvis" then
            if global.nauvis.player_telepads.check_proxy_collision(p.bounding_box) then
                p.teleport("nauvis", p.position)
            end
        end
    end
end

function CheckBelts()
    for _,b in pairs(global.belt_telepads) do
        local line1 = b.entity.get_transport_line(1)
        local line2 = b.entity.get_transport_line(2)
        
    end 
end
