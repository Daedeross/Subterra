if not subterra then subterra = {} end
if not subterra.config then subterra.config = {} end

require "util"
require "config"
require("scripts.events.initialization")
require("scripts.events.generation")
require("scripts.events.building")
require("scripts.events.updates")
require("scripts.quadtree")

-- initiate mod and generate underground surface
script.on_init(InitializeSubterra)

-- player_proxies maint
script.on_event(defines.events.on_player_joined_game, OnPlayerJoined)

-- Event subscriptions
script.on_event(defines.events.on_chunk_generated, OnChunkGenerated)

script.on_event(defines.events.on_player_joined_game, OnPlayerJoined)

script.on_event(defines.events.on_built_entity, OnBuiltEntity)

script.on_event(defines.events.on_tick, OnTick)