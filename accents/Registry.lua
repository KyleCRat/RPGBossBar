local ADDON_NAME, RPGBB = ...

RPGBB.accent_groups = RPGBB.accent_groups or {}

local function IsSideSlot(slot)
    return slot == "left" or slot == "right"
end

function RPGBB:RegisterAccentGroup(group)
    if type(group) ~= "table" or not group.id or type(group.Render) ~= "function" then
        error("RPGBB:RegisterAccentGroup requires a group table with id and Render function", 2)
    end

    group.slots = group.slots or {}

    RPGBB.accent_groups[group.id] = group
end

function RPGBB:GetAccentGroup(id)
    return RPGBB.accent_groups[id]
end

function RPGBB:AccentGroupSupportsSlot(group, slot)
    if not group or not slot then
        return true
    end

    if group.slots and group.slots[slot] then
        return true
    end

    if group.mirrorable and IsSideSlot(group.native_side) and IsSideSlot(slot) then
        return true
    end

    return false
end

function RPGBB:GetAccentGroupsForSlot(slot)
    local groups = {}

    for _, group in pairs(RPGBB.accent_groups) do
        if RPGBB:AccentGroupSupportsSlot(group, slot) then
            groups[#groups + 1] = group
        end
    end

    table.sort(groups, function(a, b)
        return (a.name or a.id) < (b.name or b.id)
    end)

    return groups
end

function RPGBB:GetAccentMirrorState(group, context)
    if not group or not group.mirrorable then
        return false
    end

    if context.mirrored ~= nil then
        return context.mirrored
    end

    if context.mirror ~= nil then
        return context.mirror
    end

    return IsSideSlot(group.native_side)
        and IsSideSlot(context.side)
        and group.native_side ~= context.side
end

function RPGBB:HideAccentGroup(state)
    if state and state.frame then
        state.frame:Hide()
    end
end

function RPGBB:RenderAccentGroup(id, state, context)
    local group = RPGBB:GetAccentGroup(id)
    if not group then
        RPGBB:HideAccentGroup(state)

        return state
    end

    context = context or {}
    if not RPGBB:AccentGroupSupportsSlot(group, context.side) then
        RPGBB:HideAccentGroup(state)

        return state
    end

    if state and state.group_id and state.group_id ~= id then
        RPGBB:HideAccentGroup(state)
        state = nil
    end

    local render_context = {}
    for key, value in pairs(context) do
        render_context[key] = value
    end
    render_context.mirrored = RPGBB:GetAccentMirrorState(group, render_context)

    state = state or {}
    state.group_id = id
    group.Render(state, render_context)

    return state
end
