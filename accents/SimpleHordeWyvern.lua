local ADDON_NAME, RPGBB = ...

local function RegisterSideAccent(side, atlas)
    RPGBB:RegisterAccentOption({
        id = "simple-horde-wyvern-" .. side,
        name = "Simple Horde Wyvern",
        kind = "atlas",
        atlas = atlas,
        slots = {
            [side] = true,
        },
        native_side = side,
        height_multiplier = 2.45,
        fallback_width = 256,
        fallback_height = 128,
        desaturated = true,
        tint = true,
    })
end

RegisterSideAccent("left", "UI-HUD-ActionBar-Wyvern-Left")
RegisterSideAccent("right", "UI-HUD-ActionBar-Wyvern-Right")
