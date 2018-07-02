rail_pictures_internal = function(elems)
  local keys = {
                {"straight_rail", "horizontal", 64, 128, 0, 0, true},
                {"straight_rail", "vertical", 128, 64, 0, 0, true},
                {"straight_rail", "diagonal-left-top", 96, 96, 0.5, 0.5, true},
                {"straight_rail", "diagonal-right-top", 96, 96, -0.5, 0.5, true},
                {"straight_rail", "diagonal-right-bottom", 96, 96, -0.5, -0.5, true},
                {"straight_rail", "diagonal-left-bottom", 96, 96, 0.5, -0.5, true},
                {"curved_rail", "vertical-left-top", 192, 288, 0.5, 0.5},
                {"curved_rail", "vertical-right-top", 192, 288, -0.5, 0.5},
                {"curved_rail", "vertical-right-bottom", 192, 288, -0.5, -0.5},
                {"curved_rail", "vertical-left-bottom", 192, 288, 0.5, -0.5},
                {"curved_rail" ,"horizontal-left-top", 288, 192, 0.5, 0.5},
                {"curved_rail" ,"horizontal-right-top", 288, 192, -0.5, 0.5},
                {"curved_rail" ,"horizontal-right-bottom", 288, 192, -0.5, -0.5},
                {"curved_rail" ,"horizontal-left-bottom", 288, 192, 0.5, -0.5}
              }
  local res = {}
  for _ , key in ipairs(keys) do
    local part = {}
    dashkey = key[1]:gsub("_", "-")
    for _ , elem in ipairs(elems) do
      part[elem[1]] =
      {
        filename = string.format("__base__/graphics/entity/%s/%s-%s-%s.png", dashkey, dashkey, key[2], elem[2]),
        priority = elem.priority or "extra-high",
        flags = elem.mipmap and { "icon" } or { "low-object" },
        width = key[3],
        height = key[4],
        shift = {key[5], key[6]},
        variation_count = (key[7] and elem.variations) or 1,
        hr_version =
        {
          filename = string.format("__base__/graphics/entity/%s/hr-%s-%s-%s.png", dashkey, dashkey, key[2], elem[2]),
          priority = elem.priority or "extra-high",
          flags = elem.mipmap and { "icon" } or { "low-object" },
          width = key[3]*2,
          height = key[4]*2,
          shift = {key[5], key[6]},
          scale = 0.5,
          variation_count = (key[7] and elem.variations) or 1,
        }
      }
    end
    dashkey2 = key[2]:gsub("-", "_")
    res[key[1] .. "_" .. dashkey2] = part
  end
    res["rail_endings"] = {
   sheets =
   {
     {
       filename = "__base__/graphics/entity/rail-endings/rail-endings-background.png",
       priority = "high",
       flags = { "low-object" },
       width = 128,
       height = 128,
       hr_version = {
         filename = "__base__/graphics/entity/rail-endings/hr-rail-endings-background.png",
         priority = "high",
         flags = { "low-object" },
         width = 256,
         height = 256,
         scale = 0.5
       }
     },
     {
       filename = "__base__/graphics/entity/rail-endings/rail-endings-metals.png",
       priority = "high",
       flags = { "icon" },
       width = 128,
       height = 128,
       hr_version = {
         filename = "__base__/graphics/entity/rail-endings/hr-rail-endings-metals.png",
         priority = "high",
         flags = { "icon" },
         width = 256,
         height = 256,
         scale = 0.5
       }
     }
   }
 }
  return res
end

rail_pictures = function()
  return rail_pictures_internal({
                                 {"metals", "metals", mipmap = true},
                                 {"backplates", "backplates", mipmap = true},
                                 {"ties", "ties", variations = 3},
                                 {"stone_path", "stone-path", variations = 3},
                                 {"stone_path_background", "stone-path-background", variations = 3},
                                 {"segment_visualisation_middle", "segment-visualisation-middle"},
                                 {"segment_visualisation_ending_front", "segment-visualisation-ending-1"},
                                 {"segment_visualisation_ending_back", "segment-visualisation-ending-2"},
                                 {"segment_visualisation_continuing_front", "segment-visualisation-continuing-1"},
                                 {"segment_visualisation_continuing_back", "segment-visualisation-continuing-2"}
                                })
end

data:extend(
{
  {
    type = "straight-rail",
    name = "subterra-straight-rail",
    icon = "__base__/graphics/icons/rail.png",
    icon_size = 32,
    flags = {"placeable-neutral", "player-creation", "building-direction-8-way"},
    minable = {mining_time = 0.5, result = "subterra-rail"},
    max_health = 100,
    corpse = "big-remnants",
    resistances =
    {
      {
        type = "fire",
        percent = 100
      }
    },
    collision_box = {{-0.7, -0.8}, {0.7, 0.8}},
    selection_box = {{-0.7, -0.8}, {0.7, 0.8}},
    rail_category = "regular",
    pictures = rail_pictures(),
  },
  {
    type = "curved-rail",
    name = "subterra-curved-rail",
    icon = "__base__/graphics/icons/curved-rail.png",
    icon_size = 32,
    flags = {"placeable-neutral", "player-creation", "building-direction-8-way"},
    minable = {mining_time = 0.5, result = "subterra-rail", count = 4},
    max_health = 200,
    corpse = "big-remnants",
    resistances =
    {
      {
        type = "fire",
        percent = 100
      }
    },
    collision_box = {{-0.75, -0.55}, {0.75, 1.6}},
    secondary_collision_box = {{-0.65, -2.43}, {0.65, 2.43}},
    selection_box = {{-1.7, -0.8}, {1.7, 0.8}},
    rail_category = "regular",
    pictures = rail_pictures(),
    placeable_by = { item="subterra-rail", count = 4}
  },
})