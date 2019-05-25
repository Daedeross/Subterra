require("__subterra__.scripts.utils")

local remove_hidden_radars = function(proxy)
    debug("remove_hidden_radars")
    local radars = proxy.radars
    -- all layers except top
    for i=2, proxy.max_level do
        radars[i].destroy()
    end
end

return remove_hidden_radars