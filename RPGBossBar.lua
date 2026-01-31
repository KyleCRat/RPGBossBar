local ADDON_NAME, RPGBB = ...
ADDON_ABVR = "RPGBB"

-------------------------------------------------------------------------------
--- Configuration Variables
-------------------------------------------------------------------------------

local addon_color = "ffffff77"

local bar_width = 800
local bar_height = 38
local font_size = 32

-- Available bar textures (atlas names) for future theme selection
local BAR_TEXTURES = {
    ["Blizzard Insanity"]    = "Unit_Priest_Insanity_Fill",
    ["Blizzard Pain"]        = "_DemonHunter-DemonicPainBar",
    ["Blizzard Maelstrom"]   = "Unit_Shaman_Maelstrom_Fill",
    ["Blizzard Ebon Might"]  = "Unit_Evoker_EbonMight_Fill",
    ["Blizzard Lunar Power"] = "Unit_Druid_AstralPower_Fill",
    ["Blizzard Fury"]        = "Unit_DemonHunter_Fury_Fill",
    ["Blizzard Runic Power"] = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-RunicPower",
    ["Blizzard Rage"]        = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Rage",
    ["Blizzard Mana"]        = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Mana",
    ["Blizzard Focus"]       = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Focus",
    ["Blizzard Energy"]      = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Energy",
}

local DEV_MODE = true -- TODO: Set to false when done developing

local testing = false
local verbose = false

--- Strata levels
local FRAME_BORDER_LEVEL = 5
local HEALTH_BAR_LEVEL   = 10
local GRAPHICS_LEVEL     = 15


-------------------------------------------------------------------------------
--- Initialization
---
--- Main Frame / Container
-------------------------------------------------------------------------------

RPGBB.frame = CreateFrame("Frame", "RPGBossBarFrame", UIParent)
RPGBB.frame:SetSize(bar_width, bar_height)
RPGBB.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
RPGBB.frame:SetMovable(true)
RPGBB.frame:SetClampedToScreen(true)
RPGBB.frame:Show() -- TODO: Change back to Hide() when done developing

-- Create container's background
RPGBB.frame.bg = RPGBB.frame:CreateTexture(nil, "BACKGROUND")
RPGBB.frame.bg:SetAllPoints(RPGBB.frame)
RPGBB.frame.bg:SetColorTexture(0, 0, 0, 0.8)

-- Create container's frame
local border_offset = 6
local border_size = 18
RPGBB.border = CreateFrame("Frame", "RPGBossBarBorder", RPGBB.frame, "BackdropTemplate")
RPGBB.border:ClearAllPoints()
RPGBB.border:SetPoint("TOPLEFT", RPGBB.frame, "TOPLEFT", -border_offset, border_offset)
RPGBB.border:SetPoint("BOTTOMRIGHT", RPGBB.frame, "BOTTOMRIGHT", border_offset, -border_offset)
RPGBB.border:SetFrameLevel(RPGBB.frame:GetFrameLevel() + FRAME_BORDER_LEVEL)
RPGBB.border:SetBackdrop({
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    edgeSize = border_size,
    insets = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0
    }
})
RPGBB.border:SetBackdropBorderColor(1, 1, 1, 1)

-- Create mover handle (shown when unlocked)
RPGBB.frame.handle = RPGBB.frame:CreateTexture(nil, "OVERLAY")
RPGBB.frame.handle:SetSize(16, 16)
RPGBB.frame.handle:SetPoint("RIGHT", RPGBB.frame, "LEFT", -4, 0)
RPGBB.frame.handle:SetTexture("Interface\\CURSOR\\UI-Cursor-Move")
RPGBB.frame.handle:SetVertexColor(1, 1, 1, 0.8)

-- Make the container draggable
RPGBB.frame:EnableMouse(true)
RPGBB.frame:RegisterForDrag("LeftButton")
RPGBB.frame:SetScript("OnDragStart", RPGBB.frame.StartMoving)
RPGBB.frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    -- Save position
    local point, _, relativePoint, x, y = self:GetPoint()
    RPGBossBarDB.position = { point = point, relativePoint = relativePoint, x = x, y = y }
end)


-------------------------------------------------------------------------------
--- Graphic Elements
-------------------------------------------------------------------------------

local graphic_height_mult = 1.8

-- Foreground size
local fg_width_to_height_ratio = 44.5 / 62.5

local fg_h = bar_height * graphic_height_mult
local fg_w = fg_h * fg_width_to_height_ratio

-- Background size
local bg_to_fg_ratio           = 50 / 62.5
local bg_width_to_height_ratio = 36 / 50

local bg_h = fg_h * bg_to_fg_ratio
local bg_w = bg_h * bg_width_to_height_ratio

-- Accent Size
local ac_to_fg_ratio           = 75.5 / 62.5
local ac_width_to_height_ratio = 58.5 / 75.5

local ac_h = fg_h * ac_to_fg_ratio
local ac_w = ac_h * ac_width_to_height_ratio

--- Left - Anchored to Container
-- Create overlay frame for left graphics (sits on top of health bar)
RPGBB.leftGraphicFrame = CreateFrame("Frame", "RPGBossBarLeftGraphic", RPGBB.frame)
RPGBB.leftGraphicFrame:SetAllPoints(RPGBB.frame)
RPGBB.leftGraphicFrame:SetFrameLevel(RPGBB.frame:GetFrameLevel() + GRAPHICS_LEVEL)

-- Left Graphic Background (behind foreground)
RPGBB.leftGraphicBg = RPGBB.leftGraphicFrame:CreateTexture(nil, "ARTWORK", nil, 1)
RPGBB.leftGraphicBg:SetAtlas("dragonriding_sgvigor_fillfull")
RPGBB.leftGraphicBg:SetSize(bg_w, bg_h)
RPGBB.leftGraphicBg:SetVertexColor(0x46/255, 0x22/255, 0x6a/255, 1) -- #46226a
RPGBB.leftGraphicBg:SetDesaturated(true)

-- Left Graphic Foreground (the frame)
RPGBB.leftGraphicFg = RPGBB.leftGraphicFrame:CreateTexture(nil, "ARTWORK", nil, 2)
RPGBB.leftGraphicFg:SetAtlas("dragonriding_sgvigor_frame_dark")
RPGBB.leftGraphicFg:SetSize(fg_w, fg_h)
RPGBB.leftGraphicFg:SetPoint("CENTER", RPGBB.frame, "LEFT", -2, 0)

-- Anchor background to foreground center
RPGBB.leftGraphicBg:SetPoint("CENTER", RPGBB.leftGraphicFg, "CENTER", 0, 0)

-- Left Graphic Accent (decorative element)
RPGBB.leftGraphicAccent = RPGBB.leftGraphicFrame:CreateTexture(nil, "ARTWORK", nil, 3)
RPGBB.leftGraphicAccent:SetAtlas("dragonriding_sgvigor_decor_dark")
RPGBB.leftGraphicAccent:SetSize(ac_w, ac_h)
RPGBB.leftGraphicAccent:SetTexCoord(1, 0, 0, 1) -- Mirror horizontally
RPGBB.leftGraphicAccent:SetPoint("RIGHT", RPGBB.leftGraphicFg, "LEFT", ac_w * 0.325, ac_h * 0.075)


--- Right - Anchored to Container
-- Create overlay frame for right graphics (sits on top of health bar)
RPGBB.rightGraphicFrame = CreateFrame("Frame", "RPGBossBarRightGraphic", RPGBB.frame)
RPGBB.rightGraphicFrame:SetAllPoints(RPGBB.frame)
RPGBB.rightGraphicFrame:SetFrameLevel(RPGBB.frame:GetFrameLevel() + GRAPHICS_LEVEL)

-- Right Graphic Background (behind foreground)
RPGBB.rightGraphicBg = RPGBB.rightGraphicFrame:CreateTexture(nil, "ARTWORK", nil, 1)
RPGBB.rightGraphicBg:SetAtlas("dragonriding_sgvigor_fillfull")
RPGBB.rightGraphicBg:SetSize(bg_w, bg_h)
RPGBB.rightGraphicBg:SetVertexColor(0x46/255, 0x22/255, 0x6a/255, 1) -- #46226a
RPGBB.rightGraphicBg:SetDesaturated(true)

-- Right Graphic Foreground (the frame)
RPGBB.rightGraphicFg = RPGBB.rightGraphicFrame:CreateTexture(nil, "ARTWORK", nil, 2)
RPGBB.rightGraphicFg:SetAtlas("dragonriding_sgvigor_frame_dark")
RPGBB.rightGraphicFg:SetSize(fg_w, fg_h)
RPGBB.rightGraphicFg:SetPoint("CENTER", RPGBB.frame, "RIGHT", 2, 0)

-- Anchor background to foreground center
RPGBB.rightGraphicBg:SetPoint("CENTER", RPGBB.rightGraphicFg, "CENTER", 0, 0)

-- Right Graphic Accent (decorative element)
RPGBB.rightGraphicAccent = RPGBB.rightGraphicFrame:CreateTexture(nil, "ARTWORK", nil, 3)
RPGBB.rightGraphicAccent:SetAtlas("dragonriding_sgvigor_decor_dark")
RPGBB.rightGraphicAccent:SetSize(ac_w, ac_h)
RPGBB.rightGraphicAccent:SetPoint("LEFT", RPGBB.rightGraphicFg, "RIGHT", -ac_w * 0.325, ac_h * 0.075)


-------------------------------------------------------------------------------
--- Font
-------------------------------------------------------------------------------

local FONT = "Interface\\AddOns\\RPGBossBar\\media\\fonts\\PTSansNarrow-Bold.ttf"

RPGBB.healthFont = CreateFont("RPGBossBarHealthFont")
RPGBB.healthFont:SetFont(FONT, font_size, "OUTLINE")
RPGBB.healthFont:SetTextColor(1, 1, 1, 1)


-------------------------------------------------------------------------------
--- Init Health bar storage
-------------------------------------------------------------------------------

RPGBB.health_bars = {}
RPGBB.current_boss_frames = {}


-------------------------------------------------------------------------------
--- Functions
-------------------------------------------------------------------------------

function RPGBB:Print(msg)
    print("|c" .. addon_color .. ADDON_NAME .. ":|r " .. msg)
end

function RPGBB:VPrint(msg)
    if not verbose then return end

    print("|c" .. addon_color .. ADDON_ABVR .. ":|r " .. msg)
end

function RPGBB:ToggleLock()
    RPGBossBarDB.locked = not RPGBossBarDB.locked
    RPGBB:Lock(RPGBossBarDB.locked)
    RPGBB:Print("Frame " .. (RPGBossBarDB.locked and "L" or "Unl") .. "ocked")
end

function RPGBB:Lock(locked)
    if locked then
        RPGBB.frame.handle:Hide()
        RPGBB.frame:EnableMouse(false)
    else
        RPGBB.frame.handle:Show()
        RPGBB.frame:EnableMouse(true)
    end
end

function RPGBB:ToggleDebug()
    verbose = not verbose
    RPGBB:Print("debug turned " .. (verbose and "on" or "off"))
end

function RPGBB:ToggleTest()
    testing = not testing
    RPGBB:Print("testing turned " .. (testing and "on" or "off"))

    if testing then
        RPGBB.frame:Show()
        RPGBB.healthBar:SetMinMaxValues(0, 100)
        RPGBB.healthBar:SetValue(75)
        RPGBB.healthText:SetText("75,000,000 / 100,000,000")
    else
        if not UnitExists("boss1") then
            RPGBB.frame:Hide()
        end
    end
end

function RPGBB:UpdateHealth()
    if not UnitExists("boss1") then
        RPGBB.frame:Hide()
        return
    end

    local secret_health = UnitHealth("boss1")
    local secret_max_health = UnitHealthMax("boss1")

    RPGBB.healthBar:SetMinMaxValues(0, secret_max_health)
    RPGBB.healthBar:SetValue(secret_health)
    RPGBB.healthText:SetText(secret_health)
    RPGBB.frame:Show()
end

function RPGBB:DetectBossCount()
    local boss_frames = {}

    -- 5 boss frames
    for i = 1, 5 do
        local unit = "boss" .. i
        if UnitExists(unit) and UnitClassification(unit) == "worldboss" then
            table.insert(boss_frames, unit)
        end
    end

    boss_frames = { "boss1", "boss3" } -- TODO: Remove

    -- if RPGBB.current_boss_frames ~= boss_frames we need to update frames
    RPGBB:UpdateFrames(boss_frames)
end

function RPGBB:UpdateFrames(boss_frames)
    local boss_frame_count = #boss_frames
    local health_bar_width = bar_width / boss_frame_count

    for _, bf in pairs(RPGBB.health_bars) do
        -- Hide and clear points of any existing health bars
        bf.frame:Hide()
        bf.frame:ClearAllPoints()
    end

    for i, boss_frame in pairs(boss_frames) do
        print("RPGBB: " .. boss_frame)

        RPGBB.health_bars[boss_frame] = RPGBB.health_bars[boss_frame] or {}

        --- Health Bar
        y_left_offset = health_bar_width * (i - 1)

        RPGBB.health_bars[boss_frame].frame = RPGBB.health_bars[boss_frame].frame or
                                              CreateFrame("StatusBar", "RPG".. boss_frame .."BarHealthBar", RPGBB.frame)
        RPGBB.health_bars[boss_frame].frame:ClearAllPoints()
        RPGBB.health_bars[boss_frame].frame:SetPoint("LEFT", RPGBB.frame, "LEFT", y_left_offset, 0)
        RPGBB.health_bars[boss_frame].frame:SetSize(health_bar_width, bar_height)
        RPGBB.health_bars[boss_frame].frame:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
        RPGBB.health_bars[boss_frame].frame:GetStatusBarTexture():SetAtlas("Unit_Priest_Insanity_Fill")
        RPGBB.health_bars[boss_frame].frame:SetStatusBarColor(1, 1, 1, 1) -- White to show atlas texture colors
        RPGBB.health_bars[boss_frame].frame:SetFrameLevel(RPGBB.frame:GetFrameLevel() + HEALTH_BAR_LEVEL)

        -- Create spark texture
        if not RPGBB.health_bars[boss_frame].spark then
            RPGBB.health_bars[boss_frame].spark = RPGBB.health_bars[boss_frame].frame:CreateTexture(nil, "OVERLAY")
            RPGBB.health_bars[boss_frame].spark:SetAtlas("Insanity-Spark")
            RPGBB.health_bars[boss_frame].spark:SetVertexColor(0x46/255, 0x22/255, 0x6a/255, 1) -- #46226a
            RPGBB.health_bars[boss_frame].spark:SetBlendMode("ADD")
            RPGBB.health_bars[boss_frame].spark:SetSize(4, bar_height * 1.5)
        end

        -- Position at the current value of the status bar
        RPGBB.health_bars[boss_frame].spark:SetPoint("CENTER", RPGBB.health_bars[boss_frame].frame:GetStatusBarTexture(), "RIGHT", 0, 0)

        -- Create health text (centered on the bar)
        RPGBB.health_bars[boss_frame].health_text = RPGBB.health_bars[boss_frame].frame:CreateFontString(nil, "OVERLAY")
        RPGBB.health_bars[boss_frame].health_text:SetFontObject(RPGBB.healthFont)
        RPGBB.health_bars[boss_frame].health_text:SetPoint("CENTER", RPGBB.health_bars[boss_frame].frame, "CENTER", 0, -1)

        -- TODO: Remove test values when done developing
        local test_health = math.random(1, 214748364)
        RPGBB.health_bars[boss_frame].frame:SetMinMaxValues(0, 214748364)
        RPGBB.health_bars[boss_frame].frame:SetValue(test_health)
        RPGBB.health_bars[boss_frame].health_text:SetText(test_health)

        -- Don't create extra divider graphic elements
        if i == boss_frame_count then break end

        -------------------------------------------------------------------------------
        --- Middle Graphic Elements, create and attach on the right of all but n-1 bar
        -------------------------------------------------------------------------------

        local middle_graphic_width_mult = 0.7
        -- Create overlay frame for left graphics (sits on top of health bar)
        RPGBB.health_bars[boss_frame].mid_graphic_frame = CreateFrame("Frame", "RPGBossBarLeftGraphic", RPGBB.health_bars[boss_frame].frame)
        RPGBB.health_bars[boss_frame].mid_graphic_frame:SetAllPoints(RPGBB.health_bars[boss_frame].frame)
        RPGBB.health_bars[boss_frame].mid_graphic_frame:SetFrameLevel(RPGBB.health_bars[boss_frame].frame:GetFrameLevel() + GRAPHICS_LEVEL)

        -- Left Graphic Background (behind foreground)
        RPGBB.health_bars[boss_frame].mid_graphic_bg = RPGBB.health_bars[boss_frame].mid_graphic_frame:CreateTexture(nil, "ARTWORK", nil, 1)
        RPGBB.health_bars[boss_frame].mid_graphic_bg:SetAtlas("dragonriding_sgvigor_fillfull")
        RPGBB.health_bars[boss_frame].mid_graphic_bg:SetSize(bg_w * middle_graphic_width_mult, bg_h)
        RPGBB.health_bars[boss_frame].mid_graphic_bg:SetVertexColor(0x46/255, 0x22/255, 0x6a/255, 1) -- #46226a
        RPGBB.health_bars[boss_frame].mid_graphic_bg:SetDesaturated(true)

        -- Left Graphic Foreground (the frame)
        RPGBB.health_bars[boss_frame].mid_graphic_fg = RPGBB.health_bars[boss_frame].mid_graphic_frame:CreateTexture(nil, "ARTWORK", nil, 2)
        RPGBB.health_bars[boss_frame].mid_graphic_fg:SetAtlas("dragonriding_sgvigor_frame_dark")
        RPGBB.health_bars[boss_frame].mid_graphic_fg:SetSize(fg_w * middle_graphic_width_mult, fg_h)
        RPGBB.health_bars[boss_frame].mid_graphic_fg:SetPoint("CENTER", RPGBB.health_bars[boss_frame].frame, "RIGHT", 0, 0)

        -- Anchor background to foreground center
        RPGBB.health_bars[boss_frame].mid_graphic_bg:SetPoint("CENTER", RPGBB.health_bars[boss_frame].mid_graphic_fg, "CENTER", 0, 0)
    end
end

-------------------------------------------------------------------------------
--- Event Handling
-------------------------------------------------------------------------------

local function EventHandler(self, event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 == ADDON_NAME then
            if not RPGBossBarDB then
                RPGBB:Print("RPGBossBarDB not available, creating.")
                RPGBossBarDB = {
                    locked = true,
                    position = nil
                }
            end

            -- Restore position if saved
            if RPGBossBarDB.position then
                local pos = RPGBossBarDB.position
                RPGBB.frame:ClearAllPoints()
                RPGBB.frame:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y)
            end

            RPGBB:Lock(RPGBossBarDB.locked)

            RPGBB.frame:UnregisterEvent("ADDON_LOADED")

            -- Register boss health events
            RPGBB.frame:RegisterUnitEvent("UNIT_HEALTH", "boss1")
            RPGBB.frame:RegisterUnitEvent("UNIT_MAXHEALTH", "boss1")
            RPGBB.frame:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
            RPGBB.frame:RegisterEvent("PLAYER_ENTERING_WORLD")

            RPGBB:DetectBossCount()

            RPGBB:Print("Loaded. Use " .. SLASH_RPGBOSSBAR1 .. " for commands.")
        end

    elseif event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" then
        if arg1 == "boss1" then
            RPGBB:UpdateHealth()
        end

    elseif event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT" or event == "PLAYER_ENTERING_WORLD" then
        if UnitExists("boss1") then
            RPGBB:UpdateHealth()
        else
            if not testing and not DEV_MODE then
                RPGBB.frame:Hide()
            end
        end
    end
end

-- Register events
RPGBB.frame:RegisterEvent("ADDON_LOADED")

RPGBB.frame:SetScript("OnEvent", EventHandler)
