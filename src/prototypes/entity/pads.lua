data:extend({
{
    type = "lamp",
    name = "subterra-telepad-up",
    icon = "__subterra__/graphics/entities/telepad/telepad-up-icon.png",
    icon_size = 32,
    flags = {"placeable-neutral", "player-creation"},
    minable = {hardness = 0.1, mining_time = 0.1, result = "subterra-telepad-up"},
    max_health = 55,
    corpse = "big-remnants",
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    collision_mask = {"water-tile"},
    energy_source =
    {
        type = "electric",
        usage_priority = "secondary-input",
        render_no_power_icon = false,
        render_no_network_icon = false
    },
    energy_usage_per_tick = "5KW",
    light = 
    {
        intensity = 0.9,
        size = 15
    },
    picture_off =
    {
        filename = "__subterra__/graphics/entities/telepad/stairs-up.png",
        priority = "high",
        width = 219,
        height = 215,
        shift = {0, -0.5},
        scale = 0.75
    },
    picture_on =
    {
        filename = "__subterra__/graphics/entities/telepad/stairs-up.png",
        priority = "high",
        width = 219,
        height = 215,
        shift = {0, -0.5},
        scale = 0.75
    }
},
{
    type = "lamp",
    name = "subterra-telepad-down",
    icon = "__subterra__/graphics/entities/telepad/telepad-down-icon.png",
    icon_size = 32,
    flags = {"placeable-neutral", "player-creation"},
    minable = {hardness = 0.1, mining_time = 0.1, result = "subterra-telepad-down"},
    max_health = 55,
    corpse = "big-remnants",
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    collision_mask = {"water-tile"},
    energy_source =
    {
        type = "electric",
        usage_priority = "secondary-input",
        render_no_power_icon = false,
        render_no_network_icon = false
    },
    energy_usage_per_tick = "5KW",
    light = 
    {
        intensity = 0.9,
        size = 15
    },
    picture_off =
    {
        filename = "__subterra__/graphics/entities/telepad/stairs-down.png",
        priority = "high",
        width = 219,
        height = 215,
        shift = {0, 0.25},
        scale = 0.75
    },
    picture_on =
    {
        filename = "__subterra__/graphics/entities/telepad/stairs-down.png",
        priority = "high",
        width = 219,
        height = 215,
        shift = {0, 0.25},
        scale = 0.75
    }
}
})