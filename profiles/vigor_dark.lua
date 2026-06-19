local ADDON_NAME, RPGBB = ...

RPGBB:RegisterDefaultSkin({
    id = "vigor_dark",
    name = "Vigor Dark",
    overrides = {
        accents = {
            center = {
                group = "sgvigor-dark-center",
            },
            color = {
                a = 1,
                b = 106 / 255,
                g = 34 / 255,
                r = 70 / 255,
            },
            left = {
                group = "sgvigor-dark-side",
            },
            right = {
                group = "sgvigor-dark-side",
            },
        },
        frame = {
            border = {
                texture = "Interface\\AddOns\\RPGBossBar\\media\\art\\dragonriding_sgvigor_border_dark.tga",
            },
        },
        health = {
            spark = {
                color = {
                    a = 1,
                    b = 255 / 255,
                    g = 167 / 255,
                    r = 229 / 255,
                },
            },
            texture = {
                atlas = true,
                atlas_texture = "Unit_Priest_Insanity_Fill",
                color = {
                    a = 1,
                    b = 1,
                    g = 1,
                    r = 1,
                },
                desaturated = false,
                texture = false,
            },
        },
        power = {
            border = {
                texture = "Interface\\AddOns\\RPGBossBar\\media\\art\\dragonriding_sgvigor_border_dark.tga",
            },
        },
    },
})
