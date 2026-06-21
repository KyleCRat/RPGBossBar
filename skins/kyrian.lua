local ADDON_NAME, RPGBB = ...

RPGBB:RegisterDefaultSkin({
    id = "kyrian",
    name = "Kyrian",
    overrides = {
        frame = {
            background_color = { r = 0, g = 0, b = 0, a = 0.8 },
            border = {
                color = { r = 1, g = 1, b = 1, a = 1 },
                offset = 10,
                size = 15,
                texture = "nineslice:kyrian",
            },
        },
        accents = {
            center = {
                color = { r = 1, g = 1, b = 1, a = 1 },
                custom_atlas = "CovenantChoice-Celebration-KyrianSigil",
                desaturated = false,
                height_scale = 1,
                mirror_x = false,
                mirror_y = false,
                offset = {
                    x = 0,
                    y = -1,
                },
                rotation = 0,
                scale = 0.9,
                selected = "none",
                width_scale = 1,
            },
            left = {
                color = { r = 1, g = 1, b = 1, a = 1 },
                custom_atlas = "",
                desaturated = false,
                height_scale = 1,
                mirror_x = false,
                mirror_y = false,
                offset = {
                    x = -15,
                    y = 0,
                },
                rotation = 0,
                scale = 1,
                selected = "kyrian-sanctum-reservoir",
                width_scale = 1,
            },
            right = {
                color = { r = 1, g = 1, b = 1, a = 1 },
                custom_atlas = "",
                desaturated = false,
                height_scale = 1,
                mirror_x = false,
                mirror_y = false,
                offset = {
                    x = 15,
                    y = 0,
                },
                rotation = 0,
                scale = 1,
                selected = "kyrian-sanctum-reservoir",
                width_scale = 1,
            },
            copy_healthbar_texture_color = false,
        },
        name = {
            enabled = true,
            font = {
                color = { r = 1, g = 1, b = 1, a = 1 },
                font = "Fonts\\FRIZQT__.TTF",
                size = 36,
            },
            offset = {
                y = -3,
            },
        },
        health = {
            font = {
                enabled = true,
                font = "Fonts\\FRIZQT__.TTF",
                size = 26,
                color = { r = 1, g = 1, b = 1, a = 1 },
                offset = {
                    y = 0,
                },
            },
            percent_font = {
                disable_above = 3,
                enabled = true,
                offset = {
                    x = -24,
                },
            },
            spark = {
                atlas = "GarrMission_EncounterBar-Spark",
                blend_mode = "ADD",
                color = { r = 0.70588235294118, g = 0.88235294117647, b = 1, a = 1 },
                height_multi = 2.3,
                width = 10,
            },
            texture = {
                atlas = false,
                atlas_texture = false,
                color = { r = 63 / 255, g = 199 / 255, b = 235 / 255, a = 1 },
                desaturated = true,
                texture = "Interface\\Buttons\\WHITE8X8",
            },
        },
        power = {
            enabled = true,
            height = 12,
            hide_above = 3,
            offset_y = -6,
            percent_width = 80,
            texture = "Interface\\Buttons\\WHITE8X8",
            border = {
                offset = 3,
                size = 12,
                texture = "Interface\\AddOns\\RPGBossBar\\media\\art\\ActionBar-Border.tga",
            },
            color = { r = 0.68627452850342, g = 0.803921639919, b = 1, a = 1 },
            font = {
                enabled = false,
            },
        },
    },
})
