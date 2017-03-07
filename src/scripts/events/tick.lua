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
        local in1 = b.input.get_transport_line(1)
        local in2 = b.input.get_transport_line(2)
        local out1 = b.output.get_transport_line(1)
        local out2 = b.output.get_transport_line(2)
        
        for n, c in pairs(in1.get_contents()) do
            while c > 0 and out1.can_insert_at_back() do
                if  then
                    out1.insert_at_back({name=n})
                    c = c -1
                end
            end
        end
        for n, c in pairs(in2.get_contents()) do
            while c > 0 and out2.can_insert_at_back() do
                if  then
                    out2.insert_at_back({name=n})
                    c = c -1
                end
            end
        end
    end 
end
