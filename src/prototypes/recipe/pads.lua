data:extend({
  {
    type = "recipe",
    name = "subterra-telepad-down",
    energy_required = 5,
    ingredients =
    {
      {"iron-gear-wheel", 20},
      {"electronic-circuit", 10}
    },
    results = {{"subterra-telepad-down", 1}},
    requester_paste_multiplier = 4
  },
  {
    type = "recipe",
    name = "subterra-telepad-up",
    energy_required = 5,
    ingredients =
    {
      {"iron-gear-wheel", 20},
      {"electronic-circuit", 10}
    },
    results = {{"subterra-telepad-up", 1}},
    requester_paste_multiplier = 4
  },
  {
    type = "recipe",
    name = "subterra-telepad-up-ex",
    ingredients =
    {
      {"subterra-telepad-down", 1}
    },
    results = {{"subterra-telepad-up", 1}},
    requester_paste_multiplier = 4
  },
  {
    type = "recipe",
    name = "subterra-telepad-down-ex",
    ingredients =
    {
      {"subterra-telepad-up", 1}
    },
    results = {{"subterra-telepad-down", 1}},
    requester_paste_multiplier = 4
  },
});