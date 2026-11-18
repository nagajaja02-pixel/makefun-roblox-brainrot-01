local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local World=require(script.World)
local Money=require(script.MoneyService)
local Base=require(script.BaseService)
local Shield=require(script.ShieldService)
local Steal=require(script.StealService)
local Conveyor=require(script.ConveyorService)
local Wave=require(script.WaveService)
local Merchant=require(script.MerchantService)
-- Reserve at most six players through Base.assign; MaxPlayers is configured by the experience.
local remote=Instance.new("RemoteEvent") remote.Name="BlitzEvent" remote.Parent=ReplicatedStorage
Base.notify=function(player,text) if player.Parent==Players then remote:FireClient(player,"Notice",text) end end
World.build() Base.build(World.root) Shield.setup()
Base.bindPrompts=Steal.bind Base.onShield=Shield.activate
Merchant.build() Conveyor.start() Wave.start(remote)
local function onCharacter(player,character)
 Shield.character(player,character)
 local humanoid=character:WaitForChild("Humanoid",10)
 if humanoid then humanoid.Died:Connect(function() Steal.restore(player) end) end
 local root=character:WaitForChild("HumanoidRootPart",10)
 local plot=Base.byPlayer[player]
 if root and plot then character:PivotTo(plot.cf*CFrame.new(0,3,-12)) end
end
local function join(player)
 local plot=Base.assign(player)
 if not plot then player:Kick("All six safehouses are occupied. Please join another harbor.") return end
 local characterConnection=player.CharacterAdded:Connect(function(character) onCharacter(player,character) end)
 if player.Character then task.spawn(onCharacter,player,player.Character) end
 local state=Money.addPlayer(player)
 if not state then return end
 Base.refresh(player) player:SetAttribute("Carrying",false)
 Base.notify(player,"Welcome to Brainrot Blitz! Buy a brainrot on the conveyor with your $150.")
end
Players.PlayerAdded:Connect(join)
for _,player in ipairs(Players:GetPlayers()) do task.spawn(join,player) end
Players.PlayerRemoving:Connect(function(player)
 Steal.depart(player) Money.save(player) Base.release(player) Money.states[player]=nil
end)
local lastAction={}
remote.OnServerEvent:Connect(function(player,action)
 if type(action)~="string" then return end
 local now=os.clock()
 if now-(lastAction[player] or -1)<0.35 then return end
 lastAction[player]=now
 local char=player.Character local hum=char and char:FindFirstChildOfClass("Humanoid")
 if not hum or hum.Health<=0 then return end
 if action=="Rebirth" then
  local ok,message=Money.rebirth(player,Base.clear) Base.refresh(player) Base.notify(player,message)
 elseif action=="Shield" then
  local plot=Base.byPlayer[player]
  if plot and Base.near(player,plot.shieldTerminal) then Shield.activate(player) end
 end
end)
Players.PlayerRemoving:Connect(function(player) lastAction[player]=nil end)
local incomeClock,beltClock=0,0
RunService.Heartbeat:Connect(function(dt)
 incomeClock+=dt beltClock+=dt
 while incomeClock>=1 do incomeClock-=1 Money.tick() end
 while beltClock>=1/24 do beltClock-=1/24 Conveyor.step(1/24) end
 Steal.step() Shield.step() Wave.step()
end)
game:BindToClose(function()
 for _,player in ipairs(Players:GetPlayers()) do Money.save(player) end
end)
