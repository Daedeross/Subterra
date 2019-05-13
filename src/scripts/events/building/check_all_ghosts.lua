local check_ghosts = require("__subterra__.scripts.events.building.check_ghosts")

--============================================================================--
-- check_all_ghosts(layer, bounding_box)
--
-- checks for and removes all ghost proxies within an area
--
-- param layer (table): The entry from the global.layers table
--      see TODO for definition
-- param bounding_box (BoundingBox): the bounding box the check
--
-- remarks: removes ghost entities for telepads (pad_ghosts),
--      belt elevators (belt_ghosts), and power converters (power_ghosts)
--============================================================================--
local check_all_ghosts = function (layer, bounding_box)
    if not layer then return end
    -- pads
    local paired_layer = check_ghosts(layer, layer.pad_ghosts, bounding_box)
    if paired_layer then
        check_ghosts(paired_layer, paired_layer.pad_ghosts, bounding_box)
    end
    -- belts
    paired_layer = check_ghosts(layer, layer.belt_ghosts, bounding_box)
    if paired_layer then
        check_ghosts(paired_layer, paired_layer.belt_ghosts, bounding_box)
    end
    -- power
    paired_layer = check_ghosts(layer, layer.power_ghosts, bounding_box)
    if paired_layer then
        check_ghosts(paired_layer, paired_layer.power_ghosts, bounding_box)
    end
end

return check_all_ghosts