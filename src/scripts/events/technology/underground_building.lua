local underground_building_researched = function(research, by_script)
    local find = string.find(research.name, "underground%-building") 
    debug(research.name)
    if find then
        -- debug("LEVEL " .. research.level)
        global.current_depth[research.force.name] = research.level
    end
end

return underground_building_researched