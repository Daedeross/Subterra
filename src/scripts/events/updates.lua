require 'scripts/utils'

if not subterra.tick_events then subterra.tick_events = {} end

-- event fired every half second
-- Teleports players if standin on an elevator
register_nth_tick_event (5,
function (event)
    for i, p in pairs(global.player_proxies) do
        local player = p.player
        if player.connected then
            local sname = player.surface.name
            local layer = global.layers[sname]
            local qt = layer and layer.telepads
            if qt then
                local pad = qt:check_proxy_collision(player.character.bounding_box)
                if pad then
                    if p.on_pad ~= pad.entity.unit_number then
                        player.teleport(player.position, pad.target_layer.surface.name)
                        print("Teleported player:" .. player.name)
                        p.on_pad = pad.target_pad.entity.unit_number
                    end
                else
                    p.on_pad = -1
                end
            else
                p.on_pad = -1
            end
        else
            global.player_proxies[i] = nil
        end
    end
end)

local INSERT_POS = {
	["transport-belt"] = 0.71875, -- 1 - 9/32
	["underground-belt"] = 0.21875, -- 0.5 - 9/32
}

-- belts
register_event(defines.events.on_tick,
function (event)
    for _,b in pairs(global.belt_inputs) do
        if b.input.valid and b.output.valid then
            --local type = b.input.type
            local in1 = b.in_line1
            local in2 = b.in_line2
            local out1 = b.out_line1
            local out2 = b.out_line2
            local c1 = # in1
            local c2 = # in2
            if c1 > 0 then
                local n = in1[1].name
                if out1.insert_at_back({name=n}) then
                    in1.remove_item({name=n})
                end
            end
            if c2 > 0 then
                local n = in2[1].name
                if out2.insert_at_back({name=n}) then
                    in2.remove_item({name=n})
                end
            end
        end
    end 
end)

-- power
-- Source: https://github.com/MagmaMcFry/Factorissimo2
local function transfer_power(from, to)
	if not (from.valid and to.valid) then return end
	local energy = from.energy + to.energy
    local ebs = to.electric_buffer_size
	if energy > ebs then
		to.energy = ebs
		from.energy = energy - ebs
	else
		to.energy = energy
		from.energy = 0
	end
end

register_event(defines.events.on_tick,
function (event)
    for _,p in pairs(global.power_inputs) do
        if p.input.valid and p.output.valid then
            transfer_power(p.input, p.output)
        end
    end 
end)


