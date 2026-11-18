local World = require(script.Parent.World)
local Base = require(script.Parent.BaseService)
local Money = require(script.Parent.MoneyService)
local Models = require(script.Parent.BrainrotModels)
local Steal = {}

function Steal.startCarry(state, unit, source, sourceIndex)
	local model = Models.sculpt(workspace, unit, CFrame.new(), nil)
	local root = World.aliveRoot(state.player)
	model:PivotTo(root.CFrame * CFrame.new(0, 3.75, 0))
	state.carry = { unit = unit, source = source, sourceIndex = sourceIndex, model = model }
	state.player:SetAttribute("Carrying", unit.entry[1])
end

function Steal.clearCarry(state)
	local carry = state.carry
	carry.model:Destroy()
	state.carry = nil
	state.player:SetAttribute("Carrying", "")
	return carry
end

function Steal.returnRaid(state, states, onRaid, notify)
	local carry = Steal.clearCarry(state)
	local victim = carry.source
	if victim and states[victim.player] == victim then
		local index = carry.sourceIndex
		local slot = victim.slots[index]
		if slot and slot.inTransit then
			Base.parkUnit(victim, index, slot, onRaid)
			notify(victim.player, carry.unit.entry[1] .. " returned to your base.", "success")
		end
	elseif not victim then
		state.cash += carry.unit.price
		Money.publish(state)
	end
end

function Steal.beginRaid(player, victim, index, slot, states, notify)
	local thief = states[player]
	if not thief or thief.savingRebirth or victim.savingRebirth or thief == victim or states[victim.player] ~= victim
		or victim.slots[index] ~= slot or slot.inTransit or not World.near(player, slot.model.PrimaryPart) then
		return
	end
	if workspace:GetServerTimeNow() < victim.lockUntil then
		notify(player, "That safehouse is shielded.", "warning")
		return
	end
	if thief.carry or not Base.freeSlot(thief) then
		notify(player, "You need free hands and a free stand.", "warning")
		return
	end
	slot.inTransit = true
	slot.model:Destroy()
	slot.model = nil
	Money.publish(victim)
	Steal.startCarry(thief, slot.unit, victim, index)
	notify(player, "Raid started! Run back to your safehouse.", "success")
	notify(victim.player, player.DisplayName .. " grabbed " .. slot.unit.entry[1] .. "!", "warning")
end

function Steal.deliverCarry(state, onRaid, notify)
	local index = Base.freeSlot(state)
	if not index then
		return
	end
	local carry = Steal.clearCarry(state)
	local victim = carry.source
	if victim then
		local slot = victim.slots[carry.sourceIndex]
		if slot and slot.inTransit then
			victim.slots[carry.sourceIndex] = nil
			Money.publish(victim)
			notify(victim.player, carry.unit.entry[1] .. " was stolen.", "warning")
		end
	end
	Base.parkUnit(state, index, { unit = carry.unit }, onRaid)
	notify(state.player, string.format("%s installed  •  +$%d/s base rate", carry.unit.entry[1], carry.unit.rate), "success")
end

return Steal
