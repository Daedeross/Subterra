for index, force in pairs(game.forces) do
    local technologies = force.technologies
    local recipes = force.recipes
  
    recipes["subterra-transport-belt-down"].enabled = technologies["underground-building-1"].researched
    recipes["subterra-transport-belt-up"].enabled = technologies["underground-building-1"].researched
end