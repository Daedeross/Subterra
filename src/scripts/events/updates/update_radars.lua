local RADAR_POWER = 60  -- 60 Watts, i.e. 1 Joule per tick
local BUFFER_DURATION = 10  -- how long the buffer should last if unpowered and updated every tick

local update_radars = function (event)
    local radar_proxy_array = global.radar_proxy_array
    local count = # radar_proxy_array
    if count < 1 then return end

    local fuel = game.entity_prototypes.item["subterra-hidden-radar-fuel"]

    local radar_chunk = settings.startup["subterra-radar-update-chunk"].value or 1
    local buffer_size = radar_chunk * BUFFER_DURATION * RADAR_POWER

    local start = event.tick % radar_chunk + 1
    for i = start, count, radar_chunk do
        local proxy = radar_proxy_array[i]
        local max_level = proxy.max_level
        if max_level > 1 then
            local radars = proxy.radars
            local is_powered = proxy.top.energy > 0
            for j = 2, max_level do
                local radar = radars[j]
                if radar and radar.valid then
                    local burner = radar.burner
                    if is_powered then
                        if not burner.currently_burning then
                            burner.currently_burning = fuel
                        end
                        burner.remaining_burning_fuel = buffer_size
                    else
                        burner.currently_burning = nil
                    end
                end
            end
        end
    end
end