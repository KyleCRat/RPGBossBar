local ADDON_NAME, RPGBB = ...

local function RegisterSideAccent(side, atlas)
    RPGBB:RegisterAccentOption({
        id = "simple-alliance-gryphon-" .. side,
        name = "Simple Alliance Gryphon",
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

RegisterSideAccent("left", "UI-HUD-ActionBar-Gryphon-Left")
RegisterSideAccent("right", "UI-HUD-ActionBar-Gryphon-Right")
