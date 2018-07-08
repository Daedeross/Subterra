data:extend({
    {
        type = "item",
        name = "subterra-power-up",
        icon = "__base__/graphics/icons/small-electric-pole.png",
        icon_size = 32,
        flags = {"goes-to-quickbar"},
        subgroup = "transport",
        order = "a[subterra-power-up]-a[subterra-power-up]",
        place_result = "subterra-power-up",
        stack_size = 50
    },
    {
        type = "item",
        name = "subterra-power-down",
        icon = "__base__/graphics/icons/small-electric-pole.png",
        icon_size = 32,
        flags = {"goes-to-quickbar"},
        subgroup = "transport",
        order = "a[subterra-power-down]-a[subterra-power-down]",
        place_result = "subterra-power-down",
        stack_size = 50
    }
})