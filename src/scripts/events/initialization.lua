--============================================================================--
-- initialization.lua
--============================================================================--

require 'util'
require ('config')
require 'scripts/utils'

--============================================================================--
-- initialize_subterra()
--
-- initiate mod and generate underground surface
-- wired in control.lua:game.on_init
--============================================================================--
function initialize_subterra ()
    debug("Starting SubTerra Initialization")

    local max_depth = settings.startup["subterra-max-depth"].value
    global.max_depth = max_depth

    local top_surface = game.surfaces['nauvis']

    local gen_settings = get_underground_settings(top_surface)

    -- create surface(s) with no resources
    -- for i = 1, max_depth do
    --     local layer_name = "underground_" .. tostring(i)
    --     if game.surfaces[layer_name] == nil then
    --         game.create_surface(layer_name, gen_settings)
    --         game.surfaces[layer_name].daytime = 0.5
    --         game.surfaces[layer_name].freeze_daytime = true
    --     end
    --     if remote.interfaces["RSO"] then
    --         remote.call("RSO", "ignoreSurface", layer_name)
    --     end
    -- end
    
    -- create player proxies
    global.player_proxies = {}
    debug("Player Count: " .. tostring(# game.players))
    for i, p in pairs(game.players) do
       debug("Creating proxy for player:" .. p.name)
       add_player_proxy(i)
    end

    -- initialize layers container
    global.layers = {}
    local ground = 
    {
        index = 1,
        layer_above = nil,
        surface = top_surface,
        telepads = Quadtree:new(),
        pad_ghosts = Quadtree:new(),
        belt_ghosts = Quadtree:new(),
        power_ghosts = Quadtree:new()
    }
    ground.telepads:rebuild_index()
    ground.pad_ghosts:rebuild_index()
    ground.belt_ghosts:rebuild_index()
    ground.power_ghosts:rebuild_index()
    
    table.insert(global.layers, ground)

    global.layers["nauvis"] = global.layers[1]

    for i = 1, global.max_depth do
        local l_name, layer = create_layer(i, gen_settings)

        table.insert(global.layers, layer)
        global.layers[l_name] = layer
    end

    local middle, radius = get_generated_extents(top_surface)

    -- debug("World Rect: {" .. middle[1] .. ", " .. middle[2] .. "} radius = " .. radius .. "\n")
    -- debug("X: " .. minx .. ", " .. maxx)
    -- debug("Y: " .. miny .. ", " .. maxy)
    -- debug("")

    -- set adjacency and kickstart chunk generation
    global.layers[1].layer_below = global.layers[2]
    for i = 2, max_depth + 1 do
        local layer = global.layers[i]
        --layer.surface.request_to_generate_chunks({0,0}, 10)
        layer.surface.request_to_generate_chunks(middle, radius)
        layer.layer_above = global.layers[i-1]
        if i <= max_depth then
            layer.layer_below = global.layers[i+1]
        else
            layer.layer_below = nil
        end
    end

    -- initialize proxy containers
    if not global.belt_inputs then global.belt_inputs = {} end
    if not global.belt_outputs then global.belt_outputs = {} end

    if not global.power_inputs then global.power_inputs = {} end
    if not global.power_outputs then global.power_outputs = {} end

    if not global.current_depth then global.current_depth = {} end
    for index, force in pairs(game.forces) do
        global.current_depth[force.name] = 0
    end

    -- set underground enitity list
    initialize_belt_elevators()
    initialize_underground_whitelist()

    debug("SubTerra Initialization Complete")
end

function initialize_underground_whitelist()
    if not global.underground_whitelist then global.underground_whitelist = {} end
    local whitelist = global.underground_whitelist
    -- required entities
    for name,_ in pairs(subterra.config.underground_entities) do
        whitelist[name] = true
    end

    -- add entities from settings
    local whitelist_string = settings.startup["subterra-whitelist"].value or ""
    local new_list = split(whitelist_string, ";")
    global.whitelist_string = whitelist_string

    for _, name in pairs(new_list) do
        log("whitelist: " .. name)
        whitelist[name] = true
    end
end

function initialize_belt_elevators()
    local belt_elevators = {}
    for name, prototype in pairs(game.entity_prototypes) do
        if string.find(prototype.name, "subterra%-%a*%-*transport%-belt") then
            belt_elevators[name] = true
        end
    end
    global.belt_elevators = belt_elevators
end

function on_load()
    for i, layer in pairs(global.layers) do
        local pads = layer.telepads
        if pads and not getmetatable(pads) then
            setmetatable(pads, Quadtree)
            pads:rebuild_metatables()
        end

        local pad_ghosts = layer.pad_ghosts
        if pad_ghosts and not getmetatable(pad_ghosts) then
            setmetatable(pad_ghosts, Quadtree)
	        pad_ghosts:rebuild_metatables()
        end

        local belt_ghosts = layer.belt_ghosts
        if belt_ghosts and not getmetatable(belt_ghosts) then
            setmetatable(belt_ghosts, Quadtree)
	        belt_ghosts:rebuild_metatables()
        end

        local power_ghosts = layer.power_ghosts
        if power_ghosts and not getmetatable(power_ghosts) then
            setmetatable(power_ghosts, Quadtree)
	        power_ghosts:rebuild_metatables()
        end
    end
end