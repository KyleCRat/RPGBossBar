local ADDON_NAME, RPGBB = ...

RPGBB:RegisterDefaultSkin({
    id = "vigor_gold",
    name = "Vigor Gold",
    overrides = {
        accents = {
            center = {
                group = "sgvigor-gold-center",
            },
            color = {
                a = 1,
                b = 45 / 255,
                g = 154 / 255,
                r = 214 / 255,
            },
            left = {
                group = "sgvigor-gold-side",
            },
            right = {
                group = "sgvigor-gold-side",
            },
        },
        frame = {
            border = {
                texture = "Interface\\AddOns\\RPGBossBar\\media\\art\\dragonriding_sgvigor_border_gold.tga",
            },
        },
        health = {
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
            border = {
                texture = "Interface\\AddOns\\RPGBossBar\\media\\art\\dragonriding_sgvigor_border_gold.tga",
            },
        },
    },
})
