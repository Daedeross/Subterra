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
require("prototypes.tile.tiles")
require("prototypes.entity.pads")
require("prototypes.entity.rail")
require("prototypes.entity.belts")
require("prototypes.entity.power")
require("prototypes.item.pads")
require("prototypes.item.belts")
require("prototypes.item.power")
require("prototypes.recipe.belts")
require("prototypes.recipe.pads")
require("prototypes.recipe.power")