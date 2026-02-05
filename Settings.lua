local ADDON_NAME, RPGBB = ...

-------------------------------------------------------------------------------
--- Initiailze
-------------------------------------------------------------------------------
-- local RPGBBSettings = CreateFrame('frame')
local LibSharedMedia = LibStub('LibSharedMedia-3.0')

-- Register our custom font with LibSharedMedia
LibSharedMedia:Register('font', 'Metamorphous', "Interface\\AddOns\\RPGBossBar\\media\\fonts\\Metamorphous-Regular.ttf")

local LEM = LibStub('LibEditMode')


-------------------------------------------------------------------------------
--- Custom Resources
-------------------------------------------------------------------------------

-- Available bar textures (atlas names)
RPGBB.atlas_textures = {
       ["Blizzard Insanity"] = "Unit_Priest_Insanity_Fill",
           ["Blizzard Pain"] = "_DemonHunter-DemonicPainBar",
     ["Blizzard Ebon Might"] = "Unit_Evoker_EbonMight_Fill",
      ["Blizzard Maelstrom"] = "Unit_Shaman_Maelstrom_Fill",
    ["Blizzard Lunar Power"] = "Unit_Druid_AstralPower_Fill",
           ["Blizzard Fury"] = "Unit_DemonHunter_Fury_Fill",
    ["Blizzard Runic Power"] = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-RunicPower",
           ["Blizzard Rage"] = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Rage",
           ["Blizzard Mana"] = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Mana",
          ["Blizzard Focus"] = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Focus",
         ["Blizzard Energy"] = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Energy",
}

-- Available spark textures (atlas names)
RPGBB.spark_textures = {
           ["Blizzard Spark"] = "Spark",
        ["Blizzard Garrison"] = "GarrMission_EncounterBar-Spark",
        ["Blizzard Insanity"] = "Insanity-Spark",
      ["Blizzard Legionfall"] = "Legionfall_BarSpark",
           ["Blizzard XPBar"] = "XPBarAnim-OrangeSpark",
         ["Bonus Objectives"] = "bonusobjectives-bar-spark",
    ["Blizzard Honor System"] = "honorsystem-bar-spark",
}


-------------------------------------------------------------------------------
--- Listeners
-------------------------------------------------------------------------------

local function OnPositionChanged(frame, layoutName, point, x, y)
    local point, _, relative_point, x, y = frame:GetPoint()
    local uiScale = UIParent:GetScale()

    x = PixelUtil.GetNearestPixelSize(x, uiScale)
    y = PixelUtil.GetNearestPixelSize(y, uiScale)

    RPGBB.db.Set("frame", "position", "point", point)
    RPGBB.db.Set("frame", "position", "relative_point", relative_point)
    RPGBB.db.Set("frame", "position", "x", x)
    RPGBB.db.Set("frame", "position", "y", y)
end


-------------------------------------------------------------------------------
--- Settings Frame
-------------------------------------------------------------------------------
--- Test Frames
local function test_frame_count_get()
    return #RPGBB.current_boss_frames
end

local function test_frame_count_set(layoutName, value, fromReset)
    local frame_count = 0

    if fromReset then
        frame_count = 2
    else
        frame_count = value
    end

    if frame_count ~= #RPGBB.current_boss_frames then
        RPGBB:ToggleTest(frame_count)
    end
end

test_frame_count_setting = {
    name = 'Test Frames',
    kind = LEM.SettingType.Slider,
    default = 2,
    get = test_frame_count_get,
    set = test_frame_count_set,
    minValue = 1,
    maxValue = 5,
    valueStep = 1,
    formatter = function(value) return value end,
}

--- Frame Width
local function frame_width_get()
    return RPGBB.db.Get("frame", "width")
end

local function frame_width_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("frame", "width")
    else
        RPGBB.db.Set("frame", "width", value)
    end

    RPGBB:InitOrUpdateFrame()
end

frame_width_setting = {
    name = 'Frame Width',
    kind = LEM.SettingType.Slider,
    default = RPGBB.db.defaults.frame.width,
    get = frame_width_get,
    set = frame_width_set,
    minValue = 200,
    maxValue = 2000,
    valueStep = 10,
    formatter = function(value) return value end,
}

-------------------------------------------------------------------------------
--- Frame Height
local function frame_height_get()
    return RPGBB.db.Get("frame", "height")
end

local function frame_height_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("frame", "height")
    else
        RPGBB.db.Set("frame", "height", value)
    end

    RPGBB:InitOrUpdateFrame()
end

frame_height_setting = {
    name = 'Frame Height',
    kind = LEM.SettingType.Slider,
    default = RPGBB.db.defaults.frame.height,
    get = frame_height_get,
    set = frame_height_set,
    minValue = 20,
    maxValue = 100,
    valueStep = 1,
    formatter = function(value) return value end,
}

-------------------------------------------------------------------------------
--- Frame Background Color
local function frame_background_color_get()
    return CreateColor(RPGBB.db.GetColor("frame", "background_color"))
end

local function frame_background_color_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("frame", "background_color")
    else
        local r, g, b, a = value:GetRGBA()
        RPGBB.db.SetColor("frame", "background_color", { r = r, g = g, b = b, a = a } )
    end

    RPGBB:InitOrUpdateFrame()
end

frame_background_color_setting = {
    name = 'Background Color',
    kind = LEM.SettingType.ColorPicker,
    default = CreateColor(RPGBB.db.GetColorDefault("frame", "background_color")),
    hasOpacity = true,
    get = frame_background_color_get,
    set = frame_background_color_set,
}

-------------------------------------------------------------------------------
--- Frame Center X
local function frame_center_x_get()
    return RPGBB.db.Get("frame", "position", "x") == 0
end

local function frame_center_x_set(layoutName, value, fromReset)
    RPGBB.db.Set("frame", "position", "x", 0)
    RPGBB:InitOrUpdateFrame()
end

frame_center_x_setting = {
    name = 'Center Horizontally',
    kind = LEM.SettingType.Checkbox,
    default = true,
    get = frame_center_x_get,
    set = frame_center_x_set,
}

-------------------------------------------------------------------------------
--- Health Bar Texture
local function health_bar_texture_get(value)
    if RPGBB.atlas_textures[value] then
        return RPGBB.db.Get("health", "texture", "atlas_texture") == RPGBB.atlas_textures[value]
    else
        texture = LibSharedMedia:Fetch('statusbar', value)
        return RPGBB.db.Get("health", "texture", "texture") == texture
    end
end

local function health_bar_texture_set(value)
    if RPGBB.atlas_textures[value] then
        RPGBB.db.Set("health", "texture", "atlas", true)
        RPGBB.db.SetDefault("health", "texture", "texture")
        RPGBB.db.Set("health", "texture", "atlas_texture", RPGBB.atlas_textures[value])
    else
        texture = LibSharedMedia:Fetch('statusbar', value)
        RPGBB.db.Set("health", "texture", "atlas", false)
        RPGBB.db.Set("health", "texture", "texture", texture)
        RPGBB.db.Set("health", "texture", "atlas_texture", false)
    end

    RPGBB.UpdateFrames()
end

local function health_bar_texture_default(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("health", "texture", "atlas")
        RPGBB.db.SetDefault("health", "texture", "atlas_texture")
        RPGBB.db.SetDefault("health", "texture", "texture")

        RPGBB.UpdateFrames()
    end
end

health_bar_texture_setting = {
  name = 'Health Bar Texture',
  kind = LEM.SettingType.Dropdown,
  default = RPGBB.db.defaults.health.texture.texture,
  set = health_bar_texture_default,
  generator = function(owner, rootDescription)
    rootDescription:SetScrollMode(400)

    rootDescription:CreateTitle('Atlas Textures')
    for name, texture in pairs(RPGBB.atlas_textures) do
        rootDescription:CreateCheckbox(name, health_bar_texture_get, health_bar_texture_set, name)
    end

    rootDescription:CreateSpacer();

    rootDescription:CreateTitle('Shared Media')
    for _, name in ipairs(LibSharedMedia:List('statusbar')) do
        rootDescription:CreateCheckbox(name, health_bar_texture_get, health_bar_texture_set, name)
    end
  end,
}

-------------------------------------------------------------------------------
--- Health Bar Desaturated
local function health_bar_desaturated_get()
    return RPGBB.db.Get("health", "texture", "desaturated")
end

local function health_bar_desaturated_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("health", "texture", "desaturated")
    else
        RPGBB.db.Set("health", "texture", "desaturated", value)
    end

    RPGBB:UpdateFrames()
end

health_bar_desaturated_setting = {
    name = 'Health Bar Desaturated',
    kind = LEM.SettingType.Checkbox,
    default = RPGBB.db.defaults.health.texture.desaturated,
    get = health_bar_desaturated_get,
    set = health_bar_desaturated_set,
}

-------------------------------------------------------------------------------
--- Health Bar Texture Color
local function health_bar_texture_color_get(layoutName)
    return CreateColor(RPGBB.db.GetColor("health", "texture", "color"))
end

local function health_bar_texture_color_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("health", "texture", "color")
    else
        local r, g, b, a = value:GetRGBA()
        RPGBB.db.SetColor("health", "texture", "color", { r = r, g = g, b = b, a = a } )
    end

    RPGBB.UpdateFrames()
end

health_bar_texture_color_setting = {
  name = 'Health Bar Color',
  kind = LEM.SettingType.ColorPicker,
  default = CreateColor(RPGBB.db.GetColorDefault("health", "texture", "color")),
  hasOpacity = true,
  get = health_bar_texture_color_get,
  set = health_bar_texture_color_set,
}

-------------------------------------------------------------------------------
--- Health Bar Font
local function health_bar_font_get(value)
    local font = LibSharedMedia:Fetch('font', value)
    return RPGBB.db.Get("health", "font", "font") == font
end

local function health_bar_font_set(value)
    local font = LibSharedMedia:Fetch('font', value)
    RPGBB.db.Set("health", "font", "font", font)
    RPGBB:InitOrUpdateFrame()
end

local function health_bar_font_default(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("health", "font", "font")

        RPGBB:InitOrUpdateFrame()
    end
end

health_bar_font_setting = {
    name = 'Health Bar Font',
    kind = LEM.SettingType.Dropdown,
    default = RPGBB.db.defaults.health.font.font,
    set = health_bar_font_default,
    generator = function(owner, rootDescription)
        rootDescription:SetScrollMode(400)

        for _, name in ipairs(LibSharedMedia:List('font')) do
            rootDescription:CreateCheckbox(name, health_bar_font_get, health_bar_font_set, name)
        end
    end,
}

-------------------------------------------------------------------------------
--- Health Bar Font Size
local function health_bar_font_size_get(layoutName)
    RPGBB.db.Get("health", "font", "size")
end

local function health_bar_font_size_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("health", "font", "size")
    else
        RPGBB.db.Set("health", "font", "size", value)
    end

    RPGBB:InitOrUpdateFrame()
end

health_bar_font_size_setting = {
  name = 'Health Font Size',
  kind = LEM.SettingType.Slider,
  default = RPGBB.db.defaults.health.font.size,
  get = health_bar_font_size_get,
  set = health_bar_font_size_set,
  minValue = 6,
  maxValue = 64,
  valueStep = 1,
  formatter = function(value)
    return value
  end,
}

-------------------------------------------------------------------------------
--- Health Bar Font Color
local function health_bar_font_color_get(layoutName)
    return CreateColor(RPGBB.db.GetColor("health", "font", "color"))
end

local function health_bar_font_color_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("health", "font", "color")
    else
        local r, g, b, a = value:GetRGBA()
        RPGBB.db.SetColor("health", "font", "color", { r = r, g = g, b = b, a = a } )
    end

    RPGBB:InitOrUpdateFrame()
end

health_bar_font_color_setting = {
  name = 'Health Font Color',
  kind = LEM.SettingType.ColorPicker,
  default = CreateColor(RPGBB.db.GetColorDefault("health", "font", "color")),
  hasOpacity = true,
  get = health_bar_font_color_get,
  set = health_bar_font_color_set,
}

-------------------------------------------------------------------------------
--- Health Bar Percentage Disable At
local function health_bar_percentage_disable_above_get()
    return RPGBB.db.Get("health", "percent_font", "disable_above")
end

local function health_bar_percentage_disable_above_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("health", "percent_font", "disable_above")
    else
        RPGBB.db.Set("health", "percent_font", "disable_above", value)
    end

    RPGBB:UpdateFrames()
end

health_bar_percentage_disable_above_setting = {
    name = 'Hide % above # Frames',
    kind = LEM.SettingType.Slider,
    default = RPGBB.db.defaults.health.percent_font.disable_above,
    get = health_bar_percentage_disable_above_get,
    set = health_bar_percentage_disable_above_set,
    minValue = 1,
    maxValue = 5,
    valueStep = 1,
    formatter = function(value) return value end,
}

-------------------------------------------------------------------------------
--- Health Bar Percent Font Offset X
local function name_offset_x_get()
    return RPGBB.db.Get("health", "percent_font", "offset", "x")
end

local function name_offset_x_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("health", "percent_font", "offset", "x")
    else
        RPGBB.db.Set("health", "percent_font", "offset", "x", value)
    end

    RPGBB:UpdateFrames()
end

health_bar_percentage_font_offset_x_setting = {
    name = '% Offset X',
    kind = LEM.SettingType.Slider,
    default = RPGBB.db.defaults.name.offset.x,
    get = name_offset_x_get,
    set = name_offset_x_set,
    minValue = -100,
    maxValue = 0,
    valueStep = 1,
    formatter = function(value) return value end,
}

-------------------------------------------------------------------------------
--- Health Bar Spark Texture
local function health_bar_spark_texture_get(value)
    return RPGBB.db.Get("health", "spark", "atlas") == value
end

local function health_bar_spark_texture_set(value)
    RPGBB.db.Set("health", "spark", "atlas", value)
    RPGBB:UpdateFrames()
end

local function health_bar_spark_texture_default(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("health", "spark", "atlas")
        RPGBB:UpdateFrames()
    end
end

health_bar_spark_texture_setting = {
    name = 'Spark Texture',
    kind = LEM.SettingType.Dropdown,
    default = RPGBB.db.defaults.health.spark.atlas,
    set = health_bar_spark_texture_default,
    generator = function(owner, rootDescription)
        rootDescription:SetScrollMode(400)
        for name, texture in pairs(RPGBB.spark_textures) do
            rootDescription:CreateCheckbox(name, health_bar_spark_texture_get, health_bar_spark_texture_set, texture)
        end
    end,
}


-------------------------------------------------------------------------------
--- Health Bar Spark Color
local function health_bar_spark_color_get()
    return CreateColor(RPGBB.db.GetColor("health", "spark", "color"))
end

local function health_bar_spark_color_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("health", "spark", "color")
    else
        local r, g, b, a = value:GetRGBA()
        RPGBB.db.SetColor("health", "spark", "color", { r = r, g = g, b = b, a = a })
    end

    RPGBB:UpdateFrames()
end

health_bar_spark_color_setting = {
    name = 'Spark Color',
    kind = LEM.SettingType.ColorPicker,
    default = CreateColor(RPGBB.db.GetColorDefault("health", "spark", "color")),
    hasOpacity = true,
    get = health_bar_spark_color_get,
    set = health_bar_spark_color_set,
}

-------------------------------------------------------------------------------
--- Health Bar Spark Blend Mode
local blend_modes = { "DISABLE", "BLEND", "ALPHAKEY", "ADD", "MOD" }

local function health_bar_spark_blend_mode_get(value)
    return RPGBB.db.Get("health", "spark", "blend_mode") == value
end

local function health_bar_spark_blend_mode_set(value)
    RPGBB.db.Set("health", "spark", "blend_mode", value)
    RPGBB:UpdateFrames()
end

local function health_bar_spark_blend_mode_default(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("health", "spark", "blend_mode")
        RPGBB:UpdateFrames()
    end
end

health_bar_spark_blend_mode_setting = {
    name = 'Spark Blend Mode',
    kind = LEM.SettingType.Dropdown,
    default = RPGBB.db.defaults.health.spark.blend_mode,
    set = health_bar_spark_blend_mode_default,
    generator = function(owner, rootDescription)
        for _, mode in ipairs(blend_modes) do
            rootDescription:CreateCheckbox(mode, health_bar_spark_blend_mode_get, health_bar_spark_blend_mode_set, mode)
        end
    end,
}

-------------------------------------------------------------------------------
--- Health Bar Spark Width
local function health_bar_spark_width_get()
    return RPGBB.db.Get("health", "spark", "width")
end

local function health_bar_spark_width_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("health", "spark", "width")
    else
        RPGBB.db.Set("health", "spark", "width", value)
    end

    RPGBB:UpdateFrames()
end

health_bar_spark_width_setting = {
    name = 'Spark Width',
    kind = LEM.SettingType.Slider,
    default = RPGBB.db.defaults.health.spark.width,
    get = health_bar_spark_width_get,
    set = health_bar_spark_width_set,
    minValue = 1,
    maxValue = 40,
    valueStep = 1,
    formatter = function(value) return value end,
}

-------------------------------------------------------------------------------
--- Health Bar Spark Height Mulit
local function health_bar_spark_height_multi_get()
    return RPGBB.db.Get("health", "spark", "height_multi")
end

local function health_bar_spark_height_multi_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("health", "spark", "height_multi")
    else
        RPGBB.db.Set("health", "spark", "height_multi", value)
    end

    RPGBB:UpdateFrames()
end

health_bar_spark_height_multi_setting = {
    name = 'Spark Height Multiplier',
    kind = LEM.SettingType.Slider,
    default = RPGBB.db.defaults.health.spark.height_multi,
    get = health_bar_spark_height_multi_get,
    set = health_bar_spark_height_multi_set,
    minValue = 1,
    maxValue = 4,
    valueStep = 0.1,
    formatter = function(value) return value end,
}

-- -------------------------------------------------------------------------------
-- --- Accent Copy Healthbar Texture Color
-- local function accent_copy_healthbar_texture_color_get()
--     return RPGBB.db.Get("accents", "copy_healthbar_texture_color")
-- end

-- local function accent_copy_healthbar_texture_color_set(layoutName, value, fromReset)
--     if fromReset then
--         RPGBB.db.SetDefault("accents", "copy_healthbar_texture_color")
--     else
--         RPGBB.db.Set("accents", "copy_healthbar_texture_color", value)
--     end

--     RPGBB:InitOrUpdateFrame()
-- end

-- accent_copy_healthbar_texture_color_setting = {
--     name = 'Copy Health Bar Color',
--     kind = LEM.SettingType.Checkbox,
--     default = RPGBB.db.defaults.accents.copy_healthbar_texture_color,
--     get = accent_copy_healthbar_texture_color_get,
--     set = accent_copy_healthbar_texture_color_set,
-- }

-------------------------------------------------------------------------------
--- Accent Color
local function accent_color_get()
    return CreateColor(RPGBB.db.GetColor("accents", "color"))
end

local function accent_color_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("accents", "color")
    else
        local r, g, b, a = value:GetRGBA()
        RPGBB.db.SetColor("accents", "color", { r = r, g = g, b = b, a = a })
    end

    RPGBB:InitOrUpdateFrame()
end

accent_color_setting = {
    name = 'Accent Color',
    kind = LEM.SettingType.ColorPicker,
    default = CreateColor(RPGBB.db.GetColorDefault("accents", "color")),
    hasOpacity = true,
    get = accent_color_get,
    set = accent_color_set,
}

-------------------------------------------------------------------------------
--- Name Offset Y
local function name_offset_y_get()
    return RPGBB.db.Get("name", "offset", "y")
end

local function name_offset_y_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("name", "offset", "y")
    else
        RPGBB.db.Set("name", "offset", "y", value)
    end

    RPGBB:UpdateFrames()
end

name_offset_y_setting = {
    name = 'Name Offset Y',
    kind = LEM.SettingType.Slider,
    default = RPGBB.db.defaults.name.offset.x,
    get = name_offset_y_get,
    set = name_offset_y_set,
    minValue = -200,
    maxValue = 200,
    valueStep = 1,
    formatter = function(value) return value end,
}

-------------------------------------------------------------------------------
--- Name Font
local function name_font_get(value)
    local font = LibSharedMedia:Fetch('font', value)
    return RPGBB.db.Get("name", "font", "font") == font
end

local function name_font_set(value)
    local font = LibSharedMedia:Fetch('font', value)
    RPGBB.db.Set("name", "font", "font", font)
    RPGBB:InitOrUpdateFrame()
end

local function name_font_default(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("name", "font", "font")
        RPGBB:InitOrUpdateFrame()
    end
end

name_font_setting = {
    name = 'Name Font',
    kind = LEM.SettingType.Dropdown,
    default = RPGBB.db.defaults.name.font.font,
    set = name_font_default,
    generator = function(owner, rootDescription)
        rootDescription:SetScrollMode(400)
        for _, name in ipairs(LibSharedMedia:List('font')) do
            rootDescription:CreateCheckbox(name, name_font_get, name_font_set, name)
        end
    end,
}

-------------------------------------------------------------------------------
--- Name Font Size
local function name_font_size_get()
    return RPGBB.db.Get("name", "font", "size")
end

local function name_font_size_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("name", "font", "size")
    else
        RPGBB.db.Set("name", "font", "size", value)
    end

    RPGBB:InitOrUpdateFrame()
end

name_font_size_setting = {
    name = 'Name Font Size',
    kind = LEM.SettingType.Slider,
    default = RPGBB.db.defaults.name.font.size,
    get = name_font_size_get,
    set = name_font_size_set,
    minValue = 6,
    maxValue = 48,
    valueStep = 1,
    formatter = function(value) return value end,
}

-------------------------------------------------------------------------------
--- Name Font Color
local function name_font_color_get()
    return CreateColor(RPGBB.db.GetColor("name", "font", "color"))
end

local function name_font_color_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("name", "font", "color")
    else
        local r, g, b, a = value:GetRGBA()
        RPGBB.db.SetColor("name", "font", "color", { r = r, g = g, b = b, a = a })
    end

    RPGBB:InitOrUpdateFrame()
end

name_font_color_setting = {
    name = 'Name Font Color',
    kind = LEM.SettingType.ColorPicker,
    default = CreateColor(RPGBB.db.GetColorDefault("name", "font", "color")),
    hasOpacity = true,
    get = name_font_color_get,
    set = name_font_color_set,
}

-------------------------------------------------------------------------------
--- Power Bar Enabled
local function power_bar_enabled_get()
    return RPGBB.db.Get("power", "enabled")
end

local function power_bar_enabled_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("power", "enabled")
    else
        RPGBB.db.Set("power", "enabled", value)
    end

    RPGBB:UpdateFrames()
end

power_bar_enabled_setting = {
    name = 'Power Bar Enabled',
    kind = LEM.SettingType.Checkbox,
    default = RPGBB.db.defaults.power.enabled,
    get = power_bar_enabled_get,
    set = power_bar_enabled_set,
}

-------------------------------------------------------------------------------
--- Power Bar Font
local function power_bar_font_get(value)
    local font = LibSharedMedia:Fetch('font', value)
    return RPGBB.db.Get("power", "font", "font") == font
end

local function power_bar_font_set(value)
    local font = LibSharedMedia:Fetch('font', value)
    RPGBB.db.Set("power", "font", "font", font)
    RPGBB:InitOrUpdateFrame()
end

local function power_bar_font_default(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("power", "font", "font")
        RPGBB:InitOrUpdateFrame()
    end
end

power_bar_font_setting = {
    name = 'Power Font',
    kind = LEM.SettingType.Dropdown,
    default = RPGBB.db.defaults.power.font.font,
    set = power_bar_font_default,
    generator = function(owner, rootDescription)
        rootDescription:SetScrollMode(400)
        for _, name in ipairs(LibSharedMedia:List('font')) do
            rootDescription:CreateCheckbox(name, power_bar_font_get, power_bar_font_set, name)
        end
    end,
}

-------------------------------------------------------------------------------
--- Power Bar Font Size
local function power_bar_font_size_get()
    return RPGBB.db.Get("power", "font", "size")
end

local function power_bar_font_size_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("power", "font", "size")
    else
        RPGBB.db.Set("power", "font", "size", value)
    end

    RPGBB:InitOrUpdateFrame()
end

power_bar_font_size_setting = {
    name = 'Power Font Size',
    kind = LEM.SettingType.Slider,
    default = RPGBB.db.defaults.power.font.size,
    get = power_bar_font_size_get,
    set = power_bar_font_size_set,
    minValue = 6,
    maxValue = 32,
    valueStep = 1,
    formatter = function(value) return value end,
}

-------------------------------------------------------------------------------
--- Power Bar Font Color
local function power_bar_font_color_get()
    return CreateColor(RPGBB.db.GetColor("power", "font", "color"))
end

local function power_bar_font_color_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("power", "font", "color")
    else
        local r, g, b, a = value:GetRGBA()
        RPGBB.db.SetColor("power", "font", "color", { r = r, g = g, b = b, a = a })
    end

    RPGBB:InitOrUpdateFrame()
end

power_bar_font_color_setting = {
    name = 'Power Font Color',
    kind = LEM.SettingType.ColorPicker,
    default = CreateColor(RPGBB.db.GetColorDefault("power", "font", "color")),
    hasOpacity = true,
    get = power_bar_font_color_get,
    set = power_bar_font_color_set,
}

-------------------------------------------------------------------------------
--- Construct the settings frame

local default_position = CopyTable(RPGBB.db.defaults.frame.position)

RPGBB.frame.editModeName = 'RPG Boss Bar'
LEM:AddFrame(RPGBB.frame, OnPositionChanged, default_position)
LEM:AddFrameSettings(RPGBB.frame, {
    test_frame_count_setting,
    { name = 'Frame Settings', kind = LEM.SettingType.Divider, },
    frame_center_x_setting,
    frame_width_setting,
    frame_height_setting,
    frame_background_color_setting,
    { name = 'Boss Name Font', kind = LEM.SettingType.Divider, },
    name_offset_y_setting,
    name_font_setting,
    name_font_size_setting,
    name_font_color_setting,
    { name = 'Health Bar Texture', kind = LEM.SettingType.Divider, },
    health_bar_desaturated_setting,
    health_bar_texture_setting,
    health_bar_texture_color_setting,
    { name = 'Health Bar Font', kind = LEM.SettingType.Divider, },
    health_bar_font_setting,
    health_bar_font_size_setting,
    health_bar_font_color_setting,
    { name = 'Percentage Font', kind = LEM.SettingType.Divider, },
    health_bar_percentage_disable_above_setting,
    health_bar_percentage_font_offset_x_setting,
    { name = 'Health Bar Spark', kind = LEM.SettingType.Divider, },
    health_bar_spark_width_setting,
    health_bar_spark_height_multi_setting,
    health_bar_spark_texture_setting,
    health_bar_spark_blend_mode_setting,
    health_bar_spark_color_setting,
    { name = 'Accent Settings', kind = LEM.SettingType.Divider, },
    -- accent_copy_healthbar_texture_color_setting,
    accent_color_setting,
    -- { name = 'Power Bar', kind = LEM.SettingType.Divider, },
    -- power_bar_enabled_setting,
    -- power_bar_font_setting,
    -- power_bar_font_size_setting,
    -- power_bar_font_color_setting,
})


-------------------------------------------------------------------------------
--- Hook into and hide the Edit Mode selection label
-------------------------------------------------------------------------------

-- Hide the overlay in edit mode when selected on RPGBB
local function SetEditModeSelectionState(alpha, isLabelVisible)
  RPGBB.frame.Selection.Center:SetAlpha(alpha)
  if isLabelVisible then
    RPGBB.frame.Selection.Label:Show()
    -- Add a "Editing RPG Boss Bar" text frame?
  else
    RPGBB.frame.Selection.Label:Hide()
  end
end

RPGBB.frame.Selection:HookScript('OnLeave', function(self)
  if self.isSelected then
    SetEditModeSelectionState(0, false)
  else
    SetEditModeSelectionState(1, false)
  end
end)

LEM.internal.dialog:HookScript('OnHide', function(self)
  if not RPGBB.frame.Selection.isSelected then
    SetEditModeSelectionState(1, false)
  end
end)

LEM:RegisterCallback('enter', function()
    RPGBB:Lock(false)
end)

LEM:RegisterCallback('exit', function()
    RPGBB:Lock(true)
end)
