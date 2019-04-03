local max_depth = settings.startup["subtrerra-max-depth"].value

function make_underground_tech_levels(max)
data:extend(
{
    {
        type = "technology",
        name = "underground-building-1",
        icon_size = 128,
        icon = "__subterra__/graphics/icons/stairs-down-128.png",
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "subterra-telepad-up"
            },
            {
                type = "unlock-recipe",
                recipe = "subterra-telepad-up-ex"
            },
            {
                type = "unlock-recipe",
                recipe = "subterra-telepad-down"
            },
            {
                type = "unlock-recipe",
                recipe = "subterra-telepad-down-ex"
            },
            {
                type = "unlock-recipe",
                recipe = "subterra-transport-belt-up"
            },
            {
                type = "unlock-recipe",
                recipe = "subterra-transport-belt-up-ex"
            },
            {
                type = "unlock-recipe",
                recipe = "subterra-transport-belt-down"
            },
            {
                type = "unlock-recipe",
                recipe = "subterra-transport-belt-down-ex"
            },
            {
                type = "unlock-recipe",
                recipe = "subterra-power-up"
            },
            {
                type = "unlock-recipe",
                recipe = "subterra-power-up-ex"
            },
            {
                type = "unlock-recipe",
                recipe = "subterra-power-down"
            },
            {
                type = "unlock-recipe",
                recipe = "subterra-power-down-ex"
            }
        },
        prerequisites = {"logistics"},
        unit =
        {
            count = 100,
            ingredients =
            {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 2}
            },
            time = 30
        },
        upgrade = true,
        level = 1,
        order = "s-t-e"
    },
    {
        type = "technology",
        name = "underground-building-2",
        enabled = max >= 2,
        icon_size = 128,
        icon = "__subterra__/graphics/icons/stairs-down-128.png",
        effects =
        {
            
        },
        prerequisites = {"underground-building-1"},
        unit =
        {
            count = 200,
            ingredients =
            {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 2},
                {"chemical-science-pack", 1}
            },
            time = 30
        },
        effects =
        {
        },
        upgrade = true,
        level = 2,
        order = "a-t-e"
    },
    {
        type = "technology",
        name = "underground-building-3",
        enabled = max >= 3,
        icon_size = 128,
        icon = "__subterra__/graphics/icons/stairs-down-128.png",
        prerequisites = {"underground-building-2"},
        unit =
        {
            count = 400,
            ingredients =
            {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 2},
                {"chemical-science-pack", 1},
                {"utility-science-pack", 1}
            },
            time = 30
        },
        effects =
        {
        },
        upgrade = true,
        level = 3,
        order = "s-t-e"
    },
    {
        type = "technology",
        name = "underground-building-4",
        enabled = max >= 4,
        icon_size = 128,
        icon = "__subterra__/graphics/icons/stairs-down-128.png",
        effects =
        {
        },
        prerequisites = {"underground-building-3"},
        unit =
        {
            count = 600,
            ingredients =
            {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
                {"production-science-pack", 1},
                {"utility-science-pack", 1}
            },
            time = 30
        },
        upgrade = true,
        level = 4,
        order = "s-t-e"
    },

    {
        type = "technology",
        name = "subway-1",
        enabled = max >= 1,
        icon_size = 128,
        icon = "__base__/graphics/technology/railway.png",
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "subterra-recharger"
            },
            {
                type = "unlock-recipe",
                recipe = "subterra-locomotive-1"
            },
            {
                type = "unlock-recipe",
                recipe = "subterra-battery-empty-1"
            },
            {
                type = "unlock-recipe",
                recipe = "subterra-battery-full-1"
            }
        },
        prerequisites = {"underground-building-1", "railway"},
        unit =
        {
            count = 50,
            ingredients =
            {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1}
            },
            time = 30
        },
        upgrade = true,
        level = 1,
        order = "s-t-e"
    },
    {
        type = "technology",
        name = "subway-2",
        enabled = max >= 2,
        icon_size = 128,
        icon = "__base__/graphics/technology/railway.png",
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "subterra-locomotive-2"
            },
            {
                type = "unlock-recipe",
                recipe = "subterra-battery-empty-2"
            },
            {
                type = "unlock-recipe",
                recipe = "subterra-battery-full-2"
            }
        },
        prerequisites = {"subway-1", "underground-building-2"},
        unit =
        {
            count = 100,
            ingredients =
            {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1}
            },
            time = 30
        },
        upgrade = true,
        level = 2,
        order = "s-t-e"
    },
    {
        type = "technology",
        name = "subway-3",
        enabled = max >= 3,
        icon_size = 128,
        icon = "__base__/graphics/technology/railway.png",
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "subterra-locomotive-3"
            },
            {
                type = "unlock-recipe",
                recipe = "subterra-battery-empty-3"
            },
            {
                type = "unlock-recipe",
                recipe = "subterra-battery-full-3"
            }
        },
        prerequisites = {"subway-2", "underground-building-3"},
        unit =
        {
            count = 150,
            ingredients =
            {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1}
            },
            time = 30
        },
        upgrade = true,
        level = 3,
        order = "s-t-e"
    },
    {
        type = "technology",
        name = "subway-4",
        enabled = max >= 4,
        icon_size = 128,
        icon = "__base__/graphics/technology/railway.png",
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "subterra-locomotive-4"
            },
            {
                type = "unlock-recipe",
                recipe = "subterra-battery-empty-4"
            },
            {
                type = "unlock-recipe",
                recipe = "subterra-battery-full-4"
            }
        },
        prerequisites = {"subway-3", "underground-building-4"},
        unit =
        {
            count = 200,
            ingredients =
            {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
                {"utility-science-pack", 1}
            },
            time = 30
        },
        upgrade = true,
        level = 4,
        order = "s-t-e"
    }
    ,
    -- {
    --     type = "technology",
    --     name = "subway-5",
    --     icon_size = 128,
    --     icon = "__base__/graphics/technology/railway.png",
    --     effects =
    --     {
    --         {
    --             type = "unlock-recipe",
    --             recipe = "subterra-locomotive-5"
    --         },
    --         {
    --             type = "unlock-recipe",
    --             recipe = "subterra-battery-empty-4"
    --         },
    --         {
    --             type = "unlock-recipe",
    --             recipe = "subterra-battery-full-4"
    --         }
    --     },
    --     prerequisites = {"subway-4", "underground-building-5"},
    --     unit =
    --     {
    --         count = 300,
    --         ingredients =
    --         {
    --             {"automation-science-pack", 1},
    --             {"logistic-science-pack", 1},
    --             {"chemical-science-pack", 1},
    --             {"utility-science-pack", 1}
    --         },
    --         time = 30
    --     },
    --     upgrade = true,
    --     level = 5,
    --     order = "s-t-e"
    -- },
})
end

make_underground_tech_levels(max_depth)