data:extend({
    {
      type = "recipe",
      name = "subterra-power-down",
      energy_required = 1,
      ingredients =
      {
        {"big-electric-pole", 2},
        {"copper-plate", 10},
      },
      results = {{"subterra-power-down", 1}},
      requester_paste_multiplier = 4
    },
    {
      type = "recipe",
      name = "subterra-power-up",
      energy_required = 1,
      ingredients =
      {
        {"big-electric-pole", 2},
        {"copper-plate", 10},
      },
      results = {{"subterra-power-up", 1}},
      requester_paste_multiplier = 4
    },
    {
      type = "recipe",
      name = "subterra-power-down-ex",
      allow_as_intermediate = false,
      allow_intermediates = false,
      ingredients =
      {
        {"subterra-power-up", 1}
      },
      results = {{"subterra-power-down", 1}},
      requester_paste_multiplier = 4
    },
    {
      type = "recipe",
      name = "subterra-power-up-ex",
      allow_as_intermediate = false,
      allow_intermediates = false,
      ingredients =
      {
        {"subterra-power-down", 1}
      },
      results = {{"subterra-power-up", 1}},
      requester_paste_multiplier = 4
    }
  })