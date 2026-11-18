local Base=require(script.Parent.BaseService)
local Money=require(script.Parent.MoneyService)
local Models=require(script.Parent.BrainrotModels)
local World=require(script.Parent.World)
local Shield=require(script.Parent.ShieldService)
local Steal={}
local function clearPrompts(model)
 for _,obj in ipairs(model:GetDescendants()) do if obj:IsA("ProximityPrompt") then obj:Destroy() end end
end
function Steal.bind(owner,index,slot)
 clearPrompts(slot.model)
 World.prompt(slot.model.PrimaryPart,"Pick Up",slot.offer.data.name,0,function(player)
  if player==owner then Steal.pickup(player,owner,index,slot) end
 end)
 World.prompt(slot.model.PrimaryPart,"Raid",slot.offer.data.name,1.25,function(player)
  if player~=owner then Steal.pickup(player,owner,index,slot) end
 end)
end
function Steal.pickup(player,owner,index,slot)
 local state=Money.states[player] local victim=Money.states[owner]
 local char=player.Character local hrp=char and char:FindFirstChild("HumanoidRootPart")
 if not state or state.loading or not victim or not hrp or state.carry or slot.inTransit or victim.slots[index]~=slot then return end
 if not Base.near(player,slot.model.PrimaryPart,11) then return end
 local raid=player~=owner
 if raid and (Shield.active(owner) or not Base.freeSlot(player)) then Base.notify(player,"Shield active or your safehouse is full.") return end
 local home=Base.byPlayer[player] if not home then return end
 slot.inTransit=true clearPrompts(slot.model)
 Models.rig(slot.model)
 slot.model:PivotTo(hrp.CFrame*CFrame.new(0,4.45,-0.35)) Models.anchor(slot.model,false)
 local weld=Instance.new("WeldConstraint") weld.Name="CarryWeld" weld.Part0=hrp weld.Part1=slot.model.PrimaryPart weld.Parent=slot.model.PrimaryPart
 state.carry={slot=slot,owner=owner,index=index,weld=weld,raid=raid,left=not Base.isSheltered(home,hrp.Position)}
 player:SetAttribute("Carrying",true) player:SetAttribute("CarriedName",slot.offer.data.name)
 Money.publish(owner)
 Base.notify(player,raid and "Raid! Reach your safehouse." or "Leave and re-enter your safehouse to deliver. Sell at the Brainrot Shop.")
end
function Steal.detach(player)
 local s=Money.states[player] local carry=s and s.carry if not carry then return end
 s.carry=nil player:SetAttribute("Carrying",false) player:SetAttribute("CarriedName","")
 if carry.weld then carry.weld:Destroy() end
 Models.anchor(carry.slot.model,true)
 for _,obj in ipairs(carry.slot.model.PrimaryPart:GetChildren()) do
  if obj:IsA("WeldConstraint") then obj:Destroy() end
 end
 return carry
end
function Steal.restore(player)
 local carry=Steal.detach(player) if not carry then return end
 local victim=Money.states[carry.owner]
 if victim and victim.slots[carry.index]==carry.slot and Base.byPlayer[carry.owner] then Base.park(carry.owner,carry.index,carry.slot)
 else carry.slot.model:Destroy() end
 Base.notify(player,"Brainrot returned to its stand.")
end
function Steal.deliver(player)
 local s=Money.states[player] local carry=s and s.carry if not carry then return end
 local destination=Base.freeSlot(player)
 if not destination and not carry.raid then destination=carry.index end
 if not destination then Base.notify(player,"Safehouse full. Expand or sell your carry.") return end
 carry=Steal.detach(player)
 local victim=Money.states[carry.owner]
 if victim then victim.slots[carry.index]=nil Money.publish(carry.owner) end
 s.slots[destination]=carry.slot Base.park(player,destination,carry.slot)
 Base.notify(player,carry.raid and "Raid delivered! This brainrot is yours." or "Delivery complete.")
end
function Steal.sell(player)
 local s=Money.states[player] local carry=s and s.carry if not carry then Base.notify(player,"Carry a brainrot here to sell it.") return end
 carry=Steal.detach(player)
 local victim=Money.states[carry.owner] if victim then victim.slots[carry.index]=nil Money.publish(carry.owner) end
 local price=math.floor(carry.slot.offer.price*0.5) carry.slot.model:Destroy() Money.credit(player,price)
 Base.notify(player,"Sold for $"..price..".")
end
function Steal.step()
 for player,s in pairs(Money.states) do
  local carry=s.carry
  if carry then
   local char=player.Character local hrp=char and char:FindFirstChild("HumanoidRootPart") local hum=char and char:FindFirstChildOfClass("Humanoid")
   local home=Base.byPlayer[player]
   if not hrp or not hum or hum.Health<=0 or not home then Steal.restore(player)
   else
    local inside=Base.isSheltered(home,hrp.Position)
    if not inside then carry.left=true end
    local victim=Base.byPlayer[carry.owner]
    if carry.raid and victim and Base.isSheltered(victim,hrp.Position) then
     if carry.leftVictim then Steal.restore(player) end
    else carry.leftVictim=true end
    if s.carry and inside and carry.left then Steal.deliver(player) end
   end
  end
 end
end
function Steal.depart(player)
 Steal.restore(player)
 for raider,s in pairs(Money.states) do if s.carry and s.carry.owner==player then Steal.restore(raider) end end
end
return Steal
