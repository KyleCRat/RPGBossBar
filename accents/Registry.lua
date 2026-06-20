local ADDON_NAME, RPGBB = ...

RPGBB.accent_groups = RPGBB.accent_groups or {}
RPGBB.accent_options = RPGBB.accent_options or {}
RPGBB.accent_option_order = RPGBB.accent_option_order or {}

local function IsSideSlot(slot)
    return slot == "left" or slot == "right"
end

local default_accent_texture_keys = {
    "texture",
    "background",
    "foreground",
    "accent",
}

local function HideAccentTexture(texture)
    if not texture then
        return
    end

    texture:Hide()
    texture:ClearAllPoints()

    if texture.SetRotation then
        texture:SetRotation(0)
    end
end

function RPGBB:EnsureAccentFrame(state, parent)
    if not state.frame then
        state.frame = CreateFrame("Frame", nil, parent)
    else
        state.frame:SetParent(parent)
    end

    return state.frame
end

function RPGBB:EnsureAccentTexture(state, key, layer, sublevel, atlas, desaturated)
    if not state[key] then
        state[key] = state.frame:CreateTexture(nil, layer or "ARTWORK", nil, sublevel)
    end

    if atlas then
        state[key]:SetAtlas(atlas)
    end

    if desaturated ~= nil then
        state[key]:SetDesaturated(desaturated)
    end

    state[key]:Show()

    return state[key]
end

local function PrepareAccentGroupState(group, state, context)
    if group.manageFrame == false then
        return
    end

    RPGBB:EnsureAccentFrame(state, context.parent)

    state.frame:ClearAllPoints()
    state.frame:SetAllPoints(context.parent)
    state.frame:SetFrameLevel(context.frame_level)
    state.frame:Show()

    if not group.textures then
        return
    end

    state.managed_texture_keys = state.managed_texture_keys or {}

    for _, texture in ipairs(group.textures) do
        state.managed_texture_keys[texture.key] = true

        RPGBB:EnsureAccentTexture(
            state,
            texture.key,
            texture.layer,
            texture.sublevel,
            texture.atlas,
            texture.desaturated
        )
    end
end

function RPGBB:RegisterAccentGroup(group)
    if type(group) ~= "table" or not group.id or type(group.Render) ~= "function" then
        error("RPGBB:RegisterAccentGroup requires a group table with id and Render function", 2)
    end

    group.slots = group.slots or {}

    RPGBB.accent_groups[group.id] = group

    RPGBB:RegisterAccentOption({
        id = group.id,
        name = group.name or group.id,
        kind = "group",
        group = group.id,
        slots = group.slots,
    })
end

function RPGBB:GetAccentGroup(id)
    return RPGBB.accent_groups[id]
end

function RPGBB:RegisterAccentOption(option)
    if type(option) ~= "table" or type(option.id) ~= "string" or option.id == "" then
        error("RPGBB:RegisterAccentOption requires an option table with id", 2)
    end

    option.kind = option.kind or "group"
    option.slots = option.slots or {}

    if not RPGBB.accent_options[option.id] then
        RPGBB.accent_option_order[#RPGBB.accent_option_order + 1] = option.id
    end

    RPGBB.accent_options[option.id] = option
end

function RPGBB:GetAccentOption(id)
    return RPGBB.accent_options[id]
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

function RPGBB:AccentOptionSupportsSlot(option, slot)
    if not option or not slot then
        return true
    end

    if option.kind == "group" then
        local group = RPGBB:GetAccentGroup(option.group or option.id)

        return RPGBB:AccentGroupSupportsSlot(group, slot)
    end

    return option.slots and option.slots[slot]
end

function RPGBB:GetAccentOptionsForSlot(slot)
    local options = {}

    for _, id in ipairs(RPGBB.accent_option_order) do
        local option = RPGBB.accent_options[id]
        if RPGBB:AccentOptionSupportsSlot(option, slot) then
            options[#options + 1] = option
        end
    end

    table.sort(options, function(a, b)
        return (a.name or a.id) < (b.name or b.id)
    end)

    return options
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
    if not state then
        return
    end

    for _, key in ipairs(default_accent_texture_keys) do
        HideAccentTexture(state[key])
    end

    if state.managed_texture_keys then
        for key in pairs(state.managed_texture_keys) do
            HideAccentTexture(state[key])
        end

        wipe(state.managed_texture_keys)
    end

    if state.frame then
        state.frame:Hide()
        state.frame:ClearAllPoints()
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

    local render_key = "group:" .. id
    if state and state.render_key ~= render_key then
        RPGBB:HideAccentGroup(state)
    end

    local render_context = {}
    for key, value in pairs(context) do
        render_context[key] = value
    end
    render_context.mirrored = RPGBB:GetAccentMirrorState(group, render_context)

    state = state or {}
    state.render_key = render_key
    state.group_id = id
    PrepareAccentGroupState(group, state, render_context)
    group.Render(state, render_context)

    return state
end

function RPGBB:RenderAccentSelection(id, state, context)
    local option = RPGBB:GetAccentOption(id)
    local config = context and context.config or {}
    local custom_atlas = config.custom_atlas

    if type(custom_atlas) ~= "string" or custom_atlas == "" then
        custom_atlas = nil
    end

    if not option and not custom_atlas then
        RPGBB:HideAccentGroup(state)

        return state
    end

    context = context or {}
    if option and not RPGBB:AccentOptionSupportsSlot(option, context.side) then
        RPGBB:HideAccentGroup(state)

        return state
    end

    if custom_atlas then
        return RPGBB:RenderAtlasAccent(
            option,
            state,
            context,
            custom_atlas,
            "atlas"
        )
    end

    if option.kind == "atlas" then
        return RPGBB:RenderAtlasAccent(option, state, context, option.atlas, "atlas")
    end

    if option.kind == "group" then
        return RPGBB:RenderAccentGroup(option.group or option.id, state, context)
    end

    RPGBB:HideAccentGroup(state)

    return state
end
