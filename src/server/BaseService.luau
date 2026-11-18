local World=require(script.Parent.World)
local Money=require(script.Parent.MoneyService)
local Models=require(script.Parent.BrainrotModels)
local Base={plots={},byPlayer={}}
local C=World.Colors
local accents={Color3.fromRGB(27,192,190),Color3.fromRGB(250,115,93),Color3.fromRGB(85,144,247),Color3.fromRGB(197,119,247),Color3.fromRGB(103,200,92),Color3.fromRGB(248,177,56)}
function Base.localPoint(plot,position) return plot.cf:PointToObjectSpace(position) end
function Base.isSheltered(plot,position)
 local p=Base.localPoint(plot,position)
 return math.abs(p.X)<12.2 and p.Z> -19 and p.Z<19 and p.Y>=0 and p.Y<13
end
function Base.near(player,part,range)
 local char=player.Character local root=char and char:FindFirstChild("HumanoidRootPart") local humanoid=char and char:FindFirstChildOfClass("Humanoid")
 return root and humanoid and humanoid.Health>0 and (root.Position-part.Position).Magnitude<=(range or 12)
end
function Base.build(root)
 local positions={{-82,-51},{0,-51},{82,-51},{-82,51},{0,51},{82,51}}
 for i,pos in ipairs(positions) do
  local folder=Instance.new("Model") folder.Name=string.format("Safehouse%02d",i) folder.Parent=root
  local plot={id=i,folder=folder,cf=CFrame.new(pos[1],0,pos[2])*CFrame.Angles(0,pos[2]<0 and math.pi or 0,0),stands={},shieldUntil=0,cooldownUntil=0}
  Base.plots[i]=plot
  local function part(name,size,x,y,z,color)
   return World.part(folder,name,size,plot.cf*CFrame.new(x,y,z),color)
  end
  part("Deck",Vector3.new(26,0.8,40),0,0,0,C.ink)
  for _,x in ipairs({-12.5,12.5}) do
   part("FullSideWall",Vector3.new(1,9.2,40),x,5,0,accents[i])
   local glass=part("SideWindowRibbon",Vector3.new(1.04,3.25,30),x,7.025,0,Color3.fromRGB(164,231,245)) glass.Material=Enum.Material.Glass glass.Transparency=0.78
  end
  part("RearWall",Vector3.new(24,9.2,1),0,5,19.5,accents[i])
  for _,x in ipairs({-7.5,7.5}) do
   part("FrontWall",Vector3.new(9,9.2,1),x,5,-19.5,accents[i])
   local glass=part("FrontWindowRibbon",Vector3.new(7,3.25,1.04),x,7.025,-19.5,Color3.fromRGB(164,231,245)) glass.Material=Enum.Material.Glass glass.Transparency=0.78
  end
  part("DoorLintel",Vector3.new(6,2.1,1),0,8.55,-19.5,accents[i])
  for _,x in ipairs({-12.4,12.4}) do for _,z in ipairs({-19.4,19.4}) do part("CornerPillar",Vector3.new(1.2,9.2,1.2),x,5,z,C.ink) end end
  for _,x in ipairs({-8,8}) do part("CanopyWing",Vector3.new(10,0.5,43),x,10.1,0,accents[i]) end
  part("RearServiceCanopy",Vector3.new(26,0.6,9),0,11.2,16,accents[i])
  local board=part("SafehouseName",Vector3.new(20,2.5,0.3),0,10,-20.1,C.ink)
  plot.nameLabel=World.sign(folder,board,string.format("SAFEHOUSE %02d",i),C.white,35)
  local delivery=part("DeliveryZone",Vector3.new(7,0.08,8),0,0.45,-10,C.aqua) delivery.Transparency=0.35 delivery.CanCollide=false
  local dropSign=part("DeliverySign",Vector3.new(7,1.7,0.2),0,1.5,16,C.ink) World.sign(folder,dropSign,"DELIVERY / WAVE SHELTER",C.aqua,25)
  plot.shieldTerminal=part("ShieldTerminal",Vector3.new(2,2.2,1.2),-4.7,1.5,-17,C.ink)
  World.sign(folder,plot.shieldTerminal,"SHIELD",C.aqua,32)
  World.prompt(plot.shieldTerminal,"Activate Shield","26 seconds / 48s cooldown",0,function(player)
   if plot.owner==player and Base.near(player,plot.shieldTerminal) and Base.onShield then Base.onShield(player) end
  end)
  plot.upgradeTerminal=part("ExpandTerminal",Vector3.new(2,2.2,1.2),4.7,1.5,-17,C.ink)
  World.sign(folder,plot.upgradeTerminal,"EXPAND BASE",C.gold,24)
  World.prompt(plot.upgradeTerminal,"Expand Base","4 → 6 → 8 stands",0,function(player)
   if plot.owner==player and Base.near(player,plot.upgradeTerminal) then
    local ok=Money.upgrade(player) Base.refresh(player)
    Base.notify(player,ok and "Safehouse expanded." or "Need more cash, or all 8 stands are unlocked.")
   end
  end)
  for row,z in ipairs({-11,-4,3,10}) do for col,x in ipairs({-8,8}) do
   local n=(row-1)*2+col
   plot.stands[n]=part("Stand"..n,Vector3.new(4.5,0.6,4.5),x,0.7,z,n<=4 and C.aqua or C.steel)
  end end
 end
end
function Base.assign(player)
 for _,plot in ipairs(Base.plots) do
  if not plot.owner then plot.owner=player Base.byPlayer[player]=plot player:SetAttribute("Plot",plot.id) Base.refresh(player) return plot end
 end
end
function Base.refresh(player)
 local plot=Base.byPlayer[player] local s=Money.states[player] if not plot or not s then return end
 plot.nameLabel.Text=string.format("SAFEHOUSE %02d\n%s",plot.id,player.DisplayName)
 for i,stand in ipairs(plot.stands) do stand.Color=i<=Money.capacity(s) and C.aqua or C.steel end
end
function Base.freeSlot(player)
 local s=Money.states[player] if not s then return end
 for i=1,Money.capacity(s) do if not s.slots[i] then return i end end
end
function Base.park(player,index,slot)
 local plot=Base.byPlayer[player] if not plot then return end
 Models.anchor(slot.model,true)
 slot.model:PivotTo(plot.stands[index].CFrame*CFrame.new(0,0.32,0))
 slot.inTransit=false
 if Base.bindPrompts then Base.bindPrompts(player,index,slot) end
 Money.publish(player)
end
function Base.install(player,offer,model)
 local index=Base.freeSlot(player) if not index then return false end
 local slot={offer=offer,model=model,inTransit=false}
 Money.states[player].slots[index]=slot Base.park(player,index,slot) return true
end
function Base.clear(player)
 local s=Money.states[player] if not s then return end
 for _,slot in pairs(s.slots) do slot.model:Destroy() end
 s.slots={} Money.publish(player) Base.refresh(player)
end
function Base.release(player)
 Base.clear(player)
 local plot=Base.byPlayer[player]
 if plot then plot.owner=nil plot.shieldUntil=0 plot.cooldownUntil=0 plot.nameLabel.Text=string.format("SAFEHOUSE %02d",plot.id) end
 Base.byPlayer[player]=nil
end
Base.notify=function() end
return Base
