local ADDON_NAME, RPGBB = ...


-------------------------------------------------------------------------------
--- Slash Commands
-------------------------------------------------------------------------------

RPGBB.cmds = {}

RPGBB.cmds.toggle_test = {
    triggers = { 'test', 't' },
    name = "Toggle frame for testing",
    description = "Toggle the frame for test viewing (optional: number of frames 1-5)",
    func = function(args) RPGBB:ToggleTest(args) end,
}

RPGBB.cmds.toggle_debug = {
    triggers = { 'debug', 'd' },
    name = "Debug Messages",
    description = "Show debug messages",
    func = function() RPGBB:ToggleDebug() end,
}

RPGBB.cmds.reset = {
    triggers = { 'reset' },
    name = "Reset RPGBossBarDB",
    description = "Reset the RPGBossBarDB if you're getting errors",
    func = function() RPGBB.db.Reset() end,
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

    -- Split command and arguments
    local cmd_str, args = msg:match("^(%S+)%s*(.*)$")
    cmd_str = cmd_str or msg
    args = args ~= "" and args or nil

    for _, cmd in pairs(RPGBB.cmds) do
        for _, trigger in ipairs(cmd.triggers) do
            if cmd_str == trigger then
                cmd.func(args)
                return
            end
        end
    end

    RPGBB:Help()
end
