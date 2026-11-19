local Physics=game:GetService("PhysicsService")
local B=require(script.Parent.BaseService)
local W=require(script.Parent.World)
local S={}
function S.active(plot,now) return (now or workspace:GetServerTimeNow())<plot.activeUntil end
function S.build()
 for i=1,6 do
  Physics:RegisterCollisionGroup("Owner"..i)
  Physics:RegisterCollisionGroup("Barrier"..i)
 end
 for i=1,6 do
  for j=1,6 do
   Physics:CollisionGroupSetCollidable("Owner"..i,"Owner"..j,true)
   Physics:CollisionGroupSetCollidable("Owner"..i,"Barrier"..j,i~=j)
   Physics:CollisionGroupSetCollidable("Barrier"..i,"Barrier"..j,false)
  end
  Physics:CollisionGroupSetCollidable("Default","Barrier"..i,true)
 end
 for _,plot in ipairs(B.plots) do
  local function add(name,size,cf,barrier)
   local p=W.part(plot.model,name,size,plot.origin*cf,W.aqua,Enum.Material.Neon)
   p.CollisionGroup="Barrier"..plot.index p.CanCollide=false p.Transparency=1
   table.insert(plot.barriers,{part=p,barrier=barrier})
  end
  for _,z in ipairs({-20,20}) do
   add("Laser barrier",Vector3.new(26,9.2,0.3),CFrame.new(0,5,z),true)
   add("Top frame",Vector3.new(26,0.26,0.26),CFrame.new(0,9.6,z),false)
   for x=-12,12,2 do add("Laser beam",Vector3.new(0.26,9.2,0.26),CFrame.new(x,5,z),false) end
  end
  for _,x in ipairs({-13,13}) do
   add("Laser barrier",Vector3.new(0.3,9.2,40),CFrame.new(x,5,0),true)
   add("Top frame",Vector3.new(0.26,0.26,40),CFrame.new(x,9.6,0),false)
   for z=-18,18,2 do add("Laser beam",Vector3.new(0.26,9.2,0.26),CFrame.new(x,5,z),false) end
  end
 end
end
function S.character(player,character)
 local plot=B.get(player)
 local group=plot and "Owner"..plot.index or "Default"
 local function set(instance) if instance:IsA("BasePart") then instance.CollisionGroup=group end end
 for _,v in ipairs(character:GetDescendants()) do set(v) end
 character.DescendantAdded:Connect(set)
end
function S.activate(player)
 local plot=B.get(player) if not plot then return "No safehouse available." end
 local activation=workspace:GetServerTimeNow()
 if activation<plot.cooldownUntil then return "Shield is recharging." end
 plot.activeUntil=activation+26
 plot.cooldownUntil=activation+26+48
 player:SetAttribute("ShieldUntil",plot.activeUntil) player:SetAttribute("CooldownUntil",plot.cooldownUntil)
 S.step(activation)
 return "Shield online for 26 seconds!"
end
function S.step(now)
 for _,plot in ipairs(B.plots) do
  local active=S.active(plot,now)
  for _,entry in ipairs(plot.barriers) do
   entry.part.CanCollide=active and entry.barrier
   entry.part.Transparency=active and (entry.barrier and 0.83 or 0.16) or 1
  end
 end
end
return S
