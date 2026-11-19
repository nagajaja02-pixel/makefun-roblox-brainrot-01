local W=require(script.Parent.World)
local B={plots={}}
local accents={Color3.fromRGB(27,192,190),Color3.fromRGB(250,115,93),Color3.fromRGB(85,144,247),Color3.fromRGB(197,119,247),Color3.fromRGB(103,200,92),Color3.fromRGB(248,177,56)}
function B.build()
 for index=1,6 do
  local x=({-82,0,82})[(index-1)%3+1]
  local z=index<=3 and -51 or 51
  local origin=CFrame.new(x,0,z)*CFrame.Angles(0,z<0 and math.pi or 0,0)
  local folder=Instance.new("Model") folder.Name=string.format("Safehouse%02d",index) folder.Parent=W.root
  local plot={index=index,origin=origin,model=folder,slots={},barriers={},activeUntil=0,cooldownUntil=0}
  local function p(n,s,pos,col)
   return W.part(folder,n,s,origin*CFrame.new(pos),col)
  end
  p("Deck",Vector3.new(26,0.8,40),Vector3.new(0,0,0),W.ink)
  -- Solid lower and upper walls retain the collision of the glazed ribbon.
  for _,side in ipairs({-1,1}) do
   p("Side lower wall",Vector3.new(1,5,40),Vector3.new(side*12.5,2.9,0),W.white)
   local glass=p("Collision window",Vector3.new(1,3.25,37.6),Vector3.new(side*12.5,7.025,0),accents[index]) glass.Transparency=0.78 glass.Material=Enum.Material.Glass
   p("Side upper wall",Vector3.new(1,0.95,40),Vector3.new(side*12.5,9.125,0),W.white)
   p("Front wall",Vector3.new(9.5,9.2,1),Vector3.new(side*7.75,5, -19.5),W.white)
   for _,endZ in ipairs({-19.4,19.4}) do p("Corner pillar",Vector3.new(1.2,9.2,1.2),Vector3.new(side*12.4,5,endZ),W.ink) end
   p("Canopy wing",Vector3.new(14,0.6,33),Vector3.new(side*6.5,10, -2),accents[index])
  end
  p("Rear wall",Vector3.new(26,9.2,1),Vector3.new(0,5,19.5),W.white)
  p("Door lintel",Vector3.new(6,2.1,1),Vector3.new(0,8.55,-19.5),W.white)
  p("Service canopy",Vector3.new(27,0.6,9),Vector3.new(0,11.5,15.5),W.steel)
  W.sign(p("Name board",Vector3.new(19,2.2,0.25),Vector3.new(0,10,-20.1),W.ink),string.format("SAFEHOUSE %02d",index),accents[index])
  local zone=p("Delivery zone",Vector3.new(6,0.12,9),Vector3.new(0,0.47,-11),accents[index])
  local board=p("Delivery board",Vector3.new(8,1.4,0.2),Vector3.new(0,2,18.8),W.ink)
  W.sign(board,"DELIVERY / WAVE SHELTER")
  plot.shieldTerminal=p("SHIELD",Vector3.new(2,3,2),Vector3.new(-4,1.9,-17),accents[index])
  W.sign(plot.shieldTerminal,"SHIELD")
  plot.upgradeTerminal=p("EXPAND BASE",Vector3.new(2,3,2),Vector3.new(4,1.9,-17),W.gold)
  W.sign(plot.upgradeTerminal,"EXPAND BASE")
  local slotIndex=0
  for row=1,4 do for _,col in ipairs({-8,8}) do
   slotIndex+=1
   local pos=Vector3.new(col,0.8,({-11,-4,3,10})[row])
   local stand=p("Stand "..slotIndex,Vector3.new(4.5,0.8,4.5),pos,slotIndex<=4 and W.aqua or W.steel)
   plot.slots[slotIndex]={part=stand,cf=origin*CFrame.new(pos+Vector3.new(0,0.4,0)),item=nil,inTransit=false}
  end end
  local spawn=Instance.new("SpawnLocation") spawn.Name="Home spawn" spawn.Size=Vector3.new(4,0.2,4) spawn.CFrame=origin*CFrame.new(0,0.6,6) spawn.Transparency=1 spawn.CanCollide=false spawn.Neutral=true spawn.Parent=folder plot.spawn=spawn
  table.insert(B.plots,plot)
 end
end
function B.claim(player)
 for _,plot in ipairs(B.plots) do if not plot.owner then plot.owner=player player.RespawnLocation=plot.spawn player:SetAttribute("Plot",plot.index) return plot end end
 return nil
end
function B.get(player)
 for _,plot in ipairs(B.plots) do if plot.owner==player then return plot end end
end
function B.isSheltered(plot,position)
 local v=plot.origin:PointToObjectSpace(position)
 return math.abs(v.X)<12.2 and v.Z>-19 and v.Z<19 and v.Y>=0 and v.Y<13
end
function B.free(player)
 local plot=B.get(player) if not plot then return end
 for _,slot in ipairs(plot.slots) do if slot.item and slot.item.model then slot.item.model:Destroy() end slot.item=nil slot.inTransit=false end
 plot.owner=nil plot.activeUntil=0 plot.cooldownUntil=0
end
function B.freeSlot(player)
 local plot=B.get(player) if not plot then return end
 local cap=player:GetAttribute("Capacity") or 4
 for i,slot in ipairs(plot.slots) do if i<=cap and not slot.item then return slot end end
end
function B.refresh(player)
 local plot=B.get(player) if not plot then return end
 for i,s in ipairs(plot.slots) do s.part.Color=i<=(player:GetAttribute("Capacity") or 4) and W.aqua or W.steel end
end
return B
