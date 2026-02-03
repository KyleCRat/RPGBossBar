local ADDON_NAME, RPGBB = ...

RPGBB.db = {}

function RPGBB.db.Initialize()
    RPGBB.db.data = RPGBossBarDB or {}

    -- Old version of RPGBossBarDB.lua, reset db
    if RPGBossBarDB.position then
        RPGBB:Print("Outdated / Invalid settings detected, resetting RPGBossBarDB!")
        RPGBB.db.Reset()
    end
end
