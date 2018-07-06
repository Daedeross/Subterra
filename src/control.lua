if not subterra then subterra = {} end
if not subterra.config then subterra.config = {} end
if not subterra.events then subterra.events = {} end

require("util")
require("config")
require("scripts.utils")
require("scripts.events.initialization")
require("scripts.events.generation")
require("scripts.events.building")
require("scripts.events.players")
require("scripts.events.updates")
require("scripts.events.rotation")
require("scripts.quadtree")

-- initiate mod and generate underground surface
script.on_init(initialize_subterra)

-- resetup metatables and stuff
script.on_load(on_load)

-- Wire all registered event callbacks
wire_all_events()
