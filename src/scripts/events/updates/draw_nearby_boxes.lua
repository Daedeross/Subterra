
local tolerance = 0.1
local limit = subterra and subterra.config and subterra.config.ENTITY_FIND_LIMIT    -- may be nil
local collision_mask = {"item-layer", "object-layer", "player-layer", "water-tile"}
local render_color = { r = 0.5, g = 0.323, b = 0.0, a = 0.1 }

local draw_nearby_boxes = function(player, current_surface, target_surface, radius, duration)
    debug("Draw Boxes: " .. tostring(duration))
    local filter = {
        collision_mask = collision_mask,
        limit = limit,
        position = player.position,
        radius = radius
    }
    local players = { player }
    local boxes = {}

    for _, entity in pairs(target_surface.find_entities_filtered(filter)) do
        local bbox = entity.bounding_box
        if bbox then
            local left_top = bbox.left_top
            local right_bottom  = bbox.right_bottom
            if (right_bottom.x - left_top.x > tolerance)
             and (right_bottom.y - left_top.y > tolerance) then
                table.insert(boxes, bbox)
            end
        end
    end

    for k, box in pairs(boxes) do
        rendering.draw_rectangle({
            color = render_color,
            filled = true,
            left_top = box.left_top,
            right_bottom = box.right_bottom,
            surface = current_surface,
            players = players,
            time_to_live = duration
        })
    end
end

return draw_nearby_boxes