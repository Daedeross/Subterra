--============================================================================--
-- generation.lua
--============================================================================--
-- for handling terrain generation in underground layer(s)
--============================================================================--

require("__subterra__.scripts.utils")

local on_chunk_generated = require("__subterra__.scripts.events.generation.on_chunk_generated")
local on_chunk_charted = require("__subterra__.scripts.events.generation.on_chunk_charted")

register_event(defines.events.on_chunk_generated, on_chunk_generated)

--register_event(defines.events.on_chunk_charted, on_chunk_charted)
