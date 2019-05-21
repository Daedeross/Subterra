require("__subterra__.scripts.utils")

local max_depth = settings.startup["subterra-max-depth"].value

local remove_hidden_radars = function(force, name, position)
    debug("remove_hidden_radars")
    local layers = global.layers
    -- all layers except top
    for i=2, max_depth do
        local layer = layers[i]
        local surface = layer.surface

        local entity = surface.find_entity(name, position)

        if entity and entity.valid then
            entity.destroy()
        end
    end
end 

return remove_hidden_radars