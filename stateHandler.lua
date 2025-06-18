local PlayerState = {}
PlayerState.__index = PlayerState

function PlayerState.new(stateFolder)
	local self = setmetatable({}, PlayerState)
	self._states = {}

	for _, instance in ipairs(stateFolder:GetChildren()) do
		self._states[instance.Name] = instance
	end

	return setmetatable(self, {
		__index = function(t, key)
			local val = rawget(t._states, key)
			if val then
				return val.Value
			end

			local method = rawget(PlayerState, key)
			if method then
				return method
			end

			return nil
		end,

		__newindex = function(t, key, value)
			local val = rawget(t._states, key)
			if val then
				val.Value = value
			else
				warn("[PlayerState] Tried to set unknown state: " .. tostring(key))
			end
		end
	})
end

function PlayerState:reset(stateFolder)
	for k in pairs(self._states) do
		self._states[k] = nil
	end
	for _, instance in ipairs(stateFolder:GetChildren()) do
		self._states[instance.Name] = instance
	end
end

function PlayerState:GetObject(name)
	return self._states[name]
end

function PlayerState:OnChanged(name, callback)
	local obj = self._states[name]
	if obj then
		return obj.Changed:Connect(callback)
	else
		warn("[PlayerState] Cannot bind to unknown state: " .. name)
	end
end

function PlayerState:canAttack(character : Model)
	return not character:FindFirstChild("Stun")
		and not self["Blocking"]
		and not self["Attacking"]
		and not self["Dashing"]
		and not self["Ragdolled"]
		and not self["Critting"]
		and not character:FindFirstChild("TrueStun")
end

function PlayerState:canDash(character : Model)
	return not character:FindFirstChild("Stun")
		and not self["Dashing"]
		and not self["Attacking"]
		and not self["Uptilt"]
		and not self["Ragdolled"]
		and not self["Critting"]
		and not character:FindFirstChild("TrueStun")
end

function PlayerState:canBlock(character : Model)
	return not character:FindFirstChild("Stun")
		and not self["Blocking"]
		and not self["Ragdolled"]
		and not self["Critting"]
		and not character:FindFirstChild("TrueStun")
end

function PlayerState:canRun(character : Model)
	return not self["Blocking"]
		and not character:FindFirstChild("Stun")
		and not self["Ragdolled"]
		and not self["Critting"]
		and not character:FindFirstChild("TrueStun")
end

function PlayerState:canHit(character : Model)
	return not self["Iframes"]
		and not self["M1Immune"]
end

return PlayerState
