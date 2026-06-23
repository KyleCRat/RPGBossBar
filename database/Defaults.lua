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

local font_outlines = {
    [""] = true,
    OUTLINE = true,
    THICKOUTLINE = true,
    OUTLINESLUG = true,
    MONOCHROMEOUTLINE = true,
    MONOCHROMETHICKOUTLINE = true,
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
            outline = "OUTLINESLUG",
            color = { r = 1, g = 1, b = 1, a = 1 },
            offset = {
                y = 0
            }
        },
        percent_font = {
            enabled = true,
            disable_above = 3,
            outline = "OUTLINESLUG",
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
            outline = "THICKOUTLINE",
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
            outline = "OUTLINE",
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
        left = {
            color = { r = 70/255, g = 34/255, b = 106/255, a = 1 },
            selected = "sgvigor-dark-side",
            custom_atlas = "",
            desaturated = false,
            scale = 1,
            width_scale = 1,
            height_scale = 1,
            rotation = 0,
            mirror_x = false,
            mirror_y = false,
            offset = {
                x = 0,
                y = 0,
            },
        },
        right = {
            color = { r = 70/255, g = 34/255, b = 106/255, a = 1 },
            selected = "sgvigor-dark-side",
            custom_atlas = "",
            desaturated = false,
            scale = 1,
            width_scale = 1,
            height_scale = 1,
            rotation = 0,
            mirror_x = false,
            mirror_y = false,
            offset = {
                x = 0,
                y = 0,
            },
        },
        center = {
            color = { r = 70/255, g = 34/255, b = 106/255, a = 1 },
            selected = "sgvigor-dark-center",
            custom_atlas = "",
            desaturated = false,
            scale = 1,
            width_scale = 1,
            height_scale = 1,
            rotation = 0,
            mirror_x = false,
            mirror_y = false,
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
    font_outlines = font_outlines,
    accent_selection_paths = {
        ["accents.center.selected"] = "center",
        ["accents.left.selected"] = "left",
        ["accents.right.selected"] = "right",
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
    font_outline_paths = {
        ["health.font.outline"] = true,
        ["health.percent_font.outline"] = true,
        ["name.font.outline"] = true,
        ["power.font.outline"] = true,
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
