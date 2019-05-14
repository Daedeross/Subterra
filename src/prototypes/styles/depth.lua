local default_gui = data.raw['gui-style'].default

local depth_label = {
    type = 'label_style',
    parent = 'label',
    top_padding = 5,
    left_padding = 5,
    right_padding = 5,
    bottom_padding = 5,
    font = "default-game"
}

default_gui["subterra-depth-label"] = depth_label