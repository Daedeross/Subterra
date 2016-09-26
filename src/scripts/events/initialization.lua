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
    if game.surfaces["underground-1"] == nil then
        game.create_surface("underground-1", gen_settings)
        game.surfaces["underground-1"].daytime = 0.5
        game.surfaces["underground-1"].freeze_daytime(true)
    end
    if remote.interfaces["RSO"] then
        remote.call("RSO", "ignoreSurface", "underground-1")
    end
    
    -- create player proxies
    global.player_proxies = {}
    
    for i, p in pairs(game.players) do
       addPlayerProxy(i, p)
    end
end

--============================================================================--
-- InitializeSubterra()
--
-- initiate mod and generate underground surface
-- wired in control.lua:
--============================================================================--
function OnPlayerJoined(event)
    
end