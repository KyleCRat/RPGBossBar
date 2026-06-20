local ADDON_NAME, RPGBB = ...

RPGBB:RegisterDefaultSkin({
    id = "simple_alliance",
    name = "Simple Alliance",
    overrides = {
        frame = {
            background_color = {
                a = 0.8,
                b = 0,
                g = 0,
                r = 0,
            },
            border = {
                color = {
                    a = 1,
                    b = 1,
                    g = 1,
                    r = 1,
                },
                offset = 5,
                size = 24,
                texture = "Interface\\AddOns\\RPGBossBar\\media\\art\\ActionBar-Border.tga",
            },
        },
        accents = {
            center = {
                custom_atlas = "Quest-Alliance-WaxSeal",
                height_scale = 1,
                mirror_x = false,
                mirror_y = false,
                offset = {
                    x = 0,
                    y = 0,
                },
                rotation = 0,
                scale = .7,
                selected = "none",
                width_scale = 1,
            },
            color = {
                a = 1,
                b = 1,
                g = 1,
                r = 1,
            },
            left = {
                custom_atlas = "",
                height_scale = 1,
                mirror_x = false,
                mirror_y = false,
                offset = {
                    x = 22,
                    y = 8,
                },
                rotation = 0,
                scale = 1,
                selected = "simple-alliance-gryphon-left",
                width_scale = 1,
            },
            right = {
                custom_atlas = "",
                height_scale = 1,
                mirror_x = false,
                mirror_y = false,
                offset = {
                    x = -22,
                    y = 8,
                },
                rotation = 0,
                scale = 1,
                selected = "simple-alliance-gryphon-right",
                width_scale = 1,
            },
        },
        name = {
            enabled = true,
            font = {
                color = {
                    a = 1,
                    b = 1,
                    g = 1,
                    r = 1,
                },
                font = "Fonts\\FRIZQT__.TTF",
                size = 28,
            },
            offset = {
                y = 2,
            },
        },
        health = {
            font = {
                enabled = true,
                font = "Fonts\\FRIZQT__.TTF",
                size = 23,
                color = {
                    a = 1,
                    b = 1,
                    g = 1,
                    r = 1,
                },
                offset = {
                    y = -1,
                },
            },
            percent_font = {
                enabled = true,
                offset = {
                    x = -28,
                },
            },
            spark = {
                color = {
                    a = 1,
                    b = 255 / 255,
                    g = 205 / 255,
                    r = 100 / 255,
                },
            },
            texture = {
                atlas = false,
                atlas_texture = false,
                color = {
                    a = 1,
                    r = 0 / 255,
                    g = 90 / 255,
                    b = 179 / 255,
                },
                desaturated = false,
                texture = "Interface\\Buttons\\WHITE8X8",
            },
        },
        power = {
            enabled = true,
            height = 12,
            offset_y = -2,
            percent_width = 80,
            texture = "Interface\\Buttons\\WHITE8X8",
            border = {
                color = {
                    a = 1,
                    b = 1,
                    g = 1,
                    r = 1,
                },
                offset = 2,
                size = 10,
                texture = "Interface\\AddOns\\RPGBossBar\\media\\art\\ActionBar-Border.tga",
            },
            color = {
                a = 1,
                r = 1,
                g = 1,
                b = 0,
            },
            font = {
                enabled = false,
            },
        },
    },
})
