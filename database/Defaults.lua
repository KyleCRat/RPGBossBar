local ADDON_NAME, addon = ...

local anchor_points = {
    BOTTOM = true,
    BOTTOMLEFT = true,
    BOTTOMRIGHT = true,
    CENTER = true,
    LEFT = true,
    RIGHT = true,
    TOP = true,
    TOPLEFT = true,
    TOPRIGHT = true,
}

local blend_modes = {
    ADD = true,
    ALPHAKEY = true,
    BLEND = true,
    DISABLE = true,
    MOD = true,
}

addon.db_defaults = {
    frame = {
        width = 1100,
        height = 38,
        background_color = { r = 0, g = 0, b = 0, a = 0.8 },
        border = {
            texture = "Interface\\AddOns\\RPGBossBar\\media\\art\\dragonriding_sgvigor_border_dark.tga",
            color = { r = 1, g = 1, b = 1, a = 1 },
            size = 32,
            offset = 4,
        },
        position = {
            x = 0,
            y = -70,
            point = "TOP",
            relative_point = "TOP",
        },
    },
    health = {
        font = {
            enabled = true,
            font = "Interface\\AddOns\\RPGBossBar\\media\\fonts\\Metamorphous-Regular.ttf",
            size = 20,
            color = { r = 1, g = 1, b = 1, a = 1 },
            offset = {
                y = 0
            }
        },
        percent_font = {
            enabled = true,
            disable_above = 3,
            offset = {
                x = -24,
            },
        },
        texture = {
            atlas = true,
            texture = false,
            atlas_texture = "Unit_Priest_Insanity_Fill",
            desaturated = false,
            color = { r = 1, g = 1, b = 1, a = 1 },
        },
        spark = {
            atlas = "GarrMission_EncounterBar-Spark",
            color = { r = 229/255, g = 167/255, b = 255/255, a = 1 },
            blend_mode = "ADD",
            width = 10,
            height_multi = 2.3,
        },
    },
    name = {
        enabled = true,
        offset = {
            y = 2,
        },
        font = {
            font = "Interface\\AddOns\\RPGBossBar\\media\\fonts\\Metamorphous-Regular.ttf",
            size = 32,
            color = { r = 1, g = 1, b = 1, a = 1 },
        },
    },
    power = {
        enabled = true,
        percent_width = 80,
        height = 12,
        offset_y = 0,
        texture = "Interface\\Buttons\\WHITE8X8",
        color = { r = 1, g = 1, b = 0, a = 1 },
        hide_above = 3,
        border = {
            texture = "Interface\\AddOns\\RPGBossBar\\media\\art\\dragonriding_sgvigor_border_dark.tga",
            color = { r = 1, g = 1, b = 1, a = 1 },
            size = 10,
            offset = 2,
        },
        font = {
            enabled = false,
            show_percent = true,
            font = "Interface\\AddOns\\RPGBossBar\\media\\fonts\\Metamorphous-Regular.ttf",
            size = 16,
            color = { r = 1, g = 1, b = 1, a = 1 },
            hide_above = 5,
            position = {
                point = "CENTER",
                relative_point = "CENTER",
                x = 0,
                y = 0,
            },
        },
    },
    accents = {
        copy_healthbar_texture_color = false,
        color = { r = 70/255, g = 34/255, b = 106/255, a = 1 },
        left = {
            group = "sgvigor-dark-side",
            offset = {
                x = 0,
                y = 0,
            },
        },
        right = {
            group = "sgvigor-dark-side",
            offset = {
                x = 0,
                y = 0,
            },
        },
        center = {
            group = "sgvigor-dark-center",
            offset = {
                x = 0,
                y = 0,
            },
        },
    }
}

addon.db_validation = {
    anchor_points = anchor_points,
    blend_modes = blend_modes,
    accent_group_paths = {
        ["accents.center.group"] = "center",
        ["accents.left.group"] = "left",
        ["accents.right.group"] = "right",
    },
    anchor_point_paths = {
        ["frame.position.point"] = true,
        ["frame.position.relative_point"] = true,
        ["power.font.position.point"] = true,
        ["power.font.position.relative_point"] = true,
    },
    blend_mode_paths = {
        ["health.spark.blend_mode"] = true,
    },

    -- These fields store raw media references that may intentionally be false.
    -- Validate only the safe value shape; do not require the texture or atlas
    -- to exist locally.
    string_or_false_paths = {
        ["frame.border.texture"] = true,
        ["health.texture.atlas_texture"] = true,
        ["health.texture.texture"] = true,
        ["power.border.texture"] = true,
    },
}
