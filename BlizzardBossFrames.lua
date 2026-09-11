local ADDON_NAME, RPGBB = ...

local events = CreateFrame("Frame")
local hiddenBossFrame

function RPGBB:UpdateBlizzardBossFrameVisibility()
    local hide = RPGBB.db:Get("frame", "hide_blizzard_boss_frames") == true
    if not hide and not hiddenBossFrame then
        events:UnregisterAllEvents()
        return
    end

    if InCombatLockdown() then
        events:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    events:UnregisterEvent("PLAYER_REGEN_ENABLED")

    local bossFrame = BossTargetFrameContainer
    if hide and not bossFrame then
        events:RegisterEvent("ADDON_LOADED")
        return
    end

    events:UnregisterEvent("ADDON_LOADED")

    if hide then
        if hiddenBossFrame ~= bossFrame then
            RegisterAttributeDriver(bossFrame, "state-visibility", "hide")
            hiddenBossFrame = bossFrame
        end
    elseif hiddenBossFrame then
        UnregisterAttributeDriver(hiddenBossFrame, "state-visibility")
        hiddenBossFrame:SetAttribute("statehidden", nil)
        hiddenBossFrame:UpdateShownState()
        hiddenBossFrame = nil
    end
end

events:SetScript("OnEvent", function(self, event, addonName)
    if event == "PLAYER_REGEN_ENABLED" or addonName == "Blizzard_UnitFrame" then
        RPGBB:UpdateBlizzardBossFrameVisibility()
    end
end)
