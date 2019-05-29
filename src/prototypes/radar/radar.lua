require ("util")

local Radar = {}
local MAX_RADARS = 100
local _blank = S_ROOT .. "/graphics/blank.png"
local radar_chunk = settings.startup["subterra-radar-update-chunk-size"].value or 60

local blank_picture = {
    filename = _blank,
    priority = "low",
    width = 1,
    height = 1,
    frame_count = 1,
    direction_count = 1
}

local blank_pictures = {
    layers = {
        blank_picture
    }
}

local math_max = math.max

local function make_radar(existing_radar)
    local new_name = "subterra-hidden-" .. existing_radar.name
    local range = math_max(existing_radar.max_distance_of_nearby_sector_revealed * 32, 1)

    if data.raw.radar[new_name] then
        return
    end

    local new_radar = table.deepcopy(existing_radar)

    new_radar.name = new_name
    new_radar.collision_mask = {}
    new_radar.enable_gui = false
    new_radar.allow_copy_paste = false
    new_radar.pictures = blank_pictures
    new_radar.flags = { "not-on-map", "not-deconstructable", "not-repairable" }
    new_radar.selectable_in_game = false
    new_radar.working_sound = nil
    new_radar.energy_usage = "60W"
    new_radar.max_health = range    -- haaaaak to get the range runtime

    new_radar.energy_source = {
        type = "void"
    }

    data:extend({new_radar})
end

Radar.make_radars = function()
    local radars = data.raw.radar
    if not radars then
        log("No radars found.")
        return
    end

    -- create new table to iterate over
    local existing_radars = {}
    for _, prototype in pairs(radars) do
        table.insert(existing_radars, prototype)
    end

    for _, prototype in pairs(existing_radars) do 
        make_radar(prototype)
    end
end

return Radar