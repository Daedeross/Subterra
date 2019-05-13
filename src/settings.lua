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
        name = "subterra-log-sink",
        setting_type = "startup",
        default_value = "None",
        allowed_values = { "None", "Console", "StdOut", "Subterra Log", "Factorio Log" }
    }
})