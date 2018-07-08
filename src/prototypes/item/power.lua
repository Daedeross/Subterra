data:extend({
    {
        type = "item",
        name = "subterra-power-up",
        icon = "__subterra__/graphics/icons/power-up-icon-32.png",
        icon_size = 32,
        flags = {"goes-to-quickbar"},
        subgroup = "energy-pipe-distribution",
        order = "s[subterra-power-up]-s[subterra-power-up]",
        place_result = "subterra-power-up",
        stack_size = 50
    },
    {
        type = "item",
        name = "subterra-power-down",
        icon = "__subterra__/graphics/icons/power-down-icon-32.png",
        icon_size = 32,
        flags = {"goes-to-quickbar"},
        subgroup = "energy-pipe-distribution",
        order = "s[subterra-power-down]-s[subterra-power-down]",
        place_result = "subterra-power-down",
        stack_size = 50
    }
})