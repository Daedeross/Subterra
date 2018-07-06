--============================================================================--
-- initialization.lua
--============================================================================--

require 'util'
require ('config')
require 'scripts/utils'
require 'scripts.quadtree'
--MAX_LAYER_COUNT = 2

--============================================================================--
-- initialize_subterra()
--
-- initiate mod and generate underground surface
-- wired in control.lua:game.on_init
--============================================================================--
function initialize_subterra ()
    print("Starting SubTerra Initialization")
    for n,_ in pairs(subterra.config.starting_entities) do
        print(n)
    end
    -- copy map settings
    local gen_settings = table.deepcopy(game.surfaces['nauvis'].map_gen_settings)
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
       print(p.name)
       add_player_proxy(i)
    end

    -- initialize layers container
    global.layers = {}
    table.insert(global.layers, {
            index = 1,
            layer_above = nil,
            surface = game.surfaces["nauvis"],
            telepads = Quadtree:new()
        })
    global.layers["nauvis"] = global.layers[1]

    for i = 2, subterra.config.MAX_LAYER_COUNT do
        local l_name = "underground_"..tostring(i-1)
        local layer = {
            index = i,
            surface = game.surfaces[l_name],
            telepads = Quadtree:new()
        }
        print("Pad meta...")
        print(getmetatable(layer.telepads))
        print(getmetatable(layer.telepads).name)
        print(layer.telepads:check_proxy_collision(make_bbox(0, 0, 1, 1)))
        table.insert(global.layers, layer)
        global.layers[l_name] = layer
    end

    -- set adjacency and kickstart chunk generation
    global.layers[1].layer_below = global.layers[2]
    for i = 2, subterra.config.MAX_LAYER_COUNT do
        global.layers[i].surface.request_to_generate_chunks({0,0}, 10)
        global.layers[i].layer_above = global.layers[i-1]
        if i < subterra.config.MAX_LAYER_COUNT then
            global.layers[i].layer_below = global.layers[i+1]
        else
            global.layers[i].layer_below = nil
        end
    end

    -- initialize belt-elevator container
    global.belt_inputs = {}
    global.belt_outputs = {}

    -- set underground enitity list
    global.underground_entities = table.deepcopy(subterra.config.starting_entities)

    print("SubTerra Initialization Complete")
end

function on_load()
    print("OnLoad")
    for _, layer in pairs(global.layers) do
        local pads = layer.telepads
        if not getmetatable(pads) then
            setmetatable(pads, Quadtree)
	        pads:rebuild_metatables()
        end
    end
end