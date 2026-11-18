local Players=game:GetService("Players")
local World=require(script.Parent.World)
local Base=require(script.Parent.BaseService)
local Wave={phase="CALM",nextAt=0,hit={}}
function Wave.start(remote)
 Wave.remote=remote Wave.nextAt=os.clock()+52
end
function Wave.broadcast(text)
 Wave.remote:FireAllClients("Notice",text)
end
function Wave.step()
 local now=os.clock()
 if Wave.phase=="CALM" and now>=Wave.nextAt then
  Wave.phase="EVACUATE" Wave.endsAt=now+14
  Wave.broadcast("Tsunami incoming! Reach your safehouse.")
 elseif Wave.phase=="EVACUATE" and now>=Wave.endsAt then
  Wave.phase="TSUNAMI" Wave.startedAt=now Wave.endsAt=now+8 Wave.hit={}
  Wave.wall=World.part(World.root,"TsunamiWater",Vector3.new(11,16,200),CFrame.new(-146,8,0),Color3.fromRGB(29,157,235),Enum.Material.Glass,false)
  Wave.wall.Transparency=0.3
  Wave.crest=World.part(World.root,"TsunamiCrest",Vector3.new(12,2,200),CFrame.new(-146,16,0),Color3.fromRGB(170,246,255),Enum.Material.Neon,false)
 elseif Wave.phase=="TSUNAMI" then
  local progress=math.clamp((now-Wave.startedAt)/8,0,1)
  local x=-146+292*progress
  Wave.wall.CFrame=CFrame.new(x,8,0) Wave.crest.CFrame=CFrame.new(x,16,0)
  for _,player in ipairs(Players:GetPlayers()) do
   local character=player.Character local root=character and character:FindFirstChild("HumanoidRootPart") local hum=character and character:FindFirstChildOfClass("Humanoid")
   if root and hum and hum.Health>0 and not Wave.hit[player] and math.abs(root.Position.X-x)<=8 and math.abs(root.Position.Z)<=100 then
    Wave.hit[player]=true
    local plot=Base.byPlayer[player]
    if plot and Base.isSheltered(plot,root.Position) then Wave.remote:FireClient(player,"Notice","Safehouse held.")
    else hum.Health=0 Wave.remote:FireClient(player,"Notice","Swept away!") end
   end
  end
  if now>=Wave.endsAt then
   Wave.wall:Destroy() Wave.crest:Destroy() Wave.phase="CALM" Wave.nextAt=now+54
   Wave.broadcast("Harbor clear. Back to business!")
  end
 end
 local deadline=Wave.phase=="CALM" and Wave.nextAt or Wave.endsAt
 workspace:SetAttribute("WavePhase",Wave.phase) workspace:SetAttribute("WaveSeconds",math.max(0,math.ceil(deadline-now)))
end
return Wave
