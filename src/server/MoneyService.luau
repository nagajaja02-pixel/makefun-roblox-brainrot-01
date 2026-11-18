local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")
local Money = { states = {} }
local store
if not RunService:IsStudio() then
	store = DataStoreService:GetDataStore("BlitzRebirthsV1")
end

function Money.capacity(state)
	return 4 + (state.level-1)*2
end

function Money.upgradePrice(state)
	return 550*state.level^2
end

function Money.rebirthPrice(state)
	return 12000*(state.rebirths+1)
end

local function rate(state)
	local amount = 0
	if state.plot then
		for _, slot in state.plot.slots do
			if slot.item and not slot.item.inTransit then
				amount += slot.item.offer.rate
			end
		end
	end
	return math.floor(amount*(1+0.5*state.rebirths))
end

function Money.publish(player,state)
	player:SetAttribute("Cash",state.cash)
	player:SetAttribute("Income",rate(state))
	player:SetAttribute("Level",state.level)
	player:SetAttribute("Rebirths",state.rebirths)
	player:SetAttribute("RebirthPrice",Money.rebirthPrice(state))
end

function Money.join(player,plot)
	local state = { cash = 150, level = 1, rebirths = 0, plot = plot, loaded = not store }
	Money.states[player] = state
	Money.publish(player,state)
	if store then
		task.spawn(function()
			local ok, saved = pcall(store.GetAsync,store,tostring(player.UserId))
			if Money.states[player] ~= state then
				return
			end
			if ok then
				if type(saved) == "number" and saved >= 0 then
					state.rebirths = math.floor(saved)
				end
				state.loaded = true
				Money.publish(player,state)
			else
				warn("Rebirth load unavailable for",player.UserId,saved)
			end
		end)
	end
	return state
end

function Money.save(player,state)
	if not store or not state.loaded or state.rebirths == 0 then
		return
	end
	local count = state.rebirths
	local ok, failure = pcall(store.UpdateAsync,store,tostring(player.UserId),function(previous)
		return math.max(type(previous) == "number" and previous or 0,count)
	end)
	if not ok then
		warn("Rebirth save failed for",player.UserId,failure)
	end
end

function Money.credit(player,state,amount)
	state.cash += amount
	Money.publish(player,state)
end

function Money.spend(player,state,amount)
	if state.cash < amount then
		return false
	end
	Money.credit(player,state,-amount)
	return true
end

function Money.tick()
	for player, state in Money.states do
		Money.credit(player,state,rate(state))
	end
end

return Money
