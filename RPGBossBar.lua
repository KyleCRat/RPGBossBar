local ADDON_NAME, RPGBB = ...
ADDON_ABVR = "RPGBB"


-------------------------------------------------------------------------------
--- Configuration Variables
-------------------------------------------------------------------------------

local addon_color = "ffff2277"

local bar_width = 1000
local bar_height = 38
local font_size = 24

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

local testing = false
local verbose = false

--- Strata levels
local FRAME_BORDER_LEVEL = 5
local HEALTH_BAR_LEVEL   = 10
local GRAPHICS_LEVEL     = 15


-------------------------------------------------------------------------------
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

-------------------------------------------------------------------------------
--- Mover Handle
-------------------------------------------------------------------------------

-- Create mover handle frame (shown when unlocked)
RPGBB.frame.handle = CreateFrame("Frame", "RPGBossBarHandle", RPGBB.frame)
RPGBB.frame.handle:SetSize(32, 32)
RPGBB.frame.handle:SetPoint("TOP", RPGBB.frame, "BOTTOM", 0, -8)

-- Mover handle icon
RPGBB.frame.handle.icon = RPGBB.frame.handle:CreateTexture(nil, "OVERLAY")
RPGBB.frame.handle.icon:SetAllPoints()
RPGBB.frame.handle.icon:SetTexture("Interface\\CURSOR\\UI-Cursor-Move")
RPGBB.frame.handle.icon:SetVertexColor(1, 1, 1, 0.8)

-- Mover handle background
RPGBB.frame.handle.bg = RPGBB.frame.handle:CreateTexture(nil, "BACKGROUND")
RPGBB.frame.handle.bg:SetAllPoints()
RPGBB.frame.handle.bg:SetColorTexture(0, 0, 0, 0.8)

-- Make the handle draggable (moves the main frame)
RPGBB.frame.handle:EnableMouse(true)
RPGBB.frame.handle:RegisterForDrag("LeftButton")
RPGBB.frame.handle:SetScript("OnDragStart", function()
    RPGBB.frame:StartMoving()
end)

RPGBB.frame.handle:SetScript("OnDragStop", function()
    RPGBB.frame:StopMovingOrSizing()
    local point, _, relativePoint, x, y = RPGBB.frame:GetPoint()
    RPGBossBarDB.position = { point = point, relativePoint = relativePoint, x = x, y = y }
end)

-- Make the main frame draggable
RPGBB.frame:EnableMouse(true)
RPGBB.frame:RegisterForDrag("LeftButton")
RPGBB.frame:SetScript("OnDragStart", RPGBB.frame.StartMoving)
RPGBB.frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
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

local FONT = "Interface\\AddOns\\RPGBossBar\\media\\fonts\\Metamorphous-Regular.ttf"

RPGBB.health_font = CreateFont("RPGBossBarHealthFont")
RPGBB.health_font:SetFont(FONT, font_size, "OUTLINE")
RPGBB.health_font:SetTextColor(1, 1, 1, 1)


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
        -- Hide frame if no bosses and not testing
        if #RPGBB.current_boss_frames == 0 and not testing then
            RPGBB.frame:Hide()
        end
    else
        RPGBB.frame.handle:Show()
        RPGBB.frame:EnableMouse(true)
        RPGBB.frame:Show()
    end
end

function RPGBB:ToggleDebug()
    verbose = not verbose
    RPGBB:Print("debug turned " .. (verbose and "on" or "off"))
end

function RPGBB:ToggleTest(frame_count)
    frame_count = tonumber(frame_count) or 2
    frame_count = math.max(1, math.min(5, frame_count)) -- Clamp between 1 and 5

    testing = not testing
    RPGBB:Print("testing turned " .. (testing and "on" or "off"))

    if testing then
        local test_boss_frames = {}
        for i = 1, frame_count do
            table.insert(test_boss_frames, "boss" .. i)
        end

        RPGBB:UpdateFrames(test_boss_frames)

        for _, boss_frame in ipairs(test_boss_frames) do
            local test_max_health = 214748364
            local test_health = math.random(1, test_max_health)
            local test_percent = (test_health / test_max_health) * 100

            RPGBB:RenderHealthChanges(boss_frame, test_health, test_max_health, test_percent)

            -- Test Boss Name
            RPGBB.health_bars[boss_frame].name_text:SetText("Test Boss " .. boss_frame:match("%d+"))
        end

        RPGBB.frame:Show()
    else
        RPGBB.current_boss_frames = {}
        RPGBB:UpdateFrames({})
        RPGBB.frame:Hide()
    end
end

-- TODO revamp this to take health, max_health, and percent_health to DRY ToggleTest
function RPGBB:UpdateHealth()
    for _, boss_frame in ipairs(RPGBB.current_boss_frames) do
        RPGBB:RenderHealthChanges(boss_frame)
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
    RPGBB:UpdateFrames(boss_frames)
    return true
end

function RPGBB:UpdateFrames(boss_frames)
    local boss_frame_count = #boss_frames
    local health_bar_width = bar_width / boss_frame_count

    for _, bf in pairs(RPGBB.health_bars) do
        bf.frame:Hide()
        if bf.mid_graphic_frame then bf.mid_graphic_frame:Hide() end
    end

    for i, boss_frame in ipairs(boss_frames) do
        RPGBB:VPrint("RPGBB: " .. boss_frame .. " i: " .. i)

        RPGBB.health_bars[boss_frame] = RPGBB.health_bars[boss_frame] or {}

        --- Health Bar
        y_left_offset = health_bar_width * (i - 1)

        if not RPGBB.health_bars[boss_frame].frame then
            RPGBB:VPrint(boss_frame .. "frame did not exist!")
            RPGBB.health_bars[boss_frame].frame = CreateFrame("StatusBar", "RPG".. boss_frame .."BarHealthBar", RPGBB.frame)
            RPGBB.health_bars[boss_frame].frame:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
            RPGBB.health_bars[boss_frame].frame:GetStatusBarTexture():SetAtlas("Unit_Priest_Insanity_Fill")
            RPGBB.health_bars[boss_frame].frame:SetStatusBarColor(1, 1, 1, 1) -- White to show atlas texture colors
            RPGBB.health_bars[boss_frame].frame:SetFrameLevel(RPGBB.frame:GetFrameLevel() + HEALTH_BAR_LEVEL)
        else
            RPGBB:VPrint(boss_frame .. "Already Existed.")
        end

        RPGBB.health_bars[boss_frame].frame:ClearAllPoints()
        RPGBB.health_bars[boss_frame].frame:SetPoint("LEFT", RPGBB.frame, "LEFT", y_left_offset, 0)
        RPGBB.health_bars[boss_frame].frame:SetSize(health_bar_width, bar_height)
        RPGBB.health_bars[boss_frame].frame:Show()

        -- Create spark texture
        if not RPGBB.health_bars[boss_frame].spark then
            RPGBB.health_bars[boss_frame].spark = RPGBB.health_bars[boss_frame].frame:CreateTexture(nil, "OVERLAY")
            RPGBB.health_bars[boss_frame].spark:SetAtlas("Insanity-Spark")
            RPGBB.health_bars[boss_frame].spark:SetVertexColor(0x46/255, 0x22/255, 0x6a/255, 1) -- #46226a
            RPGBB.health_bars[boss_frame].spark:SetBlendMode("ADD")
            RPGBB.health_bars[boss_frame].spark:SetSize(4, bar_height * 1.5)

            -- Position at the current value of the status bar
            RPGBB.health_bars[boss_frame].spark:SetPoint("CENTER", RPGBB.health_bars[boss_frame].frame:GetStatusBarTexture(), "RIGHT", 0, 0)
        end


        -- Create health text (centered on the bar)
        if not RPGBB.health_bars[boss_frame].health_text then
            RPGBB.health_bars[boss_frame].health_text = RPGBB.health_bars[boss_frame].frame:CreateFontString(nil, "OVERLAY")
            RPGBB.health_bars[boss_frame].health_text:SetFontObject(RPGBB.health_font)
            RPGBB.health_bars[boss_frame].health_text:SetPoint("CENTER", RPGBB.health_bars[boss_frame].frame, "CENTER", 0, -1)
        end

        -- Create name text (above the bar)
        if not RPGBB.health_bars[boss_frame].name_text then
            RPGBB.health_bars[boss_frame].name_text = RPGBB.health_bars[boss_frame].frame:CreateFontString(nil, "OVERLAY")
            RPGBB.health_bars[boss_frame].name_text:SetFontObject(RPGBB.health_font)
            RPGBB.health_bars[boss_frame].name_text:SetPoint("BOTTOM", RPGBB.health_bars[boss_frame].frame, "TOP", 0, 2)
            RPGBB.health_bars[boss_frame].name_text:SetWordWrap(false)
        end
        RPGBB.health_bars[boss_frame].name_text:SetWidth(health_bar_width)
        RPGBB.health_bars[boss_frame].name_text:SetText(UnitName(boss_frame) or boss_frame)

        -- Create percentage text (right side of bar)
        if not RPGBB.health_bars[boss_frame].percent_text then
            RPGBB.health_bars[boss_frame].percent_text = RPGBB.health_bars[boss_frame].frame:CreateFontString(nil, "OVERLAY")
            RPGBB.health_bars[boss_frame].percent_text:SetFontObject(RPGBB.health_font)
            RPGBB.health_bars[boss_frame].percent_text:SetPoint("RIGHT", RPGBB.health_bars[boss_frame].frame, "RIGHT", -20, 0)
        end
        if boss_frame_count > 2 then
            RPGBB.health_bars[boss_frame].percent_text:Hide()
        else
            RPGBB.health_bars[boss_frame].percent_text:Show()
        end

        -- Don't create extra divider graphic elements
        if i == boss_frame_count then break end

        -------------------------------------------------------------------------------
        --- Middle Graphic Elements, create and attach on the right of all but n-1 bar
        -------------------------------------------------------------------------------

        local middle_graphic_width_mult = 0.7
        -- Create overlay frame for left graphics (sits on top of health bar)
        if not RPGBB.health_bars[boss_frame].mid_graphic_frame then
            RPGBB.health_bars[boss_frame].mid_graphic_frame = CreateFrame("Frame", "RPGBossBarLeftGraphic", RPGBB.health_bars[boss_frame].frame)
            RPGBB.health_bars[boss_frame].mid_graphic_frame:SetAllPoints(RPGBB.health_bars[boss_frame].frame)
            RPGBB.health_bars[boss_frame].mid_graphic_frame:SetFrameLevel(RPGBB.health_bars[boss_frame].frame:GetFrameLevel() + GRAPHICS_LEVEL)
        end
        RPGBB.health_bars[boss_frame].mid_graphic_frame:Show()

        -- Left Graphic Background (behind foreground)
        if not RPGBB.health_bars[boss_frame].mid_graphic_bg then
            RPGBB.health_bars[boss_frame].mid_graphic_bg = RPGBB.health_bars[boss_frame].mid_graphic_frame:CreateTexture(nil, "ARTWORK", nil, 1)
            RPGBB.health_bars[boss_frame].mid_graphic_bg:SetAtlas("dragonriding_sgvigor_fillfull")
            RPGBB.health_bars[boss_frame].mid_graphic_bg:SetSize(bg_w * middle_graphic_width_mult, bg_h)
            RPGBB.health_bars[boss_frame].mid_graphic_bg:SetVertexColor(0x46/255, 0x22/255, 0x6a/255, 1) -- #46226a
            RPGBB.health_bars[boss_frame].mid_graphic_bg:SetDesaturated(true)
        end

        -- Left Graphic Foreground (the frame)
        if not RPGBB.health_bars[boss_frame].mid_graphic_fg then
            RPGBB.health_bars[boss_frame].mid_graphic_fg = RPGBB.health_bars[boss_frame].mid_graphic_frame:CreateTexture(nil, "ARTWORK", nil, 2)
            RPGBB.health_bars[boss_frame].mid_graphic_fg:SetAtlas("dragonriding_sgvigor_frame_dark")
            RPGBB.health_bars[boss_frame].mid_graphic_fg:SetSize(fg_w * middle_graphic_width_mult, fg_h)
            RPGBB.health_bars[boss_frame].mid_graphic_fg:SetPoint("CENTER", RPGBB.health_bars[boss_frame].frame, "RIGHT", 0, 0)

            -- Anchor background to foreground center
            RPGBB.health_bars[boss_frame].mid_graphic_bg:SetPoint("CENTER", RPGBB.health_bars[boss_frame].mid_graphic_fg, "CENTER", 0, 0)
        end
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

            -- Register boss health events for all 5 possible boss units
            RPGBB.frame:RegisterUnitEvent("UNIT_HEALTH", "boss1", "boss2", "boss3", "boss4", "boss5")
            RPGBB.frame:RegisterUnitEvent("UNIT_MAXHEALTH", "boss1", "boss2", "boss3", "boss4", "boss5")
            RPGBB.frame:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
            RPGBB.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
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
    elseif event == "PLAYER_ENTERING_WORLD" then
        if #RPGBB.current_boss_frames == 0 then
            if RPGBossBarDB.locked then
                RPGBB.frame:Hide()
            else
                RPGBB:ToggleTest(2)
            end
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        -- Exited combat
        -- if unlocked, show frame for positioning
        if not RPGBossBarDB.locked then
            RPGBB.frame:Show()
        else
            RPGBB.frame:Hide()
        end
    elseif event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT" then
        if RPGBB:IsBossFramesToUpdate() then
            RPGBB:UpdateHealth()
        end
    end
end

-- Register events
RPGBB.frame:RegisterEvent("ADDON_LOADED")

RPGBB.frame:SetScript("OnEvent", EventHandler)
