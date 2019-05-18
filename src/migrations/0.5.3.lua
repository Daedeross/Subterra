local function update_recipe(recipe, technology)
    if recipe then
        recipe.enabled = technology and technology.researched
    end
end

for index, force in pairs(game.forces) do
    local technologies = force.technologies
    local recipes = force.recipes

    for level = 1, 5 do
        local recipe_name = "subterra-battery-full-" .. level
        local tech_name = "subway-" .. level
        update_recipe(recipes[recipe_name, technologies[tech_name]])
    end
end

