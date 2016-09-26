require "util"
require "config"
require("scripts.events.initialization")
require("scripts.events.generation")
require("scripts.events.building")

-- initiate mod and generate underground surface
script.on_init(InitializeSubterra)

-- player_proxies maint
script.on_event(defines.events.on_player_joined_game, OnPlayerJoined)

-- Event subscriptions
script.on_event(defines.events.on_chunk_generated, OnChunkGenerated)

script.on_event(defines.events.on_player_joined_game, OnPlayerJoined)

script.on_event(defines.events.on_built_entity, OnBuiltEntity)