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
    print("Starting SubTerra Initialization")

    local top_surface = game.surfaces['nauvis']

    -- copy map settings
    local gen_settings = table.deepcopy(top_surface.map_gen_settings)
    -- remove resources from settings
    for _, r in pairs(gen_settings.autoplace_controls) do
        r.frequency = 'very-low'
        r.size = 'none'
        r.richness = 'very-poor'
    end
    gen_settings.peaceful_mode = true
    -- create surface(s) with no resources
    for i = 2, subterra.config.MAX_LAYER_COUNT do
        local layer_name = "underground_" .. tostring(i-1)
        if game.surfaces[layer_name] == nil then
            game.create_surface(layer_name, gen_settings)
            game.surfaces[layer_name].daytime = 0.5
            game.surfaces[layer_name].freeze_daytime = true
        end
        if remote.interfaces["RSO"] then
            remote.call("RSO", "ignoreSurface", layer_name)
        end
    end
    
    -- create player proxies
    global.player_proxies = {}
    print("Player Count: " .. tostring(# game.players))
    for i, p in pairs(game.players) do
       print("Creating proxy for player:" .. p.name)
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

    for i = 2, subterra.config.MAX_LAYER_COUNT do
        local l_name = "underground_"..tostring(i-1)
        local layer = {
            index = i,
            surface = game.surfaces[l_name],
            telepads = Quadtree:new(),
            pad_ghosts = Quadtree:new(),
            belt_ghosts = Quadtree:new(),
            power_ghosts = Quadtree:new()
        }

        layer.telepads:rebuild_index()
        layer.pad_ghosts:rebuild_index()
        layer.belt_ghosts:rebuild_index()
        layer.power_ghosts:rebuild_index()

        table.insert(global.layers, layer)
        global.layers[l_name] = layer
    end

    -- get currently generated surface chunks
    local minx = -2147483648 -- sentinels, min/max 32-bit 2's compliment
    local miny = -2147483648 
    local maxx = 2147483647
    local maxy = 2147483647 

    for chunk in top_surface.get_chunks() do
       minx = math.max(minx, chunk.x)
       miny = math.max(miny, chunk.y)
       maxx = math.min(maxx, chunk.x)
       maxy = math.min(maxy, chunk.y)
    end

    local middle = {
        maxx + minx * 16,
        maxy + miny * 16
    }
    local radius = math.max(10, math.max(maxx - minx, maxy - miny) / 2)

    print("World Rect: {" .. middle[1] .. ", " .. middle[2] .. "} radius = " .. radius .. "\n")
    print("X: " .. minx .. ", " .. maxx)
    print("Y: " .. miny .. ", " .. maxy)
    print("")

    -- set adjacency and kickstart chunk generation
    global.layers[1].layer_below = global.layers[2]
    for i = 2, subterra.config.MAX_LAYER_COUNT do
        --global.layers[i].surface.request_to_generate_chunks({0,0}, 10)
        global.layers[i].surface.request_to_generate_chunks(middle, radius)
        global.layers[i].layer_above = global.layers[i-1]
        if i < subterra.config.MAX_LAYER_COUNT then
            global.layers[i].layer_below = global.layers[i+1]
        else
            global.layers[i].layer_below = nil
        end
    end

    -- initialize proxy containers
    if not global.belt_inputs then global.belt_inputs = {} end
    if not global.belt_outputs then global.belt_outputs = {} end

    if not global.power_inputs then global.power_inputs = {} end
    if not global.power_outputs then global.power_outputs = {} end

    -- set underground enitity list
    initialize_underground_whitelist()

    print("SubTerra Initialization Complete")
end

function initialize_underground_whitelist()
    if not global.underground_whitelist then global.underground_whitelist = {} end

    for name,_ in pairs(subterra.config.underground_entities) do
        global.underground_whitelist[name] = true
    end
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