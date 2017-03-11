 data:extend({
    {   
        type = "item",
        name = "subterra-telepad-up",
        icon = "__subterra__/graphics/entities/telepad/telepad-up-icon.png",
        flags = {"goes-to-quickbar"},
        subgroup = "transport",
        order = "a[telepad]",
        place_result = "subterra-telepad-up",
        stack_size = 50
    },
    {   
        type = "item",
        name = "subterra-telepad-down",
        icon = "__subterra__/graphics/entities/telepad/telepad-down-icon.png",
        flags = {"goes-to-quickbar"},
        subgroup = "transport",
        order = "a[telepad]",
        place_result = "subterra-telepad-down",
        stack_size = 50
    },
    {
        type = "rail-planner",
        name = "subterra-rail",
        icon = "__base__/graphics/icons/rail.png",
        flags = {"goes-to-quickbar"},
        subgroup = "transport",
        order = "a[train-system]-a[rail]",
        place_result = "subterra-straight-rail",
        stack_size = 100,
        straight_rail = "subterra-straight-rail",
        curved_rail = "subterra-curved-rail"
    },
})