require 'util'
require ('config')
require 'scripts/utils'
require 'scripts/quadtree'
require 'initialization'

function subterra_version(config, version)
    local mod = config.mod_changes["subterra"]
    if mod then
        return mod.old_version and mod.old_version < version
    end
    return false
end

-- migrate v > 0.2.0
register_configuration_event(
function (config)
    return subterra_version(config, "0.3.0")
end,
function (config)
    print("Migrating global table to 0.3.0")
    if not global.power_inputs then global.power_inputs = {} end
    if not global.power_outputs then global.power_outputs = {} end
end)

-- migrate v -> 0.3.3
register_configuration_event(
function (config)
    return subterra_version(config, "0.3.3")
end,
function(config)
    print("Migrate Sebterra to v0.3.3: Adding underground white-list")
    initialize_underground_whitelist()
end)

register_configuration_event(
function (config)
    return subterra_version(config, "0.4.0")
end,
function (config)
    print("Migrate Sebterra to v0.4.0: Adding ghost proxies and qaudtree index")
    for i, layer in pairs(global.layers) do
        if not layer.pad_ghosts then layer.pad_ghosts = Quadtree:new() end
        if not layer.belt_ghosts then layer.belt_ghosts = Quadtree:new() end
        if not layer.power_ghosts then layer.power_ghosts = Quadtree:new() end

        -- fix index and count
        layer.telepads:rebuild_index()
        layer.pad_ghosts:rebuild_index()
        layer.belt_ghosts:rebuild_index()
        layer.power_ghosts:rebuild_index()
    end
end)

-- set all belts
register_configuration_event(
function (config)
    return true
end,
function (config)
    print("do belt elevators")
    global.belt_elevators = {}
    local count = 0
    for name, prototype in pairs(game.entity_prototypes) do
        local s, e = string.find(prototype.name, "subterra%-%a*%-*transport%-belt")
        if s then
            count = count + 1
            global.belt_elevators[prototype.name] = true
        end
    end
    print(count)
end)

-- settings changed
register_configuration_event(
function (config)
    return config.mod_startup_settings_changed
end,
function (config)
    local old_depth = global.max_depth
    if not old_depth then old_depth = 2 end

    local new_depth = settings.startup["subtrerra-max-depth"].value

    if new_depth > old_depth then
        local top_surface = game.surfaces['nauvis']
        local middle, radius = get_generated_extents(top_surface)
        local gen_settings = get_underground_settings(top_surface)

        for depth=old_depth+1, new_depth do
            local l_name, layer = create_layer(depth, gen_settings)

            table.insert(global.layers, layer)
            global.layers[l_name] = layer
        end

        for i = 2, new_depth + 1 do
            --global.layers[i].surface.request_to_generate_chunks({0,0}, 10)
            global.layers[i].surface.request_to_generate_chunks(middle, radius)
            global.layers[i].layer_above = global.layers[i-1]
            if i < new_depth then
                global.layers[i].layer_below = global.layers[i+1]
            else
                global.layers[i].layer_below = nil
           
            end
        end    

    elseif new_depth < old_depth then
        -- for depth=old_depth, new_depth+1, -1 do
        --     local layer = global.layers[depth]
        --     if layer then
        --         game.delete_surface(layer.surface)  -- yikes!
        --     end
        -- end
    end

    global.max_depth = new_depth
    
    if not global.current_depth then global.current_depth = {} end

    -- set current depth based on technology
    for index, force in pairs(game.forces) do
        local technologies = force.technologies

        global.current_depth[force.name] = 0

        for i=new_depth,1,-1 do
            local tech_name = "underground-building-" .. i
            if technologies[tech_name] and technologies[tech_name].researched then
                global.current_depth[force.name] = i
                break
            end
        end
    end
end)