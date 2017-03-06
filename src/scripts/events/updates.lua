function OnTick(event)
    if event.tick % 30 == 0 then
        CheckPlayerPadCollision()
    end
end

function CheckPlayerPadCollision()
    for i, p in pairs(game.players) do
       local sname = p.surface.name
       local qt = global.telepads[sname]

       local pad = qt:check_proxy_collision(p.character.bounding_box)
       if pad ~= nil then
            if sname == "nauvis" then
                p.teleport(p.position, "underground_1")
            else
                p.teleport(p.position, "nauvis")
            end
        end
    end
end