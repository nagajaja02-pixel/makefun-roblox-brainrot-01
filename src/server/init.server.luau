local Players=game:GetService("Players")
local Replicated=game:GetService("ReplicatedStorage")
local Run=game:GetService("RunService")
local World=require(script.World)
local Bases=require(script.BaseService)
local Money=require(script.MoneyService)
local Steal=require(script.StealService)
local Shield=require(script.ShieldService)
local Conveyor=require(script.ConveyorService)
local Waves=require(script.WaveService)
local Merchant=require(script.MerchantService)
local remotes=Instance.new("Folder") remotes.Name="BlitzRemotes" remotes.Parent=Replicated
local notice=Instance.new("RemoteEvent") notice.Name="Notice" notice.Parent=remotes
local action=Instance.new("RemoteEvent") action.Name="Action" action.Parent=remotes
local function notify(player,message) notice:FireClient(player,message) end
World.build() Bases.build() Shield.build() Steal.init(notify)
Conveyor.init(notify) Waves.init(notify,workspace:GetServerTimeNow()) Merchant.build(notify)
for _,plot in ipairs(Bases.plots) do
 World.prompt(plot.shieldTerminal,"Activate","SHIELD · 26s active / 48s recharge",function(player)
  if plot.owner==player and Steal.near(player,plot.shieldTerminal) then notify(player,Shield.activate(player)) end
 end)
 World.prompt(plot.upgradeTerminal,"Expand","EXPAND BASE",function(player)
  if plot.owner==player and Steal.near(player,plot.upgradeTerminal) then notify(player,Money.upgrade(player)) end
 end)
end
local function join(player)
 local plot=Bases.claim(player)
 if not plot then player:Kick("All six safehouses are occupied. Please join another server.") return end
 local function character(char)
  Shield.character(player,char)
  local root=char:WaitForChild("HumanoidRootPart",10)
  local hum=char:WaitForChild("Humanoid",10)
  if root then char:PivotTo(plot.origin*CFrame.new(0,4,6)) end
  if hum then hum.Died:Connect(function() Steal.restore(player) end) end
 end
 player.CharacterAdded:Connect(character)
 if player.Character then task.spawn(character,player.Character) end
 Money.join(player)
end
Players.PlayerAdded:Connect(join)
for _,p in ipairs(Players:GetPlayers()) do task.spawn(join,p) end
Players.PlayerRemoving:Connect(function(player)
 Steal.leaving(player) Money.save(player) Bases.free(player)
end)
local lastAction={}
action.OnServerEvent:Connect(function(player,kind)
 local now=workspace:GetServerTimeNow()
 if now-(lastAction[player] or 0)<0.5 then return end
 lastAction[player]=now
 if kind=="Rebirth" then notify(player,Money.rebirth(player)) end
end)
Players.PlayerRemoving:Connect(function(player) lastAction[player]=nil end)
game:BindToClose(function() for _,p in ipairs(Players:GetPlayers()) do Money.save(p) end end)
local income,conveyor=0,0
Run.Heartbeat:Connect(function(dt)
 local now=workspace:GetServerTimeNow()
 income+=dt conveyor+=dt
 while income>=1 do income-=1 Money.income() end
 if conveyor>=1/24 then
  Conveyor.step(conveyor,now) conveyor=0
  Steal.step() Shield.step(now)
 end
 Waves.step(now)
end)
