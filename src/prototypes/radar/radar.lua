require ("util")

local Radar = {}
local MAX_RADARS = 100
local _blank = S_ROOT .. "/graphics/blank.png"
local radar_chunk = settings.startup["subterra-radar-update-chunk"].value or 1
local RADAR_POWER = 60  -- 60 Watts, i.e. 1 Joule per tick
local BUFFER_DURATION = 10  -- how long the buffer should last if unpowered and updated every tick
local BUFFER_SIZE = radar_chunk * BUFFER_DURATION * RADAR_POWER

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

-- using burner as energy source
-- this is just to prevent electric poles from connecting to the hudden radars
-- create dummy fuel-category and fuel-item
-- data:extend({
--     {
--         type = "fuel-category",
--         name = "subterra-hidden-radar-fuel"
--     },
--     -- {
--     --     type = "item",
--     --     name = "subterra-hidden-radar-fuel",
--     --     icon = _blank,
--     --     icon_size = 32,
--     --     flags = { },
--     --     fuel_category = "subterra-hidden-radar-fuel",
--     --     fuel_value = BUFFER_SIZE .. "J",
--     --     --subgroup = "subterra-hidden-radar-fuel",
--     --     order = "z[z]",
--     --     stack_size = 1
--     -- }
-- })


local function make_radar(existing_radar)
    local new_name = "subterra-hidden-" .. existing_radar.name
    local range = existing_radar.max_distance_of_nearby_sector_revealed * 32

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