data:extend({
    {   
        type = "item",
        name = "subterra-telepad-up",
        icon = "__subterra__/graphics/icons/stairs-up-icon-32.png",
        icon_size = 32,
        flags = {"goes-to-quickbar"},
        subgroup = "subterra-transport",
        order = "s[telepad-2]",
        place_result = "subterra-telepad-up",
        stack_size = 50
    },
    {   
        type = "item",
        name = "subterra-telepad-down",
        icon = "__subterra__/graphics/icons/stairs-down-icon-32.png",
        icon_size = 32,
        flags = {"goes-to-quickbar"},
        subgroup = "subterra-transport",
        order = "s[telepad-1]",
        place_result = "subterra-telepad-down",
        stack_size = 50
    },
    -- {
    --     type = "rail-planner",
    --     name = "subterra-rail",
    --     icon = "__base__/graphics/icons/rail.png",
    --     icon_size = 32,
    --     flags = {"goes-to-quickbar"},
    --     subgroup = "transport",
    --     order = "s[train-system]-s[rail]",
    --     place_result = "subterra-straight-rail",
    --     stack_size = 100,
    --     straight_rail = "subterra-straight-rail",
    --     curved_rail = "subterra-curved-rail"
    -- },
})