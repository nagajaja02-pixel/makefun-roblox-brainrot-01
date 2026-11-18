local Physics=game:GetService("PhysicsService")
local Players=game:GetService("Players")
local World=require(script.Parent.World)
local Base=require(script.Parent.BaseService)
local Shield={}
function Shield.setup()
 for i=1,6 do
  Physics:RegisterCollisionGroup("BlitzOwner"..i)
  Physics:RegisterCollisionGroup("BlitzBarrier"..i)
 end
 for i=1,6 do
  Physics:CollisionGroupSetCollidable("Default","BlitzBarrier"..i,true)
  for j=1,6 do
   Physics:CollisionGroupSetCollidable("BlitzOwner"..j,"BlitzBarrier"..i,i~=j)
   Physics:CollisionGroupSetCollidable("BlitzBarrier"..i,"BlitzBarrier"..j,false)
   Physics:CollisionGroupSetCollidable("BlitzOwner"..i,"BlitzOwner"..j,true)
  end
  local plot=Base.plots[i] plot.barriers={} plot.lasers={}
  local function laser(name,size,cf,physical)
   local p=World.part(plot.folder,name,size,plot.cf*cf,World.Colors.aqua,Enum.Material.Neon,false)
   p.Transparency=1 p.CollisionGroup="BlitzBarrier"..i
   table.insert(physical and plot.barriers or plot.lasers,p)
  end
  for _,z in ipairs({-20,20}) do
   laser("ShieldPlane",Vector3.new(26,9.2,0.3),CFrame.new(0,5,z),true)
   laser("LaserTopFrame",Vector3.new(26,0.26,0.26),CFrame.new(0,9.6,z),false)
   for x=-12,12,2 do laser("LaserBar",Vector3.new(0.26,9.2,0.26),CFrame.new(x,5,z),false) end
  end
  for _,x in ipairs({-13,13}) do
   laser("ShieldPlane",Vector3.new(0.3,9.2,40),CFrame.new(x,5,0),true)
   laser("LaserTopFrame",Vector3.new(0.26,0.26,40),CFrame.new(x,9.6,0),false)
   for z=-18,18,2 do laser("LaserBar",Vector3.new(0.26,9.2,0.26),CFrame.new(x,5,z),false) end
  end
 end
end
function Shield.character(player,character)
 local plot=Base.byPlayer[player] if not plot then return end
 local function assign(part) if part:IsA("BasePart") then part.CollisionGroup="BlitzOwner"..plot.id end end
 for _,part in ipairs(character:GetDescendants()) do assign(part) end
 character.DescendantAdded:Connect(assign)
end
function Shield.active(player)
 local plot=Base.byPlayer[player] return plot and os.clock()<plot.shieldUntil
end
function Shield.activate(player)
 local plot=Base.byPlayer[player] local now=os.clock()
 if not plot or now<plot.cooldownUntil then Base.notify(player,"Shield is cooling down.") return false end
 plot.shieldUntil=now+26 plot.cooldownUntil=now+48
 Shield.step() Base.notify(player,"Shield active for 26 seconds.") return true
end
function Shield.step()
 local now=os.clock()
 for _,plot in ipairs(Base.plots) do
  local on=plot.owner~=nil and now<plot.shieldUntil
  for _,p in ipairs(plot.barriers) do p.CanCollide=on p.Transparency=on and 0.82 or 1 end
  for _,p in ipairs(plot.lasers) do p.Transparency=on and 0.3 or 1 end
  if plot.owner then
   plot.owner:SetAttribute("ShieldSeconds",math.max(0,math.ceil(plot.shieldUntil-now)))
   plot.owner:SetAttribute("ShieldCooldown",math.max(0,math.ceil(plot.cooldownUntil-now)))
  end
 end
end
return Shield
