local MINOR = 1
local lib, minor = LibStub('LibSimpleDB-1.0')
if minor > MINOR then
	return
end

-------------------------------------------------------------------------------
--- Profile Methods (mixed into db instances created by lib:New)
-------------------------------------------------------------------------------

local ProfileMethods = {}

function ProfileMethods:GetCurrentProfile()
	return self.profileKey
end

function ProfileMethods:SetProfile(name)
	if type(name) ~= "string" or name == "" then
		error("Usage: db:SetProfile(name) — name must be a non-empty string", 2)
	end

	if name == self.profileKey then
		return
	end

	self:FireEvent("OnProfileShutdown")

	-- Ensure the target profile exists
	self.sv.profiles[name] = self.sv.profiles[name] or {}

	-- Update references
	self.profileKey = name
	self.sv.profileKeys[self.charKey] = name
	self.data = self.sv.profiles[name]

	self:FireEvent("OnProfileChanged", name)
end

function ProfileMethods:GetProfiles()
	local profiles = {}
	for name in pairs(self.sv.profiles) do
		profiles[#profiles + 1] = name
	end
	table.sort(profiles)

	return profiles
end

function ProfileMethods:DeleteProfile(name)
	if type(name) ~= "string" then
		error("Usage: db:DeleteProfile(name)", 2)
	end

	if name == self.profileKey then
		error("LibSimpleDB: Cannot delete the active profile", 2)
	end

	if not self.sv.profiles[name] then
		return
	end

	self.sv.profiles[name] = nil

	-- Reassign any characters that were using this profile to the default
	for charKey, profileKey in pairs(self.sv.profileKeys) do
		if profileKey == name then
			self.sv.profileKeys[charKey] = self.defaultProfile
		end
	end

	self:FireEvent("OnProfileDeleted", name)
end

function ProfileMethods:CopyProfile(sourceName)
	if type(sourceName) ~= "string" then
		error("Usage: db:CopyProfile(sourceName)", 2)
	end

	local source = self.sv.profiles[sourceName]
	if not source then
		error("LibSimpleDB: Profile '" .. sourceName .. "' does not exist", 2)
	end

	-- Wipe current and deep copy source into it
	wipe(self.data)
	for k, v in pairs(source) do
		if type(v) == "table" then
			self.data[k] = CopyTable(v)
		else
			self.data[k] = v
		end
	end

	self:FireEvent("OnProfileCopied", sourceName)
end

function ProfileMethods:ResetProfile()
	wipe(self.data)
	self:FireEvent("OnProfileReset")
end

-------------------------------------------------------------------------------
--- Global Section Access
-------------------------------------------------------------------------------

function ProfileMethods:GetGlobal(...)
	local keys = { ... }
	if #keys == 0 then
		return nil
	end

	local current = self.sv.global
	for _, key in ipairs(keys) do
		if type(current) ~= "table" then
			return nil
		end
		current = current[key]
	end

	return current
end

function ProfileMethods:SetGlobal(...)
	local args = { ... }
	local numArgs = #args
	if numArgs < 2 then
		error("Usage: db:SetGlobal(key1, ..., keyN, value)", 2)
	end

	local value = args[numArgs]

	local current = self.sv.global
	for i = 1, numArgs - 2 do
		local key = args[i]
		if current[key] == nil then
			current[key] = {}
		end
		current = current[key]
	end

	current[args[numArgs - 1]] = value
end

-------------------------------------------------------------------------------
--- Mix profile methods into New()
-------------------------------------------------------------------------------

local origNew = lib.New

function lib:New(savedVariableName, defaults, defaultProfile)
	local db = origNew(self, savedVariableName, defaults, defaultProfile)

	for k, v in pairs(ProfileMethods) do
		db[k] = v
	end

	return db
end
