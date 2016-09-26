data:extend(
{
  {
    type="tile",
    name = "sub-dirt",
    collision_mask = {"ground-tile"},
    autoplace = nil,
    layer = 23,
    
    variants =
    {
      main =
      {
        {
          picture = "__subterra__/graphics/terrain/sub-dirt/sub-dirt1.png",
          count = 22,
          size = 1,
          weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045, 0.005, 0.005, 0.005, 0.005, 0.003, 0.005 }
        },
        {
          picture = "__subterra__/graphics/terrain/sub-dirt/sub-dirt2.png",
          count = 30,
          size = 2,
          probability = 0.94,
          weights = {0.070, 0.070, 0.025, 0.070, 0.070, 0.070, 0.007, 0.025, 0.070, 0.050, 0.015, 0.026, 0.030, 0.005, 0.070, 0.027, 0.022, 0.032, 0.020, 0.020, 0.030, 0.005, 0.010, 0.002, 0.013, 0.007, 0.007, 0.010, 0.030, 0.030 }
        },
        {
          picture = "__subterra__/graphics/terrain/sub-dirt/sub-dirt4.png",
          count = 21,
          line_length = 11,
          size = 4,
          probability = 1,
          weights = {0.070, 0.070, 0.070, 0.070, 0.070, 0.070, 0.015, 0.070, 0.070, 0.070, 0.015, 0.050, 0.070, 0.070, 0.065, 0.070, 0.070, 0.050, 0.050, 0.050, 0.050 }
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
  },
  {
    type = "tile",
    name = "subterra_telecrete",
    needs_correction = false,
    minable = {hardness = 0.2, mining_time = 0.5, result = "subterra_telecrete"},
    mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
    collision_mask = {"ground-tile"},
    walking_speed_modifier = 0.9,
    layer = 63,
    decorative_removal_probability = 0.9,
    variants =
    {
      main =
      {
        {
          picture = "__base__/graphics/terrain/concrete/concrete1.png",
          count = 16,
          size = 1
        },
        {
          picture = "__base__/graphics/terrain/concrete/concrete2.png",
          count = 4,
          size = 2,
          probability = 0.39,
        },
        {
          picture = "__base__/graphics/terrain/concrete/concrete4.png",
          count = 4,
          size = 4,
          probability = 1,
        },
      },
      inner_corner =
      {
        picture = "__base__/graphics/terrain/concrete/concrete-inner-corner.png",
        count = 8
      },
      outer_corner =
      {
        picture = "__base__/graphics/terrain/concrete/concrete-outer-corner.png",
        count = 8
      },
      side =
      {
        picture = "__base__/graphics/terrain/concrete/concrete-side.png",
        count = 8
      },
      u_transition =
      {
        picture = "__base__/graphics/terrain/concrete/concrete-u.png",
        count = 8
      },
      o_transition =
      {
        picture = "__base__/graphics/terrain/concrete/concrete-o.png",
        count = 1
      }
    },
    walking_sound =
    {
      {
        filename = "__base__/sound/walking/concrete-01.ogg",
        volume = 1.2
      },
      {
        filename = "__base__/sound/walking/concrete-02.ogg",
        volume = 1.2
      },
      {
        filename = "__base__/sound/walking/concrete-03.ogg",
        volume = 1.2
      },
      {
        filename = "__base__/sound/walking/concrete-04.ogg",
        volume = 1.2
      }
    },
    map_color={r=100, g=100, b=100},
    ageing=0,
    vehicle_friction_modifier = dirt_vehicle_speed_modifier
  },
})
    