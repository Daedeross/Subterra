function OnTick(event)
    CheckBelts()
    if event.tick % 30 == 0 then
        CheckPlayerPads()
    end
end

function CheckPlayerPads()
    for i, p in pairs(game.players) do
        local sname = p.surface.name
        local qt = global.layers[sname].telepads
        local proxy = global.player_proxies[i]
        local pad = qt:check_proxy_collision(p.character.bounding_box)
        if pad and not proxy.on_pad then
            proxy.on_pad = true
            p.teleport(p.position, pad.target_layer.surface.name)
        else
            proxy.on_pad = false
        end
    end
end

function teleport_player(player, pad)

end

function CheckBelts()
    for _,b in pairs(global.belt_inputs) do
        local in1 = b.input.get_transport_line(1)
        local in2 = b.input.get_transport_line(2)
        local out1 = b.output.get_transport_line(1)
        local out2 = b.output.get_transport_line(2)
        
        for n, c in pairs(in1.get_contents()) do
            while c > 0 and out1.can_insert_at_back() do
                out1.insert_at_back({name=n})
                in1.remove_item({name=n})
                c = c -1
            end
        end
        for n, c in pairs(in2.get_contents()) do
            while c > 0 and out2.can_insert_at_back() do
                out2.insert_at_back({name=n})
                in2.remove_item({name=n})
                c = c -1
            end
        end
    end 
end