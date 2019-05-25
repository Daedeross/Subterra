require("__subterra__.scripts.utils")

local add_hidden_radar = function(force, name, surface, position)
    return surface.create_entity({
        name = name,
        position = position,
        force = force
    })
end 

return add_hidden_radar