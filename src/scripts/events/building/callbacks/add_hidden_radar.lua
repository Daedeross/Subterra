require("__subterra__.scripts.utils")

local max_depth = settings.startup["subterra-max-depth"].value

local add_hidden_radar = function(force, name, surface, position)
    surface.create_entity({
        name = name,
        position = position,
        force = force
    })
end 

return add_hidden_radar