local get_or_add_element = function (root, type, name, params)
    if not params then params = {} end
    params.type = type
    params.name = name

    if not root[name] then
        root.add(params)
    end

    return root[name]
end

local hide_element = function (root, name)
    if not root or not root[name] then
        return
    end
    root[name].visible = false
end

local ELEMENT_NAME = "subterra_level"

local display_level = function (player)
    local top = player.gui.top

    local settings = settings.get_player_settings(player)
    if not settings["subterra-show-level"].value then
        hide_element(top, ELEMENT_NAME)
        return
    end

    local layer = global.layers[player.surface.name]
    if (not layer) or (layer.index == 1) then
        hide_element(top, ELEMENT_NAME)
        return
    end
    
    local element = get_or_add_element(top, "label", ELEMENT_NAME, {style = "subterra-depth-label"})

    element.caption = {"ui.subterra-depth-caption", layer.index - 1 }
    element.visible = true
end

return display_level