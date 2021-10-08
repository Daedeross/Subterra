local dirt_pollution_absorption = 0.0000066

data:extend(
{
  {
    type="tile",
    name = "sub-dirt",
    collision_mask = {"ground-tile"},
    autoplace = nil,
    layer = 23,
    pollution_absorption_per_second = dirt_pollution_absorption,
    variants =
    {
      main =
      {
        {
          picture = "__subterra__/graphics/terrain/sub-dirt/sub-dirt1.png",
          count = 16,
          size = 1,
          weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 }
        },
        {
          picture = "__subterra__/graphics/terrain/sub-dirt/sub-dirt2.png",
          count = 16,
          size = 2,
          probability = 0.94,
          weights = {0.070, 0.070, 0.025, 0.070, 0.070, 0.070, 0.007, 0.025, 0.070, 0.050, 0.015, 0.026, 0.030, 0.005, 0.070, 0.027 }
        },
        {
          picture = "__subterra__/graphics/terrain/sub-dirt/sub-dirt4.png",
          count = 16,
          line_length = 11,
          size = 4,
          probability = 1,
          weights = {0.070, 0.070, 0.070, 0.070, 0.070, 0.070, 0.015, 0.070, 0.070, 0.070, 0.015, 0.050, 0.070, 0.070, 0.065, 0.070 }
        }
      },
      inner_corner =
      {
        picture = "__subterra__/graphics/terrain/sub-dirt/sub-dirt-inner-corner.png",
        count = 8
      },
      outer_corner =
      {
        picture = "__subterra__/graphics/terrain/sub-dirt/sub-dirt-outer-corner.png",
        count = 8
      },
      side =
      {
        picture = "__subterra__/graphics/terrain/sub-dirt/sub-dirt-side.png",
        count = 8
      }
    },
    walking_sound =
    {
      {
        filename = "__base__/sound/walking/dirt-02.ogg",
        volume = 0.8
      },
      {
        filename = "__base__/sound/walking/dirt-03.ogg",
        volume = 0.8
      },
      {
        filename = "__base__/sound/walking/dirt-04.ogg",
        volume = 0.8
      }
    },
    map_color={r=50, g=50, b=50},
    ageing=0.00045,
    vehicle_friction_modifier = dirt_vehicle_speed_modifier
  }
  -- {
  --     type = "tile",
  --     name = "subterra-telecrete-left",
  --     needs_correction = false,
  --     next_direction = "subterra-telecrete-right",
  --     minable = {hardness = 0.2, mining_time = 0.5, result = "subterra-telecrete-concrete"},
  --     mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
  --     collision_mask = {"ground-tile"},
  --     walking_speed_modifier = 1.4,
  --     layer = 61,
  --     decorative_removal_probability = 0.9,
  --     variants =
  --     {
  --       main =
  --       {
  --         {
  --           picture = "__base__/graphics/terrain/hazard-concrete-left/hazard-concrete-left1.png",
  --           count = 16,
  --           size = 1
  --         },
  --         {
  --           picture = "__base__/graphics/terrain/hazard-concrete-left/hazard-concrete-left2.png",
  --           count = 4,
  --           size = 2,
  --           probability = 0.39,
  --         },
  --         {
  --           picture = "__base__/graphics/terrain/hazard-concrete-left/hazard-concrete-left4.png",
  --           count = 4,
  --           size = 4,
  --           probability = 1,
  --         },
  --       },
  --       inner_corner =
  --       {
  --         picture = "__base__/graphics/terrain/hazard-concrete-left/hazard-concrete-left-inner-corner.png",
  --         count = 8
  --       },
  --       outer_corner =
  --       {
  --         picture = "__base__/graphics/terrain/hazard-concrete-left/hazard-concrete-left-outer-corner.png",
  --         count = 8
  --       },
  --       side =
  --       {
  --         picture = "__base__/graphics/terrain/hazard-concrete-left/hazard-concrete-left-side.png",
  --         count = 8
  --       },
  --       u_transition =
  --       {
  --         picture = "__base__/graphics/terrain/hazard-concrete-left/hazard-concrete-left-u.png",
  --         count = 8
  --       },
  --       o_transition =
  --       {
  --         picture = "__base__/graphics/terrain/hazard-concrete-left/hazard-concrete-left-o.png",
  --         count = 1
  --       }
  --     },
  --     walking_sound =
  --     {
  --       {
  --         filename = "__base__/sound/walking/concrete-01.ogg",
  --         volume = 1.2
  --       },
  --       {
  --         filename = "__base__/sound/walking/concrete-02.ogg",
  --         volume = 1.2
  --       },
  --       {
  --         filename = "__base__/sound/walking/concrete-03.ogg",
  --         volume = 1.2
  --       },
  --       {
  --         filename = "__base__/sound/walking/concrete-04.ogg",
  --         volume = 1.2
  --       }
  --     },
  --     map_color={r=0.5, g=0.5, b=0},
  --     ageing=0,
  --     vehicle_friction_modifier = concrete_vehicle_speed_modifier
  --   },
  --   {
  --     type = "tile",
  --     name = "subterra-telecrete-right",
  --     needs_correction = false,
  --     next_direction = "subterra-telecrete-left",
  --     minable = {hardness = 0.2, mining_time = 0.5, result = "subterra-telecrete-concrete"},
  --     mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
  --     collision_mask = {"ground-tile"},
  --     walking_speed_modifier = 1.4,
  --     layer = 61,
  --     decorative_removal_probability = 0.9,
  --     variants =
  --     {
  --       main =
  --       {
  --         {
  --           picture = "__base__/graphics/terrain/hazard-concrete-right/hazard-concrete-right1.png",
  --           count = 16,
  --           size = 1
  --         },
  --         {
  --           picture = "__base__/graphics/terrain/hazard-concrete-right/hazard-concrete-right2.png",
  --           count = 4,
  --           size = 2,
  --           probability = 0.39,
  --         },
  --         {
  --           picture = "__base__/graphics/terrain/hazard-concrete-right/hazard-concrete-right4.png",
  --           count = 4,
  --           size = 4,
  --           probability = 1,
  --         },
  --       },
  --       inner_corner =
  --       {
  --         picture = "__base__/graphics/terrain/hazard-concrete-right/hazard-concrete-right-inner-corner.png",
  --         count = 8
  --       },
  --       outer_corner =
  --       {
  --         picture = "__base__/graphics/terrain/hazard-concrete-right/hazard-concrete-right-outer-corner.png",
  --         count = 8
  --       },
  --       side =
  --       {
  --         picture = "__base__/graphics/terrain/hazard-concrete-right/hazard-concrete-right-side.png",
  --         count = 8
  --       },
  --       u_transition =
  --       {
  --         picture = "__base__/graphics/terrain/hazard-concrete-right/hazard-concrete-right-u.png",
  --         count = 8
  --       },
  --       o_transition =
  --       {
  --         picture = "__base__/graphics/terrain/hazard-concrete-right/hazard-concrete-right-o.png",
  --         count = 1
  --       }
  --     },
  --     walking_sound =
  --     {
  --       {
  --         filename = "__base__/sound/walking/concrete-01.ogg",
  --         volume = 1.2
  --       },
  --       {
  --         filename = "__base__/sound/walking/concrete-02.ogg",
  --         volume = 1.2
  --       },
  --       {
  --         filename = "__base__/sound/walking/concrete-03.ogg",
  --         volume = 1.2
  --       },
  --       {
  --         filename = "__base__/sound/walking/concrete-04.ogg",
  --         volume = 1.2
  --       }
  --     },
  --     map_color={r=0.5, g=0.5, b=0},
  --     ageing=0,
  --     vehicle_friction_modifier = concrete_vehicle_speed_modifier
  --   }
})
    