require 'scripts/utils'

register_event(defines.events.on_research_finished,
function(event)
    local research = event.research
    local find = string.find(research.name, "underground%-building") 
    print(find)
    if find then
        print("LEVEL " .. research.level)
        global.current_depth[research.force.name] = research.level
    end
end)