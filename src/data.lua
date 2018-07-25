if not subterra then subterra = {} end
if not subterra.config then subterra.config = {} end

S_ROOT = "__subterra__"

_blank = S_ROOT .. "/graphics/blank.png"
function blank_picture()
    return {
        filename = _blank,
        priority = "high",
		width = 1,
		height = 1,
		frame_count = 1,
    }
end

require("config")
require("prototypes.categories.fuel-category")
require("prototypes.categories.recipe-category")
require("prototypes.tile.tiles")
require("prototypes.entity.pads")
require("prototypes.entity.power")
require("prototypes.item.pads")
require("prototypes.item.item-groups")
require("prototypes.item.power")
--require("prototypes.item.rail")
require("prototypes.batteries.batteries")
require("prototypes.rail.locomotives")
--require("prototypes.recipe.belts")
require("prototypes.recipe.pads")
require("prototypes.recipe.power")
require("prototypes.technology.technology")