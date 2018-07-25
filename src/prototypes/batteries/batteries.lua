require("util")

local battery_levels = 4

local energy_start = 50
local energy_mult = 2

local accel_start = 1.0
local accel_mult = 1.2
local speed_start = 1.0
local speed_mult = 1.5

local recharger_speed = 1
local recharger_power = 10      -- MW
local recharger_output = recharger_speed * recharger_power

local BATTERY_ICON = "__base__/graphics/icons/battery.png"

function format_mj(megajoules)
    local value = megajoules
    if value < 1 then
        value = value * 1000
        if value < 1 then
            return value * 1000 .. "J"
        else
            return value .. "kJ"
        end
    end

    if value < 1000 then
        return value .. "MJ"
    else
        return (value / 1000) .. "GJ"
    end
end

function make_battery(level, icon, energy, accel, speed)
    local crafting_energy = energy / recharger_output
    print("ENERGY: " .. crafting_energy)
    local previous_level_item
    if level == 1 then
        previous_level_item = "battery"
    else
        previous_level_item = "subterra-battery-empty-" .. (level - 1)
    end

    data:extend({
        {
            type = "item",
            name = "subterra-battery-full-" .. level,
            icon = icon,
            icon_size = 32,
            flags = {"goes-to-main-inventory"},
            fuel_category = "battery-rechargable",
            fuel_value = energy .. "MJ",
            fuel_acceleration_multiplier = accel,
            fuel_top_speed_multiplier = speed,
            burnt_result = "subterra-battery-empty-" .. level,
            subgroup = "subterra-battery-full",
            order = "b[battery-" .. level .."]",
            stack_size = 50
        },
        {
            type = "item",
            name = "subterra-battery-empty-" .. level,
            icons = { {icon = icon, tint = {r=0.5,g=0.5,b=0.5,a=1}}},
            icon_size = 32,
            flags = {"goes-to-main-inventory"},
            subgroup = "subterra-battery-empty",
            order = "r[subterra-battery-empty-" .. level .. "]",
            stack_size = 50
        },
        {
            type = "recipe",
            name = "subterra-battery-empty-" .. level,
            energy_required = crafting_energy,
            enabled = false,
            subgroup = "subterra-battery-empty",
            ingredients =
            {
                {type = "item", name = previous_level_item, amount = energy_mult},
                {type = "item", name = "copper-plate", amount = 2 + level * 2}
            },
            results = {{"subterra-battery-empty-" .. level, 1}},
            requester_paste_multiplier = 4
        },
        {
            type = "recipe",
            name = "subterra-battery-full-" .. level,
            category = "recharging",
            energy_required = crafting_energy,
            ingredients =
            {
                {"subterra-battery-empty-" .. level, 1}
            },
            results = {{"subterra-battery-full-" .. level, 1}},
            requester_paste_multiplier = 4
        },
    })
end

function make_recharger(speed, power)
data:extend({
    {
        type = "item",
        name = "subterra-recharger",
        --icon = "__base__/graphics/icons/assembling-machine-1.png",
        icons = { {
            icon = "__base__/graphics/icons/assembling-machine-1.png",
            tint = {r=0,g=0.5,b=0.5,a=1}
        }
        } ,
        icon_size = 32,
        flags = {"goes-to-quickbar"},
        subgroup = "production-machine",
        order = "s[subterra-recharger]",
        place_result = "subterra-recharger",
        stack_size = 10
    },
    {
      type = "recipe",
      name = "subterra-recharger",
      normal =
      {
        enabled = false,
        ingredients =
        {
          {"copper-plate", 10},
          {"electronic-circuit", 10},
          {"advanced-circuit", 5},
          {"accumulator", 1}
        },
        result = "subterra-recharger"
      },
      expensive =
      {
        enabled = false,
        ingredients =
        {
          {"copper-plate", 20},
          {"electronic-circuit", 20},
          {"advanced-circuit", 10},
          {"accumulator", 1}
        },
        result = "subterra-recharger"
      }
    },
    {
        type = "assembling-machine",
        name = "subterra-recharger",
        icon = "__base__/graphics/icons/assembling-machine-1.png",
        icon_size = 32,
        flags = {"placeable-neutral", "placeable-player", "player-creation"},
        minable = {hardness = 0.2, mining_time = 0.5, result = "subterra-recharger"},
        max_health = 300,
        corpse = "big-remnants",
        dying_explosion = "medium-explosion",
        resistances =
        {
          {
            type = "fire",
            percent = 70
          }
        },
        collision_box = {{-0.8, -0.8}, {0.8, 0.8}},
        selection_box = {{-1.0, -1.0}, {1.0, 1.0}},
        fast_replaceable_group = nil,
        alert_icon_shift = util.by_pixel(-3, -12),
        animation =
        {
          layers =
          {
            {
              filename = "__base__/graphics/entity/assembling-machine-1/assembling-machine-1.png",
              priority="high",
              width = 108,
              height = 114,
              frame_count = 32,
              line_length = 8,
              shift = util.by_pixel(0, 2),
              scale = 0.666667,
              tint = {r=0,g=0.5,b=0.5,a=1},
              hr_version =
              {
                filename = "__base__/graphics/entity/assembling-machine-1/hr-assembling-machine-1.png",
                priority="high",
                width = 214,
                height = 226,
                frame_count = 32,
                line_length = 8,
                shift = util.by_pixel(0, 2),
                scale = 0.333333,
                tint = {r=0,g=0.5,b=0.5,a=1},
              }
            },
            {
              filename = "__base__/graphics/entity/assembling-machine-1/assembling-machine-1-shadow.png",
              priority="high",
              width = 95,
              height = 83,
              frame_count = 1,
              line_length = 1,
              repeat_count = 32,
              draw_as_shadow = true,
              shift = util.by_pixel(8.5, 5.5),
              scale = 0.666667,
              tint = {r=0,g=0.5,b=0.5,a=1},
              hr_version =
              {
                filename = "__base__/graphics/entity/assembling-machine-1/hr-assembling-machine-1-shadow.png",
                priority="high",
                width = 190,
                height = 165,
                frame_count = 1,
                line_length = 1,
                repeat_count = 32,
                draw_as_shadow = true,
                shift = util.by_pixel(8.5, 5),
                scale = 0.333333,
                tint = {r=0,g=0.5,b=0.5,a=1},
              }
            }
          }
        },
        crafting_categories = {"recharging"},
        crafting_speed = speed,
        energy_source =
        {
          type = "electric",
          usage_priority = "secondary-input",
          emissions = 0
        },
        energy_usage = power .. "MW",
        ingredient_count = 1,
        open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
        close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
        vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
        working_sound =
        {
            sound =
            {
              filename = "__base__/sound/accumulator-working.ogg",
              volume = 1
            },
            idle_sound =
            {
              filename = "__base__/sound/accumulator-idle.ogg",
              volume = 0.4
            },
            max_sounds_per_type = 5
        },
        idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
        apparent_volume = 1.5
    }
})
end

function make_batteries(count, energy_start, energy_mult, accel_start, accel_mult, speed_start, speed_mult)
    local energy = energy_start
    local accel = accel_start
    local speed = speed_start
    for i=1, count, 1 do
        make_battery(i, BATTERY_ICON, energy, accel, speed)
        energy = energy * energy_mult
        accel = accel * accel_mult
        speed = speed * speed_mult
    end
end

make_recharger(recharger_speed, recharger_power)
make_batteries(battery_levels, energy_start, energy_mult, accel_start, accel_mult, speed_start, speed_mult)
