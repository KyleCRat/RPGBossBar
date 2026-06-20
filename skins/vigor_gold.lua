local ADDON_NAME, RPGBB = ...

RPGBB:RegisterDefaultSkin({
    id = "vigor_gold",
    name = "Vigor Gold",
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
                offset = 4,
                size = 32,
                texture = "Interface\\AddOns\\RPGBossBar\\media\\art\\dragonriding_sgvigor_border_gold.tga",
            },
        },
        accents = {
            center = {
                custom_atlas = "",
                height_scale = 1,
                mirror_x = false,
                mirror_y = false,
                offset = {
                    x = 0,
                    y = 0,
                },
                rotation = 0,
                scale = 1,
                selected = "sgvigor-gold-center",
                width_scale = 1,
            },
            color = {
                a = 1,
                b = 45 / 255,
                g = 154 / 255,
                r = 214 / 255,
            },
            left = {
                custom_atlas = "",
                height_scale = 1,
                mirror_x = false,
                mirror_y = false,
                offset = {
                    x = 0,
                    y = 0,
                },
                rotation = 0,
                scale = 1,
                selected = "sgvigor-gold-side",
                width_scale = 1,
            },
            right = {
                custom_atlas = "",
                height_scale = 1,
                mirror_x = false,
                mirror_y = false,
                offset = {
                    x = 0,
                    y = 0,
                },
                rotation = 0,
                scale = 1,
                selected = "sgvigor-gold-side",
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
                font = "Interface\\AddOns\\RPGBossBar\\media\\fonts\\Metamorphous-Regular.ttf",
                size = 32,
            },
            offset = {
                y = 2,
            },
        },
        health = {
            font = {
                enabled = true,
                font = "Interface\\AddOns\\RPGBossBar\\media\\fonts\\Metamorphous-Regular.ttf",
                size = 20,
                color = {
                    a = 1,
                    b = 1,
                    g = 1,
                    r = 1,
                },
                offset = {
                    y = 0,
                },
            },
            percent_font = {
                enabled = true,
                offset = {
                    x = -24,
                },
            },
            spark = {
                color = {
                    a = 1,
                    b = 90 / 255,
                    g = 220 / 255,
                    r = 1,
                },
            },
            texture = {
                atlas = true,
                atlas_texture = "Unit_Evoker_EbonMight_Fill",
                color = {
                    a = 1,
                    b = 70 / 255,
                    g = 190 / 255,
                    r = 1,
                },
                desaturated = true,
                texture = false,
            },
        },
        power = {
            enabled = true,
            height = 12,
            offset_y = 0,
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
                texture = "Interface\\AddOns\\RPGBossBar\\media\\art\\dragonriding_sgvigor_border_gold.tga",
            },
            color = {
                a = 1,
                b = 0,
                g = 1,
                r = 1,
            },
            font = {
                enabled = false,
            },
        },
    },
})
