local Players=game:GetService("Players")
local B=require(script.Parent.BaseService)
local W=require(script.Parent.World)
local V={phase="CALM",hit={}}
function V.init(notify,now)
 V.notify=notify V.next=now+52
 V.wall=W.part(W.root,"Tsunami",Vector3.new(11,16,200),CFrame.new(-146,8,0),Color3.fromRGB(35,172,235),Enum.Material.Glass)
 V.wall.Transparency=1 V.wall.CanCollide=false
 V.crest=W.part(W.root,"Wave crest",Vector3.new(12,2,200),CFrame.new(-146,16,0),W.aqua,Enum.Material.Neon)
 V.crest.Transparency=1 V.crest.CanCollide=false
 workspace:SetAttribute("WavePhase","CALM") workspace:SetAttribute("WaveDeadline",V.next)
end
function V.step(now)
 if V.phase=="CALM" and now>=V.next then
  V.phase="EVACUATE" V.next=now+14
  for _,p in ipairs(Players:GetPlayers()) do V.notify(p,"Tsunami incoming! Reach your safehouse.") end
  workspace:SetAttribute("WavePhase",V.phase) workspace:SetAttribute("WaveDeadline",V.next)
 elseif V.phase=="EVACUATE" and now>=V.next then
  V.phase="SWEEP" V.started=now V.hit={} V.wall.Transparency=0.24 V.crest.Transparency=0.08
  workspace:SetAttribute("WavePhase",V.phase) workspace:SetAttribute("WaveDeadline",now+8)
 end
 if V.phase=="SWEEP" then
  local progress=math.clamp((now-V.started)/8,0,1)
  local x=-146+292*progress
  V.wall.CFrame=CFrame.new(x,8,0) V.crest.CFrame=CFrame.new(x,16,0)
  for _,player in ipairs(Players:GetPlayers()) do
   local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
   local hum=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
   if root and hum and hum.Health>0 and not V.hit[player] and math.abs(root.Position.X-x)<=8 and math.abs(root.Position.Z)<=100 then
    V.hit[player]=true
    local safe=false
    for _,plot in ipairs(B.plots) do if B.isSheltered(plot,root.Position) then safe=true break end end
    if safe then V.notify(player,"Safehouse held.") else hum.Health=0 V.notify(player,"Swept away!") end
   end
  end
  if progress>=1 then
   V.wall.Transparency=1 V.crest.Transparency=1 V.phase="CALM" V.next=now+54
   workspace:SetAttribute("WavePhase","CALM") workspace:SetAttribute("WaveDeadline",V.next)
  end
 end
end
return V
