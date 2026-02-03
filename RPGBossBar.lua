local ADDON_NAME, RPGBB = ...

-------------------------------------------------------------------------------
--- Configuration Variables
-------------------------------------------------------------------------------

local addon_color = "ff46226a"

local testing = false
local verbose = false

--- Strata levels
local FRAME_BORDER_LEVEL = 5
local HEALTH_BAR_LEVEL   = 10
local GRAPHICS_LEVEL     = 15


-------------------------------------------------------------------------------
--- Init Health bar storage
-------------------------------------------------------------------------------

RPGBB.health_bars = {}
RPGBB.current_boss_frames = {}


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

    local frame_height = RPGBB.db.Get("frame", "height")
    local frame_width  = RPGBB.db.Get("frame", "width")

    RPGBB.frame:ClearAllPoints()
    RPGBB.frame:SetPoint(RPGBB.db.Get("frame", "position", "point"),
                         UIParent,
                         RPGBB.db.Get("frame", "position", "relative_point"),
                         RPGBB.db.Get("frame", "position", "x"),
                         RPGBB.db.Get("frame", "position", "y"))
    RPGBB.frame:SetSize(frame_width, frame_height)

    -- Create container's background
    if not RPGBB.frame.bg then
        RPGBB.frame.bg = RPGBB.frame:CreateTexture(nil, "BACKGROUND")
        RPGBB.frame.bg:SetAllPoints(RPGBB.frame)
    end
    RPGBB.frame.bg:SetColorTexture(RPGBB.db.GetColor("frame", "background_color"))

    -- Create container's frame
    local border_offset = 6
    local border_size = 18
    -- Not allowing editing of the border for now
    if not RPGBB.border then
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
    end


    ---------------------------------------------------------------------------
    --- Graphic Elements
    ---------------------------------------------------------------------------

    local graphic_height_mult = 1.8

    -- Foreground size
    local fg_width_to_height_ratio = 44.5 / 62.5

    RPGBB.fg_h = frame_height * graphic_height_mult
    RPGBB.fg_w = RPGBB.fg_h * fg_width_to_height_ratio

    -- Background size
    local bg_to_fg_ratio           = 50 / 62.5
    local bg_width_to_height_ratio = 36 / 50

    RPGBB.bg_h = RPGBB.fg_h * bg_to_fg_ratio
    RPGBB.bg_w = RPGBB.bg_h * bg_width_to_height_ratio

    -- Accent Size
    local ac_to_fg_ratio           = 75.5 / 62.5
    local ac_width_to_height_ratio = 58.5 / 75.5

    RPGBB.ac_h = RPGBB.fg_h * ac_to_fg_ratio
    RPGBB.ac_w = RPGBB.ac_h * ac_width_to_height_ratio

    --- Left - Anchored to Container
    -- Create overlay frame for left graphics (sits on top of health bar)
    if not RPGBB.leftGraphicFrame then
        RPGBB.leftGraphicFrame = CreateFrame("Frame", "RPGBossBarLeftGraphic", RPGBB.frame)
        RPGBB.leftGraphicFrame:SetAllPoints(RPGBB.frame)
        RPGBB.leftGraphicFrame:SetFrameLevel(RPGBB.frame:GetFrameLevel() + GRAPHICS_LEVEL)

        -- Left Graphic Background (behind foreground)
        RPGBB.leftGraphicBg = RPGBB.leftGraphicFrame:CreateTexture(nil, "ARTWORK", nil, 1)
        RPGBB.leftGraphicBg:SetAtlas("dragonriding_sgvigor_fillfull")
        -- RPGBB.leftGraphicBg:SetVertexColor(0x46/255, 0x22/255, 0x6a/255, 1) -- #46226a
        RPGBB.leftGraphicBg:SetDesaturated(true)

        -- Left Graphic Foreground (the frame)
        RPGBB.leftGraphicFg = RPGBB.leftGraphicFrame:CreateTexture(nil, "ARTWORK", nil, 2)
        RPGBB.leftGraphicFg:SetAtlas("dragonriding_sgvigor_frame_dark")
        RPGBB.leftGraphicFg:SetPoint("CENTER", RPGBB.frame, "LEFT", -2, 0)

        -- Anchor background to foreground center
        RPGBB.leftGraphicBg:SetPoint("CENTER", RPGBB.leftGraphicFg, "CENTER", 0, 0)

        -- Left Graphic Accent (decorative element)
        RPGBB.leftGraphicAccent = RPGBB.leftGraphicFrame:CreateTexture(nil, "ARTWORK", nil, 3)
        RPGBB.leftGraphicAccent:SetAtlas("dragonriding_sgvigor_decor_dark")
        RPGBB.leftGraphicAccent:SetTexCoord(1, 0, 0, 1) -- Mirror horizontally
    end
    RPGBB.leftGraphicAccent:SetPoint("BOTTOMRIGHT", RPGBB.leftGraphicFg, "BOTTOMLEFT", (RPGBB.fg_w / 2.25) , -(RPGBB.fg_h * 0.015))

    RPGBB.leftGraphicBg:SetSize(RPGBB.bg_w, RPGBB.bg_h)

    RPGBB.leftGraphicFg:SetSize(RPGBB.fg_w, RPGBB.fg_h)

    RPGBB.leftGraphicAccent:SetSize(RPGBB.ac_w, RPGBB.ac_h)

    RPGBB.leftGraphicBg:SetVertexColor(RPGBB.db.GetColor("accents", "color")) -- #46226a


    --- Right - Anchored to Container
    -- Create overlay frame for right graphics (sits on top of health bar)
    if not RPGBB.rightGraphicFrame then
        RPGBB.rightGraphicFrame = CreateFrame("Frame", "RPGBossBarRightGraphic", RPGBB.frame)
        RPGBB.rightGraphicFrame:SetAllPoints(RPGBB.frame)
        RPGBB.rightGraphicFrame:SetFrameLevel(RPGBB.frame:GetFrameLevel() + GRAPHICS_LEVEL)

        -- Right Graphic Background (behind foreground)
        RPGBB.rightGraphicBg = RPGBB.rightGraphicFrame:CreateTexture(nil, "ARTWORK", nil, 1)
        RPGBB.rightGraphicBg:SetAtlas("dragonriding_sgvigor_fillfull")
        -- RPGBB.rightGraphicBg:SetVertexColor(0x46/255, 0x22/255, 0x6a/255, 1) -- #46226a
        RPGBB.rightGraphicBg:SetDesaturated(true)

        -- Right Graphic Foreground (the frame)
        RPGBB.rightGraphicFg = RPGBB.rightGraphicFrame:CreateTexture(nil, "ARTWORK", nil, 2)
        RPGBB.rightGraphicFg:SetAtlas("dragonriding_sgvigor_frame_dark")
        RPGBB.rightGraphicFg:SetPoint("CENTER", RPGBB.frame, "RIGHT", 2, 0)

        -- Anchor background to foreground center
        RPGBB.rightGraphicBg:SetPoint("CENTER", RPGBB.rightGraphicFg, "CENTER", 0, 0)

        -- Right Graphic Accent (decorative element)
        RPGBB.rightGraphicAccent = RPGBB.rightGraphicFrame:CreateTexture(nil, "ARTWORK", nil, 3)
        RPGBB.rightGraphicAccent:SetAtlas("dragonriding_sgvigor_decor_dark")
    end
    RPGBB.rightGraphicAccent:SetPoint("BOTTOMLEFT", RPGBB.rightGraphicFg, "BOTTOMRIGHT", -(RPGBB.fg_w / 2.25) , -(RPGBB.fg_h * 0.015))

    RPGBB.rightGraphicBg:SetSize(RPGBB.bg_w, RPGBB.bg_h)

    RPGBB.rightGraphicFg:SetSize(RPGBB.fg_w, RPGBB.fg_h)

    RPGBB.rightGraphicAccent:SetSize(RPGBB.ac_w, RPGBB.ac_h)

    RPGBB.rightGraphicBg:SetVertexColor(RPGBB.db.GetColor("accents", "color"))


    ---------------------------------------------------------------------------
    --- Font
    ---------------------------------------------------------------------------

    local health_font = RPGBB.db.Get("health", "font", "font")
    local health_font_size = RPGBB.db.Get("health", "font", "size")

    RPGBB.health_font = CreateFont("RPGBossBarHealthFont")
    RPGBB.health_font:SetFont(health_font, health_font_size, "OUTLINE")
    RPGBB.health_font:SetTextColor(RPGBB.db.GetColor("health", "font", "color"))


    local name_font = RPGBB.db.Get("name", "font", "font")
    local name_font_size = RPGBB.db.Get("name", "font", "size")

    RPGBB.name_font = CreateFont("RPGBossBarNameFont")
    RPGBB.name_font:SetFont(name_font, name_font_size, "OUTLINE")
    RPGBB.name_font:SetTextColor(RPGBB.db.GetColor("name", "font", "color"))


    local power_font = RPGBB.db.Get("power", "font", "font")
    local power_font_size = RPGBB.db.Get("power", "font", "size")

    RPGBB.power_font = CreateFont("RPGBossBarPowerFont")
    RPGBB.power_font:SetFont(power_font, power_font_size, "OUTLINE")
    RPGBB.power_font:SetTextColor(RPGBB.db.GetColor("power", "font", "color"))

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
    recieved_frame_count_arg = ((frame_count and true) or false)
    frame_count = tonumber(frame_count) or 2
    frame_count = math.max(1, math.min(5, frame_count)) -- Clamp between 1 and 5

    RPGBB:VPrint("ToggleTest: recieved_frame_count_arg " .. ((frame_count and "true") or "false"))
    RPGBB:VPrint("ToggleTest: frame_count: " .. frame_count .. " current_boss_frames_count " .. #RPGBB.current_boss_frames)

    -- Toggle test if:
    --   We are not testing: Show
    --   We are testing: if no frame_count passed
    --                   or frame_count is the same as current test: Hide
    if not testing or (not recieved_frame_count_arg
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

            RPGBB:RenderHealthChanges(boss_frame, test_health, test_max_health, test_percent)

            -- Test Boss Name
            RPGBB.health_bars[boss_frame].name_text:SetText("Test Boss " .. boss_frame:match("%d+"))
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
    RPGBB:UpdateFrames()

    return true
end

function RPGBB:UpdateFrames()
    local frame_height = RPGBB.db.Get("frame", "height")
    local frame_width  = RPGBB.db.Get("frame", "width")

    local boss_frame_count = #RPGBB.current_boss_frames
    local health_bar_width = frame_width / boss_frame_count

    -- Hide all visible elements for updating
    for _, bf in pairs(RPGBB.health_bars) do
        bf.frame:Hide()
        if bf.mid_graphic_frame then bf.mid_graphic_frame:Hide() end
    end

    -- Get all db values before looping so we only get them once
    -- If we are using an atlas texture
    -- if RPGBB.db.get("health", "texture", "atlas") then
    local health_bar_texture_is_atlas = RPGBB.db.Get("health", "texture", "atlas")
    local health_bar_texture          = RPGBB.db.Get("health", "texture", "texture")
    local health_bar_atlas_texture    = RPGBB.db.Get("health", "texture", "atlas_texture")
    local health_bar_desaturated      = RPGBB.db.Get("health", "texture", "desaturated")
    local hb_r, hb_b, hb_g, hb_a      = RPGBB.db.GetColor("health", "texture", "color")

    local spark_atlas            = RPGBB.db.Get("health", "spark", "atlas")
    local sp_r, sp_b, sp_g, sp_a = RPGBB.db.GetColor("health", "spark", "color")
    local spark_blend_mode       = RPGBB.db.Get("health", "spark", "blend_mode")
    local spark_width            = RPGBB.db.Get("health", "spark", "width")
    local spark_height_multi     = RPGBB.db.Get("health", "spark", "height_multi")

    local name_x_offset = RPGBB.db.Get("name", "offset", "x")

    local health_percent_offset_x = RPGBB.db.Get("health", "percent_font", "offset", "x")
    local disable_per_above       = RPGBB.db.Get("health", "percent_font", "disable_above")

    local ac_r, ac_b, ac_g, ac_a = RPGBB.db.GetColor("accents", "color")

    for i, boss_frame in ipairs(RPGBB.current_boss_frames) do
        RPGBB:VPrint("RPGBB: " .. boss_frame .. " i: " .. i)

        RPGBB.health_bars[boss_frame] = RPGBB.health_bars[boss_frame] or {}

        y_left_offset = health_bar_width * (i - 1)

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
        if not RPGBB.health_bars[boss_frame].spark then
            RPGBB.health_bars[boss_frame].spark = RPGBB.health_bars[boss_frame].frame:CreateTexture(nil, "OVERLAY")
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
            RPGBB.health_bars[boss_frame].health_text:SetPoint("CENTER", RPGBB.health_bars[boss_frame].frame, "CENTER", 0, -1)
        end
        -- Update each time for setting changes
        RPGBB.health_bars[boss_frame].health_text:SetFontObject(RPGBB.health_font)

        -- Healthbar name text (above frame)
        if not RPGBB.health_bars[boss_frame].name_text then
            RPGBB.health_bars[boss_frame].name_text = RPGBB.health_bars[boss_frame].frame:CreateFontString(nil, "OVERLAY")
            RPGBB.health_bars[boss_frame].name_text:SetWordWrap(false)
        end
        RPGBB.health_bars[boss_frame].name_text:SetPoint("BOTTOM", RPGBB.health_bars[boss_frame].frame, "TOP", 0, name_x_offset)
        RPGBB.health_bars[boss_frame].name_text:SetFontObject(RPGBB.name_font)
        RPGBB.health_bars[boss_frame].name_text:SetWidth(health_bar_width)
        RPGBB.health_bars[boss_frame].name_text:SetText(UnitName(boss_frame) or boss_frame)

        -- Healthbar percentage text (right side of bar)
        if not RPGBB.health_bars[boss_frame].percent_text then
            RPGBB.health_bars[boss_frame].percent_text = RPGBB.health_bars[boss_frame].frame:CreateFontString(nil, "OVERLAY")
        end
        RPGBB.health_bars[boss_frame].percent_text:SetPoint("RIGHT", RPGBB.health_bars[boss_frame].frame, "RIGHT", health_percent_offset_x, 0)
        RPGBB.health_bars[boss_frame].percent_text:SetFontObject(RPGBB.health_font)

        -- Hide percentage if more than 2 bosses exist
        if boss_frame_count > disable_per_above then
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
            RPGBB.health_bars[boss_frame].mid_graphic_bg:SetDesaturated(true)
        end
        RPGBB.health_bars[boss_frame].mid_graphic_bg:SetSize(RPGBB.bg_w * middle_graphic_width_mult, RPGBB.bg_h)

        RPGBB.health_bars[boss_frame].mid_graphic_bg:SetVertexColor(ac_r, ac_b, ac_g, ac_a)

        -- Left Graphic Foreground (the frame)
        if not RPGBB.health_bars[boss_frame].mid_graphic_fg then
            RPGBB.health_bars[boss_frame].mid_graphic_fg = RPGBB.health_bars[boss_frame].mid_graphic_frame:CreateTexture(nil, "ARTWORK", nil, 2)
            RPGBB.health_bars[boss_frame].mid_graphic_fg:SetAtlas("dragonriding_sgvigor_frame_dark")
            RPGBB.health_bars[boss_frame].mid_graphic_fg:SetPoint("CENTER", RPGBB.health_bars[boss_frame].frame, "RIGHT", 0, 0)

            -- Anchor background to foreground center
            RPGBB.health_bars[boss_frame].mid_graphic_bg:SetPoint("CENTER", RPGBB.health_bars[boss_frame].mid_graphic_fg, "CENTER", 0, 0)
        end
        RPGBB.health_bars[boss_frame].mid_graphic_fg:SetSize(RPGBB.fg_w * middle_graphic_width_mult, RPGBB.fg_h)
    end
end

-------------------------------------------------------------------------------
--- Event Handling
-------------------------------------------------------------------------------

local function EventHandler(self, event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 == ADDON_NAME then
            RPGBB.db.Initialize()
            RPGBB:InitOrUpdateFrame()

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

    elseif event == "PLAYER_REGEN_ENABLED" then
        -- Exited combat
        RPGBB.frame:Hide()
    elseif event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT" then
        if RPGBB:IsBossFramesToUpdate() then
            RPGBB:UpdateHealth()
        end
    end
end

-- Register events
RPGBB.frame:RegisterEvent("ADDON_LOADED")

RPGBB.frame:SetScript("OnEvent", EventHandler)
