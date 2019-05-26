local subterra_surfaces

local get_all_subterra_surfaces = function()
    if not subterra_surfaces then
        local max_level = settings.startup["subterra-max-depth"].value + 1
        local layers = global.layers
        subterra_surfaces = {}
        for i = 1, max_level do
            subterra_surfaces[i] = { layers[i].surface, i }
        end
    end
    return subterra_surfaces
end

return get_all_subterra_surfaces