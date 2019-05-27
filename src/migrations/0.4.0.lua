for index, force in pairs(game.forces) do
    local technologies = force.technologies
    local recipes = force.recipes
  
    recipes["subterra-transport-belt-down"].enabled = technologies["underground-building-1"] and technologies["underground-building-1"].researched
    recipes["subterra-transport-belt-up"].enabled = technologies["underground-building-1"] and technologies["underground-building-1"].researched
    recipes["subterra-fast-transport-belt-down"].enabled = technologies["logistics-2"] and technologies["logistics-2"].researched
    recipes["subterra-fast-transport-belt-up"].enabled = technologies["logistics-2"] and technologies["logistics-2"].researched
    recipes["subterra-express-transport-belt-down"].enabled = technologies["logistics-3"] and technologies["logistics-3"].researched
    recipes["subterra-express-transport-belt-up"].enabled = technologies["logistics-3"] and technologies["logistics-3"].researched
    recipes["subterra-transport-belt-down-ex"].enabled = technologies["underground-building-1"] and technologies["underground-building-1"].researched
    recipes["subterra-transport-belt-up-ex"].enabled = technologies["underground-building-1"] and technologies["underground-building-1"].researched
    recipes["subterra-fast-transport-belt-down-ex"].enabled = technologies["logistics-2"] and technologies["logistics-2"].researched
    recipes["subterra-fast-transport-belt-up-ex"].enabled = technologies["logistics-2"] and technologies["logistics-2"].researched
    recipes["subterra-express-transport-belt-down-ex"].enabled = technologies["logistics-3"] and technologies["logistics-3"].researched
    recipes["subterra-express-transport-belt-up-ex"].enabled = technologies["logistics-3"] and technologies["logistics-3"].researched
end