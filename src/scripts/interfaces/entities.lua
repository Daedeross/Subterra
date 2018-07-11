local interface = "entities"
local callbacks = {}

function register(name, callback)
    callbacks[name] = callback
end

register("add", function(name)
    global.underground_whitelist[name] = true
end)

register("remove", function(name)
    global.underground_whitelist[name] = nil
end)

remote.add_interface("subterra:" .. interface, callbacks)
