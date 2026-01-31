local ADDON_NAME, RPGBB = ...


-------------------------------------------------------------------------------
--- Slash Commands
-------------------------------------------------------------------------------

RPGBB.cmds = {}
RPGBB.cmds.toggle_lock = {
    triggers = { 'lock', 'l' },
    name = "Lock",
    description = "Lock or Unlock the Frame.",
    func = function() RPGBB:ToggleLock() end,
}

RPGBB.cmds.toggle_test = {
    triggers = { 'test', 't' },
    name = "Toggle frame for testing",
    description = "Toggle the frame for test viewing",
    func = function() RPGBB:ToggleTest() end,
}

RPGBB.cmds.toggle_debug = {
    triggers = { 'debug', 'd' },
    name = "Debug Messages",
    description = "Show debug messages",
    func = function() RPGBB:ToggleDebug() end,
}


-------------------------------------------------------------------------------
--- Slash Command Handling
-------------------------------------------------------------------------------

function RPGBB:Help()
    RPGBB:Print("Available Commands:")

    for _, cmd in pairs(RPGBB.cmds) do
        print(string.format("  %s %-10s - %s",
                            SLASH_RPGBOSSBAR1,
                            table.concat(cmd.triggers, ", "),
                            cmd.description))
    end
end

SLASH_RPGBOSSBAR1 = "/rpgbb"

SlashCmdList[strupper(ADDON_NAME)] = function(msg)
    msg = msg:lower():trim()

    RPGBB:VPrint(string.format("%s %s received",
                             SLASH_RPGBOSSBAR1,
                             msg ~= "" and msg or "(no msg)"))

    for _, cmd in pairs(RPGBB.cmds) do
        for _, trigger in ipairs(cmd.triggers) do
            if msg == trigger then
                cmd.func()
                return
            end
        end
    end

    RPGBB:Help()
end
