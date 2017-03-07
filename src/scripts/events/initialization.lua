--============================================================================--
-- initialization.lua
--============================================================================--


require 'util'
require 'scripts/utils'


--============================================================================--
-- InitializeSubterra()
--
-- initiate mod and generate underground surface
-- wired in control.lua:game.on_init
--============================================================================--
function InitializeSubterra ()
    -- copy map settings
    local gen_settings = table.deepcopy(game.surfaces['nauvis'].map_gen_settings)
    -- remove resources from settings
    for _, r in pairs(gen_settings.autoplace_controls) do
        r.frequency = 'very-low'
        r.size = 'none'
        r.richness = 'very-poor'
    end
    gen_settings.peaceful_mode = true
    -- create surface with no resources
    if game.surfaces["underground_1"] == nil then
        game.create_surface("underground_1", gen_settings)
        game.surfaces["underground_1"].daytime = 0.5
        game.surfaces["underground_1"].freeze_daytime(true)
    end
    if remote.interfaces["RSO"] then
        remote.call("RSO", "ignoreSurface", "underground_1")
    end
    
    -- create player proxies
    global.player_proxies = {}
    
    for i, p in pairs(game.players) do
       addPlayerProxy(i, p)
    end

    -- initialize telepad container
    global.layers = {
        0 = {
            surface = game.surfaces["nauvis"],
            telepads = Quadtree:new()
        },
        1 = {
            surface = game.surfaces["underground_1"],
            telepads = Quadtree:new()
        }
    }

end

--============================================================================--
-- OnPlayerJoined()
--
-- add player to needed data structures
-- wired in control.lua:
--============================================================================--
function OnPlayerJoined(event)
    
end