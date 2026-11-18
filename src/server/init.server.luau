local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local World = require(script.World)
local Base = require(script.BaseService)
local Money = require(script.MoneyService)
local Shield = require(script.ShieldService)
local Steal = require(script.StealService)
local Merchant = require(script.MerchantService)
local Conveyor = require(script.ConveyorService)
local Wave = require(script.WaveService)
local started = workspace:GetServerTimeNow()

local net = Instance.new("Folder")
net.Name = "BlitzEvents"
local notice = Instance.new("RemoteEvent")
notice.Name = "Notice"
notice.Parent = net
local rebirth = Instance.new("RemoteEvent")
rebirth.Name = "Rebirth"
rebirth.Parent = net

local harbor = World.build()
local plots = Base.build(harbor)
Shield.build(plots)
Merchant.build(harbor,notice)
local moveBelt = Conveyor.start(harbor)
local moveWave = Wave.start(harbor,plots,notice,started)

local function tell(player,text,seconds)
	notice:FireClient(player,text,seconds or 3)
end

local function setPlot(player,plot)
	local state = Money.states[player]
	state.plot = plot
	player:SetAttribute("HasSafehouse",plot ~= nil)
	if plot then
		Base.paint(plot,Money.capacity(state))
	end
end

local function setupCharacter(player,character)
	local human = character:WaitForChild("Humanoid")
	local root = character:WaitForChild("HumanoidRootPart")
	local state = Money.states[player]
	if not state or player.Character ~= character then
		return
	end
	if not state.plot then
		setPlot(player,Base.claim(plots,player))
	end
	Shield.assign(character,state.plot)
	local spawn = state.plot and state.plot.origin*CFrame.new(0,3.5,-14.9) or CFrame.new(0,4,-23)
	character:PivotTo(spawn)
	human.Died:Connect(function()
		Steal.returnItem(player)
	end)
end

local function join(player)
	if Money.states[player] then
		return
	end
	local plot = Base.claim(plots,player)
	Money.join(player,plot)
	setPlot(player,plot)
	player:SetAttribute("Carrying",false)
	player.CharacterRemoving:Connect(function()
		Steal.returnItem(player)
	end)
	player.CharacterAdded:Connect(function(character)
		setupCharacter(player,character)
	end)
	if player.Character then
		task.spawn(setupCharacter,player,player.Character)
	end
end

local function leave(player)
	local state = Money.states[player]
	if not state then
		return
	end
	Steal.returnItem(player)
	local plot = state.plot
	if plot then
		Steal.clearPlot(plot)
		Shield.reset(plot)
		Base.release(plot)
	end
	Money.states[player] = nil
	Money.save(player,state)
end

for _, plot in plots do
	plot.shieldPrompt.Triggered:Connect(function(player)
		if plot.owner ~= player or not Steal.near(player,plot.shieldPrompt.Parent,8) then
			return
		end
		local now = workspace:GetServerTimeNow()
		if Shield.activate(plot,now) then
			tell(player,"Shield active for 26 seconds.")
		else
			tell(player,("Shield ready in %ds."):format(math.ceil(plot.shieldReady-now)))
		end
	end)
	plot.expandPrompt.Triggered:Connect(function(player)
		if plot.owner ~= player or not Steal.near(player,plot.expandPrompt.Parent,8) then
			return
		end
		local state = Money.states[player]
		if Money.capacity(state) >= #plot.slots then
			tell(player,"Safehouse is fully expanded.")
			return
		end
		local cost = Money.upgradePrice(state)
		if Money.spend(player,state,cost) then
			state.level += 1
			Base.paint(plot,Money.capacity(state))
			Money.publish(player,state)
			tell(player,("Safehouse expanded to %d stands."):format(Money.capacity(state)))
		else
			tell(player,("Expansion costs $%d."):format(cost))
		end
	end)
end

rebirth.OnServerEvent:Connect(function(player,quotedPrice)
	local state = Money.states[player]
	if not state or not state.plot then
		return
	end
	if not state.loaded then
		tell(player,"Rebirth data is unavailable.")
		return
	end
	local price = Money.rebirthPrice(state)
	if quotedPrice ~= price or state.cash < price then
		tell(player,("Rebirth costs $%d."):format(price))
		return
	end
	if Steal.carrying[player] or Steal.hasTransit(state.plot) then
		tell(player,"Resolve all carried or raided brainrot first.")
		return
	end
	Steal.clearPlot(state.plot)
	state.rebirths += 1
	state.cash = 150
	Money.publish(player,state)
	tell(player,"Rebirth complete! Income bonus increased.")
	task.spawn(Money.save,player,state)
end)

Players.PlayerAdded:Connect(join)
Players.PlayerRemoving:Connect(leave)
for _, player in Players:GetPlayers() do
	join(player)
end
net.Parent = ReplicatedStorage

game:BindToClose(function()
	local pending = 0
	for player,state in Money.states do
		pending += 1
		task.spawn(function()
			Money.save(player,state)
			pending -= 1
		end)
	end
	while pending > 0 do
		task.wait()
	end
end)

local incomeElapsed, beltElapsed = 0,0
local beltStep = 1/24
RunService.Heartbeat:Connect(function(dt)
	local now = workspace:GetServerTimeNow()
	Shield.step(plots,now)
	Steal.step()
	moveWave(now)
	incomeElapsed += dt
	while incomeElapsed >= 1 do
		incomeElapsed -= 1
		Money.tick()
	end
	beltElapsed += dt
	while beltElapsed >= beltStep do
		beltElapsed -= beltStep
		moveBelt(beltStep)
	end
end)
