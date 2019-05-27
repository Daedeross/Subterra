local tolerance = 0.01
local limit = subterra and subterra.config and subterra.config.ENTITY_FIND_LIMIT    -- may be nil
local collision_mask = {"item-layer", "object-layer", "player-layer", "water-tile"}
local below_color = { r = 0.25, g = 0.125, b = 0.0, a = 0.05 } -- dark orange
local above_color = { r = 0.0, g = 0.125, b = 0.25, a = 0.05 } -- dark blue-cyan
local math_min = math.min
local math_abs = math.abs

local function darken_color (color, diff)
    if diff == 1 then
        return color
    end
    local mult = 1 / diff
    return {
        r = math_min(1, color.r * mult),
        g = math_min(1, color.g * mult),
        b = math_min(1, color.b * mult),
        a = color.a
    }
end
--===========================================================================================--
-- draw_nearby_boxes(player, current_surface, target_surface, radius, duration, difference)
--
-- checks every n-th tick (default 60) and draws the placement HUD for players
--      that need it.
--
-- param player (LuaPlayer): The player to draw for.
-- param current_surface (LuaSurface): The surface the player is currently on.
-- param target_surface (LuaSurface): The surface to scan for entities.
-- param radius (double): The distance to scan (i.e. 1/2 bounding box height/width).
-- param duration (int): The duration in ticks to draw the HUD.
-- param difference (int): The difference between levels of current_surface and target_surface
--      positive difference -> above, negative -> below
--
-- remarks: the Drawn boxes are darkened the greater the absolute value of difference.
--===========================================================================================--
local draw_nearby_boxes = function(player, current_surface, target_surface, radius, duration, difference)
    local draw_color
    if difference > 0 then
        draw_color = darken_color(above_color, math_abs(difference))
    else
        draw_color = darken_color(below_color, math_abs(difference))
    end

    local x = player.position.x
    local y = player.position.y

    local filter = {
        collision_mask = collision_mask,
        limit = limit,
        area = { { x - radius, y - radius }, { x + radius, y + radius } }
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

    for k, box in pairs(boxes) do   -- TODO: Change to numeric for
        rendering.draw_rectangle({
            color = draw_color,
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