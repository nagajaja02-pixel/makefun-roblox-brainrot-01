local Base = require(script.Parent.BaseService)
local Money = require(script.Parent.MoneyService)
local Shield = require(script.Parent.ShieldService)
local World = require(script.Parent.World)

local Steal = { carrying = {} }

function Steal.root(player)
	local character = player.Character
	local human = character and character:FindFirstChildOfClass("Humanoid")
	if human and human.Health > 0 then
		return character:FindFirstChild("HumanoidRootPart")
	end
end

function Steal.near(player,part,distance)
	local root = Steal.root(player)
	return root and (part.Position-root.Position).Magnitude <= distance
end

local function addPrompts(item)
	if item.pickup then
		item.pickup.Enabled = true
		item.raid.Enabled = true
		return
	end
	local pivot = item.model.PrimaryPart
	item.pickup = World.prompt(pivot,"Pick Up",item.offer.character.name,0,9)
	item.pickup.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
	item.pickup:SetAttribute("InventoryAction","Own")
	item.raid = World.prompt(pivot,"Raid",item.offer.character.name,1.25,9)
	item.raid.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
	item.raid:SetAttribute("InventoryAction","Other")
	item.raid.Triggered:Connect(function(player)
		Steal.take(player,item,true)
	end)
	item.pickup.Triggered:Connect(function(player)
		Steal.take(player,item,false)
	end)
end

local function park(item,plot,slot)
	slot.item = item
	item.plot, item.slot, item.inTransit = plot, slot, false
	item.model.PrimaryPart.Anchored = true
	item.model:PivotTo(slot.pose)
	item.model.PrimaryPart:SetAttribute("PlotOwner",plot.owner.UserId)
	addPrompts(item)
	Money.publish(plot.owner,Money.states[plot.owner])
end

local function begin(player,item,root,kind)
	local state = Money.states[player]
	local pivot = item.model.PrimaryPart
	item.inTransit = true
	if item.pickup then
		item.pickup.Enabled = false
		item.raid.Enabled = false
	end
	item.model:PivotTo(root.CFrame*CFrame.new(0,4.45,-0.35))
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = root
	weld.Part1 = pivot
	weld.Parent = pivot
	pivot.Massless = true
	pivot.Anchored = false
	local inside = Base.isSheltered(state.plot,root.Position)
	Steal.carrying[player] = {item=item, weld=weld, kind=kind, leftHome=not inside}
	player:SetAttribute("Carrying",true)
	if item.plot and item.plot.owner then
		Money.publish(item.plot.owner,Money.states[item.plot.owner])
	end
end

function Steal.take(player,item,raid)
	local state = Money.states[player]
	local root = Steal.root(player)
	local plot = item.plot
	if not state or not state.plot or not root or not plot or not plot.owner or item.inTransit
		or item.slot.item ~= item or Steal.carrying[player] or not Steal.near(player,item.model.PrimaryPart,9) then
		return
	end
	if raid then
		if plot.owner == player or Shield.active(plot,workspace:GetServerTimeNow())
			or not Base.isSheltered(plot,root.Position) then
			return
		end
	elseif plot.owner ~= player then
		return
	end
	begin(player,item,root,raid and "Raid" or "Pickup")
end

function Steal.buy(player,record)
	local state = Money.states[player]
	local root = Steal.root(player)
	if not state or not state.plot or not root or Steal.carrying[player]
		or not Steal.near(player,record.model.PrimaryPart,10) then
		return false
	end
	if not Base.freeSlot(state.plot,Money.capacity(state)) then
		return false
	end
	if not Money.spend(player,state,record.offer.price) then
		return false
	end
	record.prompt:Destroy()
	begin(player,{model=record.model,offer=record.offer},root,"Purchase")
	return true
end

local function detach(player,carry)
	carry.weld:Destroy()
	Steal.carrying[player] = nil
	player:SetAttribute("Carrying",false)
end

local function releaseOrigin(item)
	if item.slot then
		item.slot.item = nil
		local owner = item.plot.owner
		if owner and Money.states[owner] then
			Money.publish(owner,Money.states[owner])
		end
	end
end

function Steal.returnItem(player)
	local carry = Steal.carrying[player]
	if not carry then
		return
	end
	local item = carry.item
	detach(player,carry)
	if item.plot and item.plot.owner then
		park(item,item.plot,item.slot)
	else
		item.model:Destroy()
	end
end

function Steal.sell(player)
	local carry = Steal.carrying[player]
	local state = Money.states[player]
	if not carry or not state then
		return
	end
	local item = carry.item
	detach(player,carry)
	releaseOrigin(item)
	item.model:Destroy()
	Money.credit(player,state,math.floor(item.offer.price*0.5))
end

function Steal.clearPlot(plot)
	for player, carry in Steal.carrying do
		if carry.item.plot == plot then
			Steal.returnItem(player)
		end
	end
	for _, slot in plot.slots do
		if slot.item then
			slot.item.model:Destroy()
			slot.item = nil
		end
	end
end

function Steal.hasTransit(plot)
	for _, slot in plot.slots do
		if slot.item and slot.item.inTransit then
			return true
		end
	end
	return false
end

function Steal.step()
	for player, carry in Steal.carrying do
		local item = carry.item
		local root = Steal.root(player)
		local state = Money.states[player]
		if not root or not state or not state.plot then
			Steal.returnItem(player)
			continue
		end
		if carry.kind == "Raid" then
			local inVictimHouse = Base.isSheltered(item.plot,root.Position)
			if not inVictimHouse then
				carry.leftVictim = true
			elseif carry.leftVictim then
				Steal.returnItem(player)
				continue
			end
		end
		local home = state.plot
		if not Base.isSheltered(home,root.Position) then
			carry.leftHome = true
		elseif carry.leftHome then
			local slot = Base.freeSlot(home,Money.capacity(state))
			if not slot and item.plot == home then
				-- The vacated stand is still reserved for this item.
				slot = item.slot
			end
			if slot then
				detach(player,carry)
				releaseOrigin(item)
				park(item,home,slot)
			end
		end
	end
end

return Steal
