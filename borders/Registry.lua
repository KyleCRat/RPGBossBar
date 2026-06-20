local ADDON_NAME, RPGBB = ...

local UNIQUE_CORNERS_BORDER_LAYOUT = {
    TopRightCorner = {
        atlas = "%s-NineSlice-CornerTopRight",
    },
    TopLeftCorner = {
        atlas = "%s-NineSlice-CornerTopLeft",
    },
    BottomLeftCorner = {
        atlas = "%s-NineSlice-CornerBottomLeft",
    },
    BottomRightCorner = {
        atlas = "%s-NineSlice-CornerBottomRight",
    },
    TopEdge = {
        atlas = "_%s-NineSlice-EdgeTop",
    },
    BottomEdge = {
        atlas = "_%s-NineSlice-EdgeBottom",
    },
    LeftEdge = {
        atlas = "!%s-NineSlice-EdgeLeft",
    },
    RightEdge = {
        atlas = "!%s-NineSlice-EdgeRight",
    },
}

local NINE_SLICE_BORDER_STYLES = {
    {
        name = "Midnight",
        value = "nineslice:midnight",
        fullAtlas = {
            atlas = "ui-frame-midnight-border",
            sampleLeft = 0.25,
            sampleRight = 0.75,
            topBottom = 0.10,
            bottomTop = 0.90,
        },
    },
    {
        name = "The War Within",
        value = "nineslice:thewarwithin",
        fullAtlas = {
            atlas = "ui-frame-thewarwithin-border",
            sampleLeft = 0.25,
            sampleRight = 0.75,
            topBottom = 0.10,
            bottomTop = 0.90,
        },
    },
    {
        name = "Dragonflight",
        value = "nineslice:dragonflight",
        layoutName = "DragonflightMissionFrame",
    },
    {
        name = "Shadowlands: Oribos",
        value = "nineslice:oribos",
        layoutName = "CovenantMissionFrame",
    },
    {
        name = "Shadowlands: Kyrian",
        value = "nineslice:kyrian",
        layout = UNIQUE_CORNERS_BORDER_LAYOUT,
        textureKit = "kyrian",
    },
    {
        name = "Shadowlands: Necrolord",
        value = "nineslice:necrolord",
        layout = UNIQUE_CORNERS_BORDER_LAYOUT,
        textureKit = "necrolord",
    },
    {
        name = "Shadowlands: Night Fae",
        value = "nineslice:nightfae",
        layout = UNIQUE_CORNERS_BORDER_LAYOUT,
        textureKit = "nightfae",
    },
    {
        name = "Shadowlands: Venthyr",
        value = "nineslice:venthyr",
        layout = UNIQUE_CORNERS_BORDER_LAYOUT,
        textureKit = "venthyr",
    },
    {
        name = "Shadowlands: Adventures",
        value = "nineslice:adventures",
        layoutName = "AdventuresMissionComplete",
    },
    {
        name = "Alliance",
        value = "nineslice:alliance",
        layout = UNIQUE_CORNERS_BORDER_LAYOUT,
        textureKit = "Alliance",
    },
    {
        name = "Horde",
        value = "nineslice:horde",
        layout = UNIQUE_CORNERS_BORDER_LAYOUT,
        textureKit = "Horde",
    },
    {
        name = "Mechagon",
        value = "nineslice:mechagon",
        layout = UNIQUE_CORNERS_BORDER_LAYOUT,
        textureKit = "Mechagon",
    },
    {
        name = "Marine",
        value = "nineslice:marine",
        layout = UNIQUE_CORNERS_BORDER_LAYOUT,
        textureKit = "Marine",
    },
    {
        name = "Plunderstorm",
        value = "nineslice:plunderstorm",
        layout = UNIQUE_CORNERS_BORDER_LAYOUT,
        textureKit = "plunderstorm",
    },
    {
        name = "Neutral Wood",
        value = "nineslice:neutral",
        layoutName = "WoodenNeutralFrameTemplate",
    },
    {
        name = "Text Panel",
        value = "nineslice:text-panel",
        layout = UNIQUE_CORNERS_BORDER_LAYOUT,
        textureKit = "TextPanel",
    },
    {
        name = "ActionBar Frame",
        value = "nineslice:ui-hud-actionbar-frame",
        layout = UNIQUE_CORNERS_BORDER_LAYOUT,
        textureKit = "UI-HUD-ActionBar-Frame",
    },
    {
        name = "ActionBar Symmetric",
        value = "nineslice:actionbar-symmetric",
        topAtlas = "_UI-HUD-ActionBar-Frame-Divider-Threeslice-Center",
        bottomAtlas = "_UI-HUD-ActionBar-Frame-Divider-Threeslice-Center",
    },
    {
        name = "Modern Diamond Metal",
        value = "nineslice:diamond-metal",
        topAtlas = "_UI-Frame-DiamondMetal-EdgeTop",
        bottomAtlas = "_UI-Frame-DiamondMetal-EdgeBottom",
    },
    {
        name = "Clean Metal",
        value = "nineslice:generic-metal-2",
        layout = UNIQUE_CORNERS_BORDER_LAYOUT,
        textureKit = "GenericMetal2",
    },
    {
        name = "Dirty Metal",
        value = "nineslice:generic-metal",
        layoutName = "GenericMetal",
    },
}

local function GetNineSliceAtlasName(atlas, textureKit)
    if textureKit then
        return atlas:format(textureKit)
    end

    return atlas
end

function RPGBB:GetNineSliceStyleLayout(style)
    if style.layout then
        return style.layout
    end

    return NineSliceLayouts and NineSliceLayouts[style.layoutName]
end

function RPGBB:GetHorizontalBorderAtlases(style)
    if style.topAtlas and style.bottomAtlas then
        return style.topAtlas, style.bottomAtlas
    end

    local layout = RPGBB:GetNineSliceStyleLayout(style)
    if not layout or not layout.TopEdge or not layout.BottomEdge then
        return
    end

    return GetNineSliceAtlasName(layout.TopEdge.atlas, style.textureKit),
        GetNineSliceAtlasName(layout.BottomEdge.atlas, style.textureKit)
end

function RPGBB:GetNineSliceBorderStyle(value)
    for _, style in ipairs(NINE_SLICE_BORDER_STYLES) do
        if style.value == value then
            return style
        end
    end
end

function RPGBB:GetAvailableNineSliceBorderStyles()
    return NINE_SLICE_BORDER_STYLES
end
