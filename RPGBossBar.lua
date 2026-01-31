local ADDON_NAME, RPGBB = ...
ADDON_ABVR = "RPGBB"

-------------------------------------------------------------------------------
--- Configuration Variables
-------------------------------------------------------------------------------

local addon_color = "ffffff77"
local r, g, b = 255/255, 255/255, 119/255

local      font_size = 36
local  handle_offset = 0 -- Adjust Handle to the left
local     mover_size = 32
local padding_bottom = -3 -- Adjust all text down

local testing = false
local verbose = false

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
        RPGBB.frame:Hide()
        RPGBB.frame.bg:Hide()
        RPGBB.frame.handle:Hide()
        RPGBB.frame:EnableMouse(false)
    else
        RPGBB.frame:Show()
        RPGBB.frame.bg:Show()
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
    else
        RPGBB.frame:Hide()
    end
end

-------------------------------------------------------------------------------
--- Initialization
-------------------------------------------------------------------------------

-- Create the main frame
RPGBB.frame = CreateFrame("Frame", "RPGBossBarFrame", UIParent)
RPGBB.frame:SetSize(mover_size, mover_size)
RPGBB.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
RPGBB.frame:SetMovable(true)
RPGBB.frame:SetClampedToScreen(true)
RPGBB.frame:Hide()

-- Create background
RPGBB.frame.bg = RPGBB.frame:CreateTexture(nil, "BACKGROUND")
RPGBB.frame.bg:SetAllPoints(RPGBB.frame)
RPGBB.frame.bg:SetColorTexture(0, 0, 0, 0.5)

-- Create mover texture
RPGBB.frame.handle = RPGBB.frame:CreateTexture(nil, "BACKGROUND")
RPGBB.frame.handle:SetSize(mover_size - 2, mover_size - 2)
RPGBB.frame.handle:SetPoint("CENTER", RPGBB.frame, "CENTER", 0, 0)
RPGBB.frame.handle:SetTexture("Interface\\CURSOR\\UI-Cursor-Move")
RPGBB.frame.handle:SetVertexColor(1, 1, 1, 1)

-- Make the frame draggable
RPGBB.frame:EnableMouse(true)
RPGBB.frame:RegisterForDrag("LeftButton")
RPGBB.frame:SetScript("OnDragStart", RPGBB.frame.StartMoving)
RPGBB.frame:SetScript("OnDragStop", RPGBB.frame.StopMovingOrSizing)

-- Set up custom font
local FONT = "Interface\\AddOns\\RPGBossBar\\media\\fonts\\PTSansNarrow-Bold.ttf"

RPGBB.frame.font = CreateFont("RPGBossBarFont")
RPGBB.frame.font:SetFont(FONT, font_size, "OUTLINE")
RPGBB.frame.font:SetTextColor(1, 1, 1, 1)

-- Create the text
RPGBB.frame.text = RPGBB.frame:CreateFontString(nil, "OVERLAY")
RPGBB.frame.text:SetFontObject(RPGBB.frame.font)
RPGBB.frame.text:SetTextColor(r, g, b, 1)
RPGBB.frame.text:SetPoint("BOTTOMLEFT", RPGBB.frame, "BOTTOMRIGHT", handle_offset + 2, padding_bottom)


-------------------------------------------------------------------------------
--- Event Handling
-------------------------------------------------------------------------------

local function EventHandler(self, event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 == ADDON_NAME then
            if not RPGBossBarDB then
                RPGBB:Print("RPGBossBarDB not available, creating.")
                RPGBossBarDB = {
                    locked = false
                }
            else
                -- Set saved variables
                RPGBB:Lock(RPGBossBarDB.locked)
            end

            RPGBB.frame:UnregisterEvent("ADDON_LOADED")

            RPGBB:Print("Loaded. Use " .. SLASH_RPGBOSSBAR1 .. " for commands.")
        end
    end
end

-- Register events
RPGBB.frame:RegisterEvent("ADDON_LOADED")

RPGBB.frame:SetScript("OnEvent", EventHandler)
