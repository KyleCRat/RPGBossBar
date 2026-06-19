local ADDON_NAME, RPGBB = ...

-------------------------------------------------------------------------------
--- Configuration Variables
-------------------------------------------------------------------------------

local addon_color = "ff46226a"

local testing = false
local verbose = false

--- Strata levels
local HEALTH_BAR_LEVEL   = 5
local FRAME_BORDER_LEVEL = 10
local SPARK_LEVEL        = 11
local POWER_BAR_LEVEL    = 3
local POWER_BORDER_LEVEL = 4
local GRAPHICS_LEVEL     = 15


-------------------------------------------------------------------------------
--- Init Health bar storage
-------------------------------------------------------------------------------

RPGBB.health_bars = {}
RPGBB.current_boss_frames = {}

local NINE_SLICE_PIECES = {
    "TopLeftCorner",
    "TopRightCorner",
    "BottomLeftCorner",
    "BottomRightCorner",
    "TopEdge",
    "BottomEdge",
    "LeftEdge",
    "RightEdge",
    "Center",
}

local UNIQUE_CORNERS_BORDER_LAYOUT = {
    TopRightCorner = { atlas = "%s-NineSlice-CornerTopRight" },
    TopLeftCorner = { atlas = "%s-NineSlice-CornerTopLeft" },
    BottomLeftCorner = { atlas = "%s-NineSlice-CornerBottomLeft" },
    BottomRightCorner = { atlas = "%s-NineSlice-CornerBottomRight" },
    TopEdge = { atlas = "_%s-NineSlice-EdgeTop" },
    BottomEdge = { atlas = "_%s-NineSlice-EdgeBottom" },
    LeftEdge = { atlas = "!%s-NineSlice-EdgeLeft" },
    RightEdge = { atlas = "!%s-NineSlice-EdgeRight" },
}

RPGBB.nine_slice_border_styles = {
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
        name = "ActionBar Frame",
        value = "nineslice:ui-hud-actionbar-frame",
        layout = UNIQUE_CORNERS_BORDER_LAYOUT,
        textureKit = "UI-HUD-ActionBar-Frame",
    },
    {
        name = "Modern Diamond Metal",
        value = "nineslice:diamond-metal",
        topAtlas = "_UI-Frame-DiamondMetal-EdgeTop",
        bottomAtlas = "_UI-Frame-DiamondMetal-EdgeBottom",
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
        name = "Clean Generic Metal",
        value = "nineslice:generic-metal-2",
        layout = UNIQUE_CORNERS_BORDER_LAYOUT,
        textureKit = "GenericMetal2",
    },
    {
        name = "Generic Metal",
        value = "nineslice:generic-metal",
        layoutName = "GenericMetal",
    },
}

local function GetNineSliceStyleLayout(style)
    if style.layout then
        return style.layout
    end

    return NineSliceLayouts and NineSliceLayouts[style.layoutName]
end

local function GetNineSliceAtlasName(atlas, textureKit)
    if textureKit then
        return atlas:format(textureKit)
    end

    return atlas
end

local function GetHorizontalBorderAtlases(style)
    if style.topAtlas and style.bottomAtlas then
        return style.topAtlas, style.bottomAtlas
    end

    local layout = GetNineSliceStyleLayout(style)
    if not layout or not layout.TopEdge or not layout.BottomEdge then
        return
    end

    return GetNineSliceAtlasName(layout.TopEdge.atlas, style.textureKit),
        GetNineSliceAtlasName(layout.BottomEdge.atlas, style.textureKit)
end

function RPGBB:GetNineSliceBorderStyle(value)
    for _, style in ipairs(RPGBB.nine_slice_border_styles) do
        if style.value == value then
            return style
        end
    end
end

function RPGBB:GetAvailableNineSliceBorderStyles()
    return RPGBB.nine_slice_border_styles
end

local function HideNineSliceBorder(frame)
    if not frame then
        return
    end

    for _, pieceName in ipairs(NINE_SLICE_PIECES) do
        if frame[pieceName] then
            frame[pieceName]:Hide()
        end
    end

    if frame.FullAtlas then
        frame.FullAtlas:Hide()
    end

    if frame.FullAtlasTopTiles then
        for _, texture in ipairs(frame.FullAtlasTopTiles) do
            texture:Hide()
        end
    end

    if frame.FullAtlasBottomTiles then
        for _, texture in ipairs(frame.FullAtlasBottomTiles) do
            texture:Hide()
        end
    end

    if frame.HorizontalTopEdge then
        frame.HorizontalTopEdge:Hide()
    end

    if frame.HorizontalBottomEdge then
        frame.HorizontalBottomEdge:Hide()
    end

    frame:Hide()
end

local function SetFullAtlasTileTexture(texture, atlasInfo, crop, visibleFraction)
    local textureAsset = atlasInfo.file or atlasInfo.filename
    if not textureAsset then
        return false
    end

    local atlasWidth = atlasInfo.rightTexCoord - atlasInfo.leftTexCoord
    local atlasHeight = atlasInfo.bottomTexCoord - atlasInfo.topTexCoord
    local left = atlasInfo.leftTexCoord + crop.left * atlasWidth
    local right = atlasInfo.leftTexCoord + crop.right * atlasWidth
    local top = atlasInfo.topTexCoord + crop.top * atlasHeight
    local bottom = atlasInfo.topTexCoord + crop.bottom * atlasHeight

    texture:SetTexture(textureAsset)
    texture:SetTexCoord(left, left + (right - left) * visibleFraction, top, bottom)

    return true
end

local function ShowFullAtlasEdgeTiles(frame, style, borderSize, r, g, b, a)
    local fullAtlas = style.fullAtlas
    local atlasInfo = C_Texture.GetAtlasInfo(fullAtlas.atlas)
    if not atlasInfo then
        return false
    end

    local sampleLeft = fullAtlas.sampleLeft or 0.25
    local sampleRight = fullAtlas.sampleRight or 0.75
    local topBottom = fullAtlas.topBottom or 0.10
    local bottomTop = fullAtlas.bottomTop or 0.90
    local sourceWidth = atlasInfo.width * (sampleRight - sampleLeft)
    local sourceHeight = atlasInfo.height * topBottom
    if sourceWidth <= 0 or sourceHeight <= 0 then
        return false
    end

    local tileWidth = borderSize * sourceWidth / sourceHeight
    local frameWidth = frame:GetWidth()
    local tileCount = math.ceil(frameWidth / tileWidth)

    frame.FullAtlasTopTiles = frame.FullAtlasTopTiles or {}
    frame.FullAtlasBottomTiles = frame.FullAtlasBottomTiles or {}

    local topCrop = {
        left = sampleLeft,
        right = sampleRight,
        top = 0,
        bottom = topBottom,
    }
    local bottomCrop = {
        left = sampleLeft,
        right = sampleRight,
        top = bottomTop,
        bottom = 1,
    }

    for i = 1, tileCount do
        local x = (i - 1) * tileWidth
        local width = math.min(tileWidth, frameWidth - x)
        local visibleFraction = width / tileWidth

        local topTexture = frame.FullAtlasTopTiles[i]
        if not topTexture then
            topTexture = frame:CreateTexture(nil, "BORDER")
            frame.FullAtlasTopTiles[i] = topTexture
        end

        topTexture:ClearAllPoints()
        topTexture:SetPoint("TOPLEFT", frame, "TOPLEFT", x, 0)
        topTexture:SetSize(width, borderSize)
        if not SetFullAtlasTileTexture(topTexture, atlasInfo, topCrop, visibleFraction) then
            return false
        end
        topTexture:SetVertexColor(r, g, b, a)
        topTexture:Show()

        local bottomTexture = frame.FullAtlasBottomTiles[i]
        if not bottomTexture then
            bottomTexture = frame:CreateTexture(nil, "BORDER")
            frame.FullAtlasBottomTiles[i] = bottomTexture
        end

        bottomTexture:ClearAllPoints()
        bottomTexture:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", x, 0)
        bottomTexture:SetSize(width, borderSize)
        if not SetFullAtlasTileTexture(bottomTexture, atlasInfo, bottomCrop, visibleFraction) then
            return false
        end
        bottomTexture:SetVertexColor(r, g, b, a)
        bottomTexture:Show()
    end

    frame:Show()

    return true
end

local function ShowModernBorder(frame, style, borderSize, r, g, b, a)
    HideNineSliceBorder(frame)

    if style.fullAtlas then
        ShowFullAtlasEdgeTiles(frame, style, borderSize, r, g, b, a)
        return
    end

    if not style.topAtlas then
        local layout = GetNineSliceStyleLayout(style)
        NineSliceUtil.ApplyLayout(frame, layout, style.textureKit)

        for _, pieceName in ipairs(NINE_SLICE_PIECES) do
            if frame[pieceName] then
                frame[pieceName]:Hide()
            end
        end

        frame.TopEdge:ClearAllPoints()
        frame.TopEdge:SetPoint("TOPLEFT", frame, "TOPLEFT")
        frame.TopEdge:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
        frame.TopEdge:SetHeight(borderSize)
        frame.TopEdge:SetVertexColor(r, g, b, a)
        frame.TopEdge:Show()

        frame.BottomEdge:ClearAllPoints()
        frame.BottomEdge:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT")
        frame.BottomEdge:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT")
        frame.BottomEdge:SetHeight(borderSize)
        frame.BottomEdge:SetVertexColor(r, g, b, a)
        frame.BottomEdge:Show()

        frame:Show()

        return
    end

    if not frame.HorizontalTopEdge then
        frame.HorizontalTopEdge = frame:CreateTexture(nil, "BORDER")
    end

    frame.HorizontalTopEdge:ClearAllPoints()
    frame.HorizontalTopEdge:SetPoint("TOPLEFT", frame, "TOPLEFT")
    frame.HorizontalTopEdge:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
    frame.HorizontalTopEdge:SetHeight(borderSize)

    if not frame.HorizontalBottomEdge then
        frame.HorizontalBottomEdge = frame:CreateTexture(nil, "BORDER")
    end

    frame.HorizontalBottomEdge:ClearAllPoints()
    frame.HorizontalBottomEdge:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT")
    frame.HorizontalBottomEdge:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT")
    frame.HorizontalBottomEdge:SetHeight(borderSize)

    local topAtlas, bottomAtlas = GetHorizontalBorderAtlases(style)

    frame.HorizontalTopEdge:SetAtlas(topAtlas, false, nil, true)
    frame.HorizontalTopEdge:ClearTextureSlice()

    frame.HorizontalBottomEdge:SetAtlas(bottomAtlas, false, nil, true)
    frame.HorizontalBottomEdge:ClearTextureSlice()

    frame.HorizontalTopEdge:SetVertexColor(r, g, b, a)
    frame.HorizontalBottomEdge:SetVertexColor(r, g, b, a)
    frame.HorizontalTopEdge:Show()
    frame.HorizontalBottomEdge:Show()

    frame:Show()
end


---------------------------------------------------------------------------
--- Main Frame / Container
---------------------------------------------------------------------------

RPGBB.frame = CreateFrame("Frame", "RPGBossBarFrame", UIParent)
RPGBB.frame:SetPoint("TOP", UIParent, "TOP", 0, -80)
RPGBB.frame:SetClampedToScreen(true)
RPGBB.frame:Hide()


-------------------------------------------------------------------------------
--- Functions
-------------------------------------------------------------------------------

function RPGBB:InitOrUpdateFrame()
    RPGBB:VPrint("InitOrUpdateFrame fired")

    local frame_height = RPGBB.db:Get("frame", "height")
    local frame_width  = RPGBB.db:Get("frame", "width")

    RPGBB.frame:ClearAllPoints()
    RPGBB.frame:SetPoint(RPGBB.db:Get("frame", "position", "point"),
                         UIParent,
                         RPGBB.db:Get("frame", "position", "relative_point"),
                         RPGBB.db:Get("frame", "position", "x"),
                         RPGBB.db:Get("frame", "position", "y"))
    RPGBB.frame:SetSize(frame_width, frame_height)

    -- Create container's background
    if not RPGBB.frame.bg then
        RPGBB.frame.bg = RPGBB.frame:CreateTexture(nil, "BACKGROUND")
        RPGBB.frame.bg:SetAllPoints(RPGBB.frame)
    end
    RPGBB.frame.bg:SetColorTexture(RPGBB.db:GetColor("frame", "background_color"))

    -- Create container's border
    local border_texture = RPGBB.db:Get("frame", "border", "texture")
    local border_r, border_g, border_b, border_a = RPGBB.db:GetColor("frame", "border", "color")
    local border_size = RPGBB.db:Get("frame", "border", "size")
    local border_offset = RPGBB.db:Get("frame", "border", "offset")
    local nine_slice_style = RPGBB:GetNineSliceBorderStyle(border_texture)

    -- Fall back cleanly if a profile references a style no longer in the
    -- curated list.
    if not nine_slice_style and type(border_texture) == "string"
        and border_texture:match("^nineslice:") then
        border_texture = RPGBB.db:GetDefault("frame", "border", "texture")
    end

    if not RPGBB.border then
        RPGBB.border = CreateFrame("Frame", "RPGBossBarBorder", RPGBB.frame, "BackdropTemplate")
        RPGBB.border:SetFrameLevel(RPGBB.frame:GetFrameLevel() + FRAME_BORDER_LEVEL)
    end

    if not RPGBB.nineSliceBorder then
        RPGBB.nineSliceBorder = CreateFrame("Frame", "RPGBossBarNineSliceBorder", RPGBB.frame)
        RPGBB.nineSliceBorder:SetFrameLevel(RPGBB.frame:GetFrameLevel() + FRAME_BORDER_LEVEL)
    end

    if nine_slice_style then
        RPGBB.border:Hide()

        RPGBB.nineSliceBorder:ClearAllPoints()
        RPGBB.nineSliceBorder:SetPoint("TOPLEFT", RPGBB.frame, "TOPLEFT", -border_offset, border_offset)
        RPGBB.nineSliceBorder:SetPoint("BOTTOMRIGHT", RPGBB.frame, "BOTTOMRIGHT", border_offset, -border_offset)
        ShowModernBorder(
            RPGBB.nineSliceBorder,
            nine_slice_style,
            border_size,
            border_r,
            border_g,
            border_b,
            border_a
        )
    else
        HideNineSliceBorder(RPGBB.nineSliceBorder)

        RPGBB.border:ClearAllPoints()
        RPGBB.border:SetPoint("TOPLEFT", RPGBB.frame, "TOPLEFT", -border_offset, border_offset)
        RPGBB.border:SetPoint("BOTTOMRIGHT", RPGBB.frame, "BOTTOMRIGHT", border_offset, -border_offset)
        RPGBB.border:SetBackdrop({
            edgeFile = border_texture or nil,
            edgeSize = border_size,
            insets = {
                left = 0,
                right = 0,
                top = 0,
                bottom = 0
            }
        })
        RPGBB.border:SetBackdropBorderColor(border_r, border_g, border_b, border_a)
        RPGBB.border:Show()
    end


    ---------------------------------------------------------------------------
    --- Accent Groups
    ---------------------------------------------------------------------------

    local left_accent_group = RPGBB.db:Get("accents", "left", "group")
    local right_accent_group = RPGBB.db:Get("accents", "right", "group")
    local accent_r, accent_g, accent_b, accent_a = RPGBB.db:GetColor("accents", "color")
    local accent_context = {
        parent = RPGBB.frame,
        anchor = RPGBB.frame,
        frame_height = frame_height,
        frame_level = RPGBB.frame:GetFrameLevel() + GRAPHICS_LEVEL,
        color = {
            r = accent_r,
            g = accent_g,
            b = accent_b,
            a = accent_a,
        },
    }

    accent_context.side = "left"
    accent_context.offset_x = RPGBB.db:Get("accents", "left", "offset", "x")
    accent_context.offset_y = RPGBB.db:Get("accents", "left", "offset", "y")
    RPGBB.leftAccentGroup = RPGBB:RenderAccentGroup(
        left_accent_group,
        RPGBB.leftAccentGroup,
        accent_context
    )

    accent_context.side = "right"
    accent_context.offset_x = RPGBB.db:Get("accents", "right", "offset", "x")
    accent_context.offset_y = RPGBB.db:Get("accents", "right", "offset", "y")
    RPGBB.rightAccentGroup = RPGBB:RenderAccentGroup(
        right_accent_group,
        RPGBB.rightAccentGroup,
        accent_context
    )


    ---------------------------------------------------------------------------
    --- Font
    ---------------------------------------------------------------------------

    local health_font = RPGBB.db:Get("health", "font", "font")
    local health_font_size = RPGBB.db:Get("health", "font", "size")

    RPGBB.health_font = CreateFont("RPGBossBarHealthFont")
    RPGBB.health_font:SetFont(health_font, health_font_size, "OUTLINE")
    RPGBB.health_font:SetTextColor(RPGBB.db:GetColor("health", "font", "color"))


    local name_font = RPGBB.db:Get("name", "font", "font")
    local name_font_size = RPGBB.db:Get("name", "font", "size")

    RPGBB.name_font = CreateFont("RPGBossBarNameFont")
    RPGBB.name_font:SetFont(name_font, name_font_size, "OUTLINE")
    RPGBB.name_font:SetTextColor(RPGBB.db:GetColor("name", "font", "color"))


    local power_font = RPGBB.db:Get("power", "font", "font")
    local power_font_size = RPGBB.db:Get("power", "font", "size")

    RPGBB.power_font = CreateFont("RPGBossBarPowerFont")
    RPGBB.power_font:SetFont(power_font, power_font_size, "OUTLINE")
    RPGBB.power_font:SetTextColor(RPGBB.db:GetColor("power", "font", "color"))

    --- Update Frames after changing Init Frame settings
    RPGBB:UpdateFrames()
end

function RPGBB:Print(msg)
    print("|c" .. addon_color .. ADDON_NAME .. ":|r " .. msg)
end

function RPGBB:VPrint(msg)
    if not verbose then return end

    print("|c" .. addon_color .. "RPGBB" .. ":|r " .. msg)
end

function RPGBB:Lock(locked)
    RPGBB:VPrint("Lock: " .. (locked and "true" or "false"))
    if locked then
        RPGBB.frame:Hide()

        if testing then
            RPGBB:ToggleTest()
        end
    else -- unlocked
        RPGBB.frame:Show()

        if not testing then
            RPGBB:ToggleTest(2)
        end
    end
end

function RPGBB:ToggleDebug()
    verbose = not verbose
    RPGBB:Print("debug turned " .. (verbose and "on" or "off"))
end

function RPGBB:ToggleTest(frame_count)
    local received_frame_count_arg = ((frame_count and true) or false)
    frame_count = tonumber(frame_count) or 2
    frame_count = math.max(1, math.min(5, frame_count)) -- Clamp between 1 and 5

    RPGBB:VPrint("ToggleTest: received_frame_count_arg " .. ((frame_count and "true") or "false"))
    RPGBB:VPrint("ToggleTest: frame_count: " .. frame_count .. " current_boss_frames_count " .. #RPGBB.current_boss_frames)

    -- Toggle test if:
    --   We are not testing: Show
    --   We are testing: if no frame_count passed
    --                   or frame_count is the same as current test: Hide
    if not testing or (not received_frame_count_arg
                        or #RPGBB.current_boss_frames == frame_count) then
        testing = not testing

        RPGBB:Print("testing turned " .. (testing and "on" or "off"))
    end

    if testing then
        local test_boss_frames = {}
        for i = 1, frame_count do
            table.insert(test_boss_frames, "boss" .. i)
        end

        RPGBB.current_boss_frames = test_boss_frames
        RPGBB:UpdateFrames()

        for _, boss_frame in ipairs(test_boss_frames) do
            local test_max_health = 214748364
            local test_health = math.random(1, test_max_health)
            local test_percent = (test_health / test_max_health) * 100
            local test_power_percent = math.random(0, 100)

            RPGBB:RenderHealthChanges(boss_frame, test_health, test_max_health, test_percent)
            RPGBB:RenderPowerChanges(boss_frame, test_power_percent)
        end

        RPGBB.current_boss_frames = test_boss_frames
        RPGBB.frame:Show()
    else
        RPGBB.current_boss_frames = {}
        RPGBB:UpdateFrames()
        RPGBB.frame:Hide()
    end
end

function RPGBB:UpdateHealth()
    for _, boss_frame in ipairs(RPGBB.current_boss_frames) do
        RPGBB:RenderHealthChanges(boss_frame)
    end
end

function RPGBB:UpdatePower()
    for _, boss_frame in ipairs(RPGBB.current_boss_frames) do
        RPGBB:RenderPowerChanges(boss_frame)
    end
end

function RPGBB:RenderHealthChanges(boss_frame, abs_health, max_health, per_health)
    local health_bar = RPGBB.health_bars[boss_frame]

    local abs_health = abs_health or UnitHealth(boss_frame)
    local max_health = max_health or UnitHealthMax(boss_frame)
    local per_health = per_health or UnitHealthPercent(boss_frame, true, CurveConstants.ScaleTo100) or 0

    if health_bar and health_bar.frame then
        -- Render frame values
        health_bar.frame:SetMinMaxValues(0, max_health)
        health_bar.frame:SetValue(abs_health)

        -- Render absolute health
        health_bar.health_text:SetText(BreakUpLargeNumbers(abs_health))

        -- Render percent health
        health_bar.percent_text:SetText(string.format("%.1f%%", per_health))

        -- make sure health frame is showing? shouldn't need.
        -- health_bar.frame:Show()
    end
end

function RPGBB:RenderPowerChanges(boss_frame, per_power)
    local health_bar = RPGBB.health_bars[boss_frame]
    if not health_bar or not health_bar.power_bar then
        return
    end

    local per_power = per_power or UnitPowerPercent(
        boss_frame,
        nil,
        false,
        CurveConstants.ScaleTo100
    ) or 0

    health_bar.power_bar:SetMinMaxValues(0, 100)
    health_bar.power_bar:SetValue(per_power)

    local power_text_format = RPGBB.db:Get("power", "font", "show_percent")
        and "%.0f%%"
        or "%.0f"
    health_bar.power_text:SetText(string.format(power_text_format, per_power))
end

function RPGBB:HaveBossFramesChanged(new_frames)
    local current = RPGBB.current_boss_frames

    if #current ~= #new_frames then
        return true
    end

    for i, frame in ipairs(new_frames) do
        if current[i] ~= frame then
            return true
        end
    end

    return false
end

-- Returns:
--   true if we have any boss frames we should be tracking and BossBar should be visible
--  false if we are not tracking boss frames and BossBar should be hidden
function RPGBB:IsBossFramesToUpdate()
    local boss_frames = {}

    -- 5 boss frames maximum
    for i = 1, 5 do
        local unit = "boss" .. i
        if UnitExists(unit) and (UnitClassification(unit) == "elite"
                                 or UnitClassification(unit) == "worldboss") then
            table.insert(boss_frames, unit)
        end
    end

    -- If there are no boss frames we don't have anything to render or update, hide
    if #boss_frames == 0 then
        RPGBB.frame:Hide()
        RPGBB.current_boss_frames = boss_frames
        return false
    end

    -- Otherwise we have at least one boss frame to update, show
    RPGBB.frame:Show()

    -- Only rebuild frames if boss frames have changed
    if not RPGBB:HaveBossFramesChanged(boss_frames) then
        return true
    end

    RPGBB.current_boss_frames = boss_frames
    RPGBB:UpdateFrames()

    return true
end

function RPGBB:UpdateFrames()
    local frame_height = RPGBB.db:Get("frame", "height")
    local frame_width  = RPGBB.db:Get("frame", "width")

    local boss_frame_count = #RPGBB.current_boss_frames
    local health_bar_width = frame_width / boss_frame_count

    -- Hide all visible elements for updating
    for _, bf in pairs(RPGBB.health_bars) do
        bf.frame:Hide()
        if bf.spark_frame then bf.spark_frame:Hide() end
        if bf.power_bar then bf.power_bar:Hide() end
        if bf.power_border then bf.power_border:Hide() end
        if bf.centerAccentGroup then RPGBB:HideAccentGroup(bf.centerAccentGroup) end
    end

    -- Get all db values before looping so we only get them once
    local health_bar_texture_is_atlas = RPGBB.db:Get("health", "texture", "atlas")
    local health_bar_texture          = RPGBB.db:Get("health", "texture", "texture")
    local health_bar_atlas_texture    = RPGBB.db:Get("health", "texture", "atlas_texture")
    local health_bar_desaturated      = RPGBB.db:Get("health", "texture", "desaturated")
    local hb_r, hb_b, hb_g, hb_a      = RPGBB.db:GetColor("health", "texture", "color")

    local health_font_offset_y = RPGBB.db:Get("health", "font", "offset", "y")
    local health_text_enabled  = RPGBB.db:Get("health", "font", "enabled")

    local spark_atlas            = RPGBB.db:Get("health", "spark", "atlas")
    local sp_r, sp_b, sp_g, sp_a = RPGBB.db:GetColor("health", "spark", "color")
    local spark_blend_mode       = RPGBB.db:Get("health", "spark", "blend_mode")
    local spark_width            = RPGBB.db:Get("health", "spark", "width")
    local spark_height_multi     = RPGBB.db:Get("health", "spark", "height_multi")

    local name_y_offset = RPGBB.db:Get("name", "offset", "y")
    local name_text_enabled = RPGBB.db:Get("name", "enabled")

    local health_percent_offset_x = RPGBB.db:Get("health", "percent_font", "offset", "x")
    local disable_per_above       = RPGBB.db:Get("health", "percent_font", "disable_above")
    local health_percent_enabled  = RPGBB.db:Get("health", "percent_font", "enabled")

    local power_bar_enabled       = RPGBB.db:Get("power", "enabled")
    local power_bar_percent_width = RPGBB.db:Get("power", "percent_width")
    local power_bar_height        = RPGBB.db:Get("power", "height")
    local power_bar_offset_y      = RPGBB.db:Get("power", "offset_y")
    local power_bar_texture       = RPGBB.db:Get("power", "texture")
    local power_bar_hide_above    = RPGBB.db:Get("power", "hide_above")
    local power_text_hide_above   = RPGBB.db:Get("power", "font", "hide_above")
    local power_text_enabled      = RPGBB.db:Get("power", "font", "enabled")
    local power_r, power_g, power_b, power_a = RPGBB.db:GetColor("power", "color")

    local power_border_texture = RPGBB.db:Get("power", "border", "texture")
    local power_border_enabled = power_border_texture and power_border_texture ~= ""
    local power_border_size    = RPGBB.db:Get("power", "border", "size")
    local power_border_offset  = RPGBB.db:Get("power", "border", "offset")
    local power_border_r, power_border_g, power_border_b, power_border_a =
        RPGBB.db:GetColor("power", "border", "color")

    local power_text_point          = RPGBB.db:Get("power", "font", "position", "point")
    local power_text_relative_point =
        RPGBB.db:Get("power", "font", "position", "relative_point")
    local power_text_x              = RPGBB.db:Get("power", "font", "position", "x")
    local power_text_y              = RPGBB.db:Get("power", "font", "position", "y")

    local center_accent_group = RPGBB.db:Get("accents", "center", "group")
    local ac_r, ac_g, ac_b, ac_a = RPGBB.db:GetColor("accents", "color")
    local accent_color = {
        r = ac_r,
        g = ac_g,
        b = ac_b,
        a = ac_a,
    }

    for i, boss_frame in ipairs(RPGBB.current_boss_frames) do
        RPGBB:VPrint("RPGBB: " .. boss_frame .. " i: " .. i)

        RPGBB.health_bars[boss_frame] = RPGBB.health_bars[boss_frame] or {}

        local y_left_offset = health_bar_width * (i - 1)

        -- Healthbar Frame
        if not RPGBB.health_bars[boss_frame].frame then
            RPGBB:VPrint(boss_frame .. " did not exist, creating.")
            RPGBB.health_bars[boss_frame].frame = CreateFrame("StatusBar", "RPG".. boss_frame .."BarHealthBar", RPGBB.frame)
            RPGBB.health_bars[boss_frame].frame:SetFrameLevel(RPGBB.frame:GetFrameLevel() + HEALTH_BAR_LEVEL)
        else
            RPGBB:VPrint(boss_frame .. " Already Existed.")
        end
        -- Update each time for setting changes
        if health_bar_texture_is_atlas then
            RPGBB.health_bars[boss_frame].frame:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
            RPGBB.health_bars[boss_frame].frame:GetStatusBarTexture():SetAtlas(health_bar_atlas_texture)
        else
            RPGBB.health_bars[boss_frame].frame:SetStatusBarTexture(health_bar_texture)
        end
        RPGBB.health_bars[boss_frame].frame:GetStatusBarTexture():SetDesaturated(health_bar_desaturated)
        RPGBB.health_bars[boss_frame].frame:SetStatusBarColor(hb_r, hb_b, hb_g, hb_a)
        -- Update each time for frame count changes
        RPGBB.health_bars[boss_frame].frame:ClearAllPoints()
        RPGBB.health_bars[boss_frame].frame:SetPoint("LEFT", RPGBB.frame, "LEFT", y_left_offset, 0)
        RPGBB.health_bars[boss_frame].frame:SetSize(health_bar_width, frame_height)
        RPGBB.health_bars[boss_frame].frame:Show()

        -- Healthbar Spark
        if not RPGBB.health_bars[boss_frame].spark_frame then
            RPGBB.health_bars[boss_frame].spark_frame = CreateFrame("Frame", nil, RPGBB.frame)
            RPGBB.health_bars[boss_frame].spark_frame:SetFrameLevel(RPGBB.frame:GetFrameLevel() + SPARK_LEVEL)
        end
        RPGBB.health_bars[boss_frame].spark_frame:ClearAllPoints()
        RPGBB.health_bars[boss_frame].spark_frame:SetAllPoints(RPGBB.health_bars[boss_frame].frame)
        RPGBB.health_bars[boss_frame].spark_frame:Show()

        if not RPGBB.health_bars[boss_frame].spark then
            RPGBB.health_bars[boss_frame].spark = RPGBB.health_bars[boss_frame].spark_frame:CreateTexture(nil, "OVERLAY")
            RPGBB.health_bars[boss_frame].spark:SetPoint("CENTER", RPGBB.health_bars[boss_frame].frame:GetStatusBarTexture(), "RIGHT", 0, 0)
        end
        -- Update each time for setting changes
        RPGBB.health_bars[boss_frame].spark:SetAtlas(spark_atlas)
        RPGBB.health_bars[boss_frame].spark:SetVertexColor(sp_r, sp_b, sp_g, sp_a)
        RPGBB.health_bars[boss_frame].spark:SetBlendMode(spark_blend_mode)
        RPGBB.health_bars[boss_frame].spark:SetSize(spark_width, frame_height * spark_height_multi)

        -- Healthbar absolute value health text
        if not RPGBB.health_bars[boss_frame].health_text then
            RPGBB.health_bars[boss_frame].health_text = RPGBB.health_bars[boss_frame].frame:CreateFontString(nil, "OVERLAY")
        end
        -- Update each time for setting changes
        RPGBB.health_bars[boss_frame].health_text:SetPoint("CENTER", RPGBB.health_bars[boss_frame].frame, "CENTER", 0, health_font_offset_y)
        RPGBB.health_bars[boss_frame].health_text:SetFontObject(RPGBB.health_font)
        RPGBB.health_bars[boss_frame].health_text:SetShown(health_text_enabled)

        -- Healthbar percentage text (right side of bar)
        if not RPGBB.health_bars[boss_frame].percent_text then
            RPGBB.health_bars[boss_frame].percent_text = RPGBB.health_bars[boss_frame].frame:CreateFontString(nil, "OVERLAY")
        end
        RPGBB.health_bars[boss_frame].percent_text:SetPoint("RIGHT", RPGBB.health_bars[boss_frame].frame, "RIGHT", health_percent_offset_x, health_font_offset_y)
        RPGBB.health_bars[boss_frame].percent_text:SetFontObject(RPGBB.health_font)

        -- Healthbar name text (above frame)
        if not RPGBB.health_bars[boss_frame].name_text then
            RPGBB.health_bars[boss_frame].name_text = RPGBB.health_bars[boss_frame].frame:CreateFontString(nil, "OVERLAY")
            RPGBB.health_bars[boss_frame].name_text:SetWordWrap(false)
        end
        RPGBB.health_bars[boss_frame].name_text:SetPoint("BOTTOM", RPGBB.health_bars[boss_frame].frame, "TOP", 0, name_y_offset)
        RPGBB.health_bars[boss_frame].name_text:SetFontObject(RPGBB.name_font)
        RPGBB.health_bars[boss_frame].name_text:SetWidth(health_bar_width)
        RPGBB.health_bars[boss_frame].name_text:SetText(UnitName(boss_frame) or "Test Boss " .. boss_frame:match("%d+"))
        RPGBB.health_bars[boss_frame].name_text:SetShown(name_text_enabled)

        -- Hide percentage if more than 2 bosses exist
        if not health_percent_enabled or boss_frame_count > disable_per_above then
            RPGBB.health_bars[boss_frame].percent_text:Hide()
        else
            RPGBB.health_bars[boss_frame].percent_text:Show()
        end

        -- Power bar centered beneath its health bar.
        if not RPGBB.health_bars[boss_frame].power_bar then
            local power_bar = CreateFrame(
                "StatusBar",
                "RPG" .. boss_frame .. "BarPowerBar",
                RPGBB.frame
            )
            power_bar:SetFrameLevel(RPGBB.frame:GetFrameLevel() + POWER_BAR_LEVEL)

            local background = power_bar:CreateTexture(nil, "BACKGROUND")
            background:SetAllPoints(power_bar)

            local power_text = power_bar:CreateFontString(nil, "OVERLAY")
            power_text:SetPoint("CENTER", power_bar, "CENTER")

            RPGBB.health_bars[boss_frame].power_bar = power_bar
            RPGBB.health_bars[boss_frame].power_background = background
            RPGBB.health_bars[boss_frame].power_text = power_text
        end

        if not RPGBB.health_bars[boss_frame].power_border then
            local power_border = CreateFrame(
                "Frame",
                "RPG" .. boss_frame .. "BarPowerBorder",
                RPGBB.frame,
                "BackdropTemplate"
            )
            power_border:SetFrameLevel(RPGBB.frame:GetFrameLevel() + POWER_BORDER_LEVEL)
            RPGBB.health_bars[boss_frame].power_border = power_border
        end

        local power_bar = RPGBB.health_bars[boss_frame].power_bar
        local power_background = RPGBB.health_bars[boss_frame].power_background
        local power_border = RPGBB.health_bars[boss_frame].power_border
        local power_text = RPGBB.health_bars[boss_frame].power_text

        power_bar:ClearAllPoints()
        power_bar:SetPoint(
            "TOP",
            RPGBB.health_bars[boss_frame].frame,
            "BOTTOM",
            0,
            power_bar_offset_y
        )
        power_bar:SetSize(health_bar_width * (power_bar_percent_width / 100), power_bar_height)
        power_bar:SetStatusBarTexture(power_bar_texture)
        power_bar:SetStatusBarColor(power_r, power_g, power_b, power_a)

        power_background:SetTexture(power_bar_texture)
        power_background:SetVertexColor(0.08, 0.08, 0.08, 0.9)

        power_border:ClearAllPoints()
        power_border:SetPoint(
            "TOPLEFT",
            power_bar,
            "TOPLEFT",
            -power_border_offset,
            power_border_offset
        )
        power_border:SetPoint(
            "BOTTOMRIGHT",
            power_bar,
            "BOTTOMRIGHT",
            power_border_offset,
            -power_border_offset
        )
        power_border:SetBackdrop({
            edgeFile = power_border_enabled and power_border_texture or nil,
            edgeSize = power_border_size,
            insets = {
                left = 0,
                right = 0,
                top = 0,
                bottom = 0,
            },
        })
        power_border:SetBackdropBorderColor(
            power_border_r,
            power_border_g,
            power_border_b,
            power_border_a
        )

        power_text:ClearAllPoints()
        power_text:SetPoint(
            power_text_point,
            power_bar,
            power_text_relative_point,
            power_text_x,
            power_text_y
        )
        power_text:SetFontObject(RPGBB.power_font)
        power_text:SetShown(power_text_enabled and boss_frame_count <= power_text_hide_above)

        if power_bar_enabled and boss_frame_count <= power_bar_hide_above then
            power_bar:Show()
            power_border:SetShown(power_border_enabled)
            RPGBB:RenderPowerChanges(boss_frame, testing and 65 or nil)
        else
            power_bar:Hide()
            power_border:Hide()
        end

        -- Don't create extra divider graphic elements
        if i == boss_frame_count then break end

        RPGBB.health_bars[boss_frame].centerAccentGroup = RPGBB:RenderAccentGroup(
            center_accent_group,
            RPGBB.health_bars[boss_frame].centerAccentGroup,
            {
                parent = RPGBB.health_bars[boss_frame].frame,
                anchor = RPGBB.health_bars[boss_frame].frame,
                side = "center",
                offset_x = RPGBB.db:Get("accents", "center", "offset", "x"),
                offset_y = RPGBB.db:Get("accents", "center", "offset", "y"),
                frame_height = frame_height,
                frame_level = RPGBB.health_bars[boss_frame].frame:GetFrameLevel() + GRAPHICS_LEVEL,
                color = accent_color,
                width_multiplier = 0.7,
            }
        )
    end
end

-------------------------------------------------------------------------------
--- Event Handling
-------------------------------------------------------------------------------

local function EventHandler(self, event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 == ADDON_NAME then
            RPGBB.InitializeDB()
            RPGBB:InitOrUpdateFrame()
            RPGBB.RegisterProfileSettings()

            RPGBB.frame:UnregisterEvent("ADDON_LOADED")

            -- Register boss health events for all 5 possible boss units
            RPGBB.frame:RegisterUnitEvent("UNIT_HEALTH", "boss1", "boss2", "boss3", "boss4", "boss5")
            RPGBB.frame:RegisterUnitEvent("UNIT_MAXHEALTH", "boss1", "boss2", "boss3", "boss4", "boss5")
            RPGBB.frame:RegisterUnitEvent("UNIT_POWER_UPDATE", "boss1", "boss2", "boss3", "boss4", "boss5")
            RPGBB.frame:RegisterUnitEvent("UNIT_MAXPOWER", "boss1", "boss2", "boss3", "boss4", "boss5")
            RPGBB.frame:RegisterUnitEvent("UNIT_DISPLAYPOWER", "boss1", "boss2", "boss3", "boss4", "boss5")
            RPGBB.frame:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
            RPGBB.frame:RegisterEvent("PLAYER_REGEN_ENABLED")

            RPGBB:Print("Loaded. Use " .. SLASH_RPGBOSSBAR1 .. " for commands.")
        end

    elseif event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" then
        -- If we are currently tracking a boss frame
        if RPGBB:IsBossFramesToUpdate() then
            -- Update health if this boss is being tracked
            if RPGBB.health_bars[arg1] then
                RPGBB:UpdateHealth()
            end
        end
    elseif event == "UNIT_POWER_UPDATE" or event == "UNIT_MAXPOWER" or event == "UNIT_DISPLAYPOWER" then
        if RPGBB:IsBossFramesToUpdate() and RPGBB.health_bars[arg1] then
            RPGBB:RenderPowerChanges(arg1)
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        -- Exited combat
        RPGBB.frame:Hide()
    elseif event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT" then
        if RPGBB:IsBossFramesToUpdate() then
            RPGBB:UpdateHealth()
            RPGBB:UpdatePower()
        end
    end
end

-- Register events
RPGBB.frame:RegisterEvent("ADDON_LOADED")

RPGBB.frame:SetScript("OnEvent", EventHandler)
