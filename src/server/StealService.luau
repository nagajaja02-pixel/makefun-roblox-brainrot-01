local W=require(script.Parent.World)
local B=require(script.Parent.BaseService)
local E=require(script.Parent.MoneyService)
local Shield=require(script.Parent.ShieldService)
local S={carriers={}}
local Players=game:GetService("Players")
function S.near(player,part)
 local character=player.Character
 local root=character and character:FindFirstChild("HumanoidRootPart")
 local humanoid=character and character:FindFirstChildOfClass("Humanoid")
 return root and humanoid and humanoid.Health>0 and (root.Position-part.Position).Magnitude<=12
end
function S.prompts(item,enabled)
 for _,v in ipairs(item.model:GetDescendants()) do if v:IsA("ProximityPrompt") then v.Enabled=enabled end end
end
function S.anchor(item,anchored)
 for _,v in ipairs(item.model:GetDescendants()) do if v:IsA("BasePart") then v.Anchored=anchored v.CanCollide=false end end
end
function S.park(item,owner,slot)
 if item.weld then item.weld:Destroy() item.weld=nil end
 item.owner=owner item.slot=slot
 slot.item=item slot.inTransit=false
 S.anchor(item,true) item.model:PivotTo(slot.cf)
 S.prompts(item,true)
end
function S.clearCarry(player)
 local carry=S.carriers[player]
 if not carry then return end
 S.carriers[player]=nil player:SetAttribute("Carrying",false)
 if carry.item.weld then carry.item.weld:Destroy() carry.item.weld=nil end
 return carry
end
function S.restore(player)
 local carry=S.clearCarry(player) if not carry then return end
 local item=carry.item
 if carry.originOwner and carry.originOwner.Parent==Players and carry.originSlot then
  S.park(item,carry.originOwner,carry.originSlot)
 else
  if carry.originSlot then carry.originSlot.item=nil carry.originSlot.inTransit=false end
  item.model:Destroy()
 end
end
function S.carry(player,item,kind)
 if S.carriers[player] or not S.near(player,item.model.PrimaryPart) or not B.get(player) then return false end
 local root=player.Character.HumanoidRootPart
 local own=B.get(player)
 if kind=="raid" and not B.freeSlot(player) then return false end
 local carry={item=item,originSlot=item.slot,originOwner=item.owner,kind=kind,left=not B.isSheltered(own,root.Position)}
 if item.slot then item.slot.inTransit=true end
 S.carriers[player]=carry player:SetAttribute("Carrying",true)
 S.prompts(item,false)
 S.anchor(item,true) item.model:PivotTo(root.CFrame*CFrame.new(0,4.45,-0.35))
 for _,part in ipairs(item.model:GetDescendants()) do
  if part:IsA("BasePart") and part~=item.model.PrimaryPart then
   local weld=Instance.new("WeldConstraint") weld.Part0=item.model.PrimaryPart weld.Part1=part weld.Parent=part
  end
 end
 S.anchor(item,false)
 local weld=Instance.new("WeldConstraint") weld.Part0=root weld.Part1=item.model.PrimaryPart weld.Parent=item.model.PrimaryPart item.weld=weld
 return true
end
function S.attach(item)
 local root=item.model.PrimaryPart
 W.prompt(root,"Pick Up","Your brainrot",function(player)
  local slot=item.slot
  if item.owner~=player or not slot or slot.item~=item or slot.inTransit then return end
  S.carry(player,item,"pickup")
 end)
 W.prompt(root,"Raid","Steal brainrot",function(player)
  local victim=item.owner local slot=item.slot
  if not victim or victim==player or not slot or slot.item~=item or slot.inTransit then return end
  local plot=B.get(victim)
  if not plot or Shield.active(plot) then return end
  S.carry(player,item,"raid")
 end,1.25)
end
function S.deliver(player)
 local carry=S.carriers[player] if not carry then return end
 local slot=B.freeSlot(player)
 if not slot and carry.originOwner==player then slot=carry.originSlot end
 if not slot then return end
 S.clearCarry(player)
 if carry.originSlot then carry.originSlot.item=nil carry.originSlot.inTransit=false end
 S.park(carry.item,player,slot)
 S.notify(player,"Delivered to your safehouse!")
end
function S.sell(player)
 local carry=S.clearCarry(player)
 if not carry then return "Carry a brainrot to sell it." end
 if carry.originSlot then carry.originSlot.item=nil carry.originSlot.inTransit=false end
 E.add(player,math.floor(carry.item.price*0.5))
 carry.item.model:Destroy()
 return "Sold for 50% of purchase price."
end
function S.step()
 for player,carry in pairs(S.carriers) do
  local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
  local hum=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
  if not root or not hum or hum.Health<=0 then S.restore(player)
  else
   local own=B.get(player)
   if carry.kind=="raid" then
    local victim=B.get(carry.originOwner)
    if victim and B.isSheltered(victim,root.Position) then
     if carry.exitedVictim then S.restore(player) continue end
    else carry.exitedVictim=true end
   end
   if own then
    local inside=B.isSheltered(own,root.Position)
    if not inside then carry.left=true elseif carry.left then S.deliver(player) end
   end
  end
 end
end
function S.leaving(player)
 S.restore(player)
 local affected={}
 for raider,carry in pairs(S.carriers) do if carry.originOwner==player then table.insert(affected,raider) end end
 for _,raider in ipairs(affected) do S.restore(raider) end
end
function S.init(notify) S.notify=notify end
return S
