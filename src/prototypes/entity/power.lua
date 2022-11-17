local transfer_rate =  50 -- in MW
local buffer_size = transfer_rate * 16667 -- J/tick (enough to hold 1 tick's worth of energy)
local input_priority = "secondary-input"
local output_priority = "tertiary"
local S_ROOT = "__subterra__"

_blank = S_ROOT .. "/graphics/blank.png"
local function blank_picture()
    return {
        filename = _blank,
        priority = "low",
        width = 1,
        height = 1,
        frame_count = 1,
    }
end

local function blank_pole_picture()
    return {
        filename = S_ROOT .. "/graphics/entity/power/big-electric-pole-blank.png",
        priority = "low",
        width = 168,
        height = 165,
        direction_count = 4,
        shift = {1.6, -1.1}
    }
end

data:extend({
{   -- Visible & interactable "Top" of a power converter
    type = "simple-entity-with-force",
    name = "subterra-power-column",
    icon = "__subterra__/graphics/icons/power-column-icon-32.png",
    icon_size = 32,
    flags = {"placeable-neutral", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "subterra-power-column"},
    max_health = 150,
    corpse = "medium-remnants",
    resistances =
    {
        {
            type = "fire",
            percent = 100
        }
    },
    collision_box = {{-0.65, -0.65}, {0.65, 0.65}},
    selection_box = {{-1, -1}, {1, 1}},
    drawing_box = {{-1, -3}, {1, 0.5}},
    vehicle_impact_sound =    { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    animations =
    {
        {
            filename = "__subterra__/graphics/entity/power/power-interface.png",
            priority = "high",
            width = 400,
            height = 300,
            line_length = 5,
            frame_count = 30,
            shift = {1.75, -1.5},
            scale = 0.50,
            animation_speed = 0.5
        }
    },
    connection_points =
    {
        {
            shadow =
            {
                copper = {2.7, 0},
                green = {1.8, 0},
                red = {3.6, 0}
            },
            wire =
            {
                copper = {0, -3.125},
                green = {-0.59375, -3.125},
                red = {0.625, -3.125}
            }
        },
        {
            shadow =
            {
                copper = {3.1, 0.2},
                green = {2.3, -0.3},
                red = {3.8, 0.6}
            },
            wire =
            {
                copper = {-0.0625, -3.125},
                green = {-0.5, -3.4375},
                red = {0.34375, -2.8125}
            }
        },
        {
            shadow =
            {
                copper = {2.9, 0.06},
                green = {3.0, -0.6},
                red = {3.0, 0.8}
            },
            wire =
            {
                copper = {-0.09375, -3.09375},
                green = {-0.09375, -3.53125},
                red = {-0.09375, -2.65625}
            }
        },
        {
            shadow =
            {
                copper = {3.1, 0.2},
                green = {3.8, -0.3},
                red = {2.35, 0.6}
            },
            wire =
            {
                copper = {-0.0625, -3.1875},
                green = {0.375, -3.5},
                red = {-0.46875, -2.90625}
            }
        }
    }
},
{
    type = "electric-energy-interface",
    name = "subterra-power-in",
    icon = "__subterra__/graphics/icons/power-column-icon-32.png",
    icon_size = 32,
    flags = { "not-on-map", "not-deconstructable", "not-repairable" },
    selectable_in_game = false,
    --minable = false,
    max_health = 150,
    corpse = "medium-remnants",
    collision_box = {{-0.65, -0.65}, {0.65, 0.65}},
    collision_mask = {},
    enable_gui = false,
    allow_copy_paste = false,
    energy_source =
    {
        type = "electric",
        buffer_capacity = buffer_size .. "J",
        usage_priority = input_priority,
        input_flow_limit = transfer_rate .. "MW",
        --output_flow_limit = "0kW",
        render_no_power_icon = false
    },
    energy_production = "0MW",
    energy_usage = "0kW",
    -- also 'pictures' for 4-way sprite is available, or 'animation' resp. 'animations'
    picture = blank_picture(),
    vehicle_impact_sound =    { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
    working_sound =
    {
        sound =
        {
            filename = "__base__/sound/accumulator-working.ogg",
            volume = 1
        },
        idle_sound =
        {
            filename = "__base__/sound/accumulator-idle.ogg",
            volume = 0.4
        },
        max_sounds_per_type = 5
    }
},
{
    type = "electric-energy-interface",
    name = "subterra-power-out",
    icon = "__subterra__/graphics/icons/power-column-icon-32.png",
    icon_size = 32,
    flags = { "not-on-map", "not-deconstructable", "not-repairable" },
    selectable_in_game = false,
    --minable = false,
    max_health = 150,
    corpse = "medium-remnants",
    collision_box = {{-0.65, -0.65}, {0.65, 0.65}},
    collision_mask = {},
    enable_gui = false,
    allow_copy_paste = false,
    energy_source =
    {
        type = "electric",
        buffer_capacity = buffer_size .. "J",
        usage_priority = output_priority,
        --input_flow_limit = "0kW",
        output_flow_limit = transfer_rate .. "MW",
        render_no_power_icon = false
    },
    energy_production = "0MW",
    energy_usage = "0kW",
    -- also 'pictures' for 4-way sprite is available, or 'animation' resp. 'animations'
    picture = blank_picture(),
    vehicle_impact_sound =    { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
    working_sound =
    {
        sound =
        {
            filename = "__base__/sound/accumulator-working.ogg",
            volume = 1
        },
        idle_sound =
        {
            filename = "__base__/sound/accumulator-idle.ogg",
            volume = 0.4
        },
        max_sounds_per_type = 5
    },
},
{
    type = "electric-pole",
    name = "subterra-power-pole",
    icon = "__subterra__/graphics/icons/power-column-icon-32.png",
    icon_size = 32,
    flags = { "not-on-map", "not-deconstructable", "not-repairable" },
    minable = nil,
    selectable_in_game = false,
    max_health = 150,
    corpse = "medium-remnants",
    resistances =
    {
        {
            type = "fire",
            percent = 100
        }
    },
    collision_box = {{-0.65, -0.65}, {0.65, 0.65}},
    collision_mask = {},
    maximum_wire_distance = 30,
    supply_area_distance = 2,
    vehicle_impact_sound =    { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    pictures = blank_pole_picture(),
    connection_points =
    {
        {
            shadow =
            {
                copper = {2.7, 0},
                green = {1.8, 0},
                red = {3.6, 0}
            },
            wire =
            {
                copper = {0, -3.125},
                green = {-0.59375, -3.125},
                red = {0.625, -3.125}
            }
        },
        {
            shadow =
            {
                copper = {3.1, 0.2},
                green = {2.3, -0.3},
                red = {3.8, 0.6}
            },
            wire =
            {
                copper = {-0.0625, -3.125},
                green = {-0.5, -3.4375},
                red = {0.34375, -2.8125}
            }
        },
        {
            shadow =
            {
                copper = {2.9, 0.06},
                green = {3.0, -0.6},
                red = {3.0, 0.8}
            },
            wire =
            {
                copper = {-0.09375, -3.09375},
                green = {-0.09375, -3.53125},
                red = {-0.09375, -2.65625}
            }
        },
        {
            shadow =
            {
                copper = {3.1, 0.2},
                green = {3.8, -0.3},
                red = {2.35, 0.6}
            },
            wire =
            {
                copper = {-0.0625, -3.1875},
                green = {0.375, -3.5},
                red = {-0.46875, -2.90625}
            }
        }
    },
    radius_visualisation_picture =
    {
        filename = "__base__/graphics/entity/small-electric-pole/electric-pole-radius-visualization.png",
        width = 12,
        height = 12,
        priority = "extra-high-no-scale"
    }
},
})