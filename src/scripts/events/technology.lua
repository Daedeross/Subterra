require 'scripts/utils'

local tech_callbacks = require("__subterra__.scripts.events.technology.tech_callbacks")

register_event(defines.events.on_research_finished,
function(event)
    local research = event.research
    local name = research.name

    local callback = tech_callbacks[name]
    if callback then
        callback(research, event.by_script)
    end
end)