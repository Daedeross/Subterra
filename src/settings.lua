data:extend({
    {
        type = "int-setting",
        name = "subterra-max-depth",
        setting_type = "startup",
        default_value = 4,
        minimum_value = 1,
        maximum_value = 5,
        allowed_values = { 1, 2, 3, 4, 5}
    },
    {
        type = "string-setting",
        name = "subterra-whitelist",
        setting_type = "startup",
        default_value = "",
        allow_blank = true
    },
    {
        type = "string-setting",
        name = "subterra-blacklist",
        setting_type = "startup",
        default_value = "",
        allow_blank = true
    },
    {
        type = "string-setting",
        name = "subterra-type-whitelist",
        setting_type = "startup",
        default_value = "",
        allow_blank = true
    },
    {
        type = "string-setting",
        name = "subterra-log-sink",
        setting_type = "startup",
        default_value = "None",
        allowed_values = { "None", "Console", "StdOut", "Subterra Log", "Factorio Log" }
    },
    {
        type = "bool-setting",
        name = "subterra-show-level",
        setting_type = "runtime-per-user",
        default_value = true
    },
    {
        type = "bool-setting",
        name = "subterra-show-build-hud",
        setting_type = "runtime-per-user",
        default_value = true
    },
    {
        type = "double-setting",
        name = "subterra-build-hud-radius",
        setting_type = "startup",
        default_value = 20
    },
    {
        type = "int-setting",
        name = "subterra-radar-update-chunk",
        setting_type = "startup",
        default_value = 60,
        minimum_value = 1,
        maximum_value = 120,
    }
})