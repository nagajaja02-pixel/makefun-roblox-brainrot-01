local Run=game:GetService("RunService")
local Store=game:GetService("DataStoreService"):GetDataStore("BlitzRebirthsV1")
local B=require(script.Parent.BaseService)
local E={}
function E.sync(player)
 local level=player:GetAttribute("Level") or 1
 local rebirths=player:GetAttribute("Rebirths") or 0
 player:SetAttribute("Capacity",4+(level-1)*2)
 player:SetAttribute("UpgradePrice",550*level*level)
 player:SetAttribute("RebirthPrice",12000*(rebirths+1))
 B.refresh(player)
end
function E.join(player)
 player:SetAttribute("Cash",150) player:SetAttribute("Level",1) player:SetAttribute("Rebirths",0)
 E.sync(player)
 if not Run:IsStudio() then
  local ok,value=pcall(function() return Store:GetAsync(tostring(player.UserId)) end)
  if ok and type(value)=="number" and value>=0 then player:SetAttribute("Rebirths",math.floor(value)) E.sync(player) end
 end
end
function E.save(player)
 if Run:IsStudio() then return end
 local count=player:GetAttribute("Rebirths") or 0
 local ok,err=pcall(function() Store:UpdateAsync(tostring(player.UserId),function(previous) return math.max(tonumber(previous) or 0,count) end) end)
 if not ok then warn("Rebirth save failed: ",err) end
end
function E.spend(player,cost)
 local cash=player:GetAttribute("Cash") or 0
 if cash<cost then return false end
 player:SetAttribute("Cash",cash-cost) return true
end
function E.add(player,amount)
 player:SetAttribute("Cash",(player:GetAttribute("Cash") or 0)+amount)
end
function E.upgrade(player)
 local level=player:GetAttribute("Level") or 1
 if level>=3 then return "All eight stands unlocked." end
 if not E.spend(player,550*level*level) then return "Not enough cash." end
 player:SetAttribute("Level",level+1) E.sync(player)
 return "Base expanded!"
end
function E.income()
 for _,plot in ipairs(B.plots) do if plot.owner then
  local rate=0
  for _,slot in ipairs(plot.slots) do if slot.item and not slot.inTransit then rate+=slot.item.rate end end
  local income=math.floor(rate*(1+0.5*(plot.owner:GetAttribute("Rebirths") or 0)))
  E.add(plot.owner,income) plot.owner:SetAttribute("Income",income)
 end end
end
function E.rebirth(player)
 if player:GetAttribute("Carrying") then return "Put down your brainrot first." end
 local plot=B.get(player) if not plot then return "No safehouse available." end
 for _,slot in ipairs(plot.slots) do if slot.inTransit then return "A raid is still in transit." end end
 if not E.spend(player,12000*((player:GetAttribute("Rebirths") or 0)+1)) then return "Not enough cash." end
 for _,slot in ipairs(plot.slots) do if slot.item then slot.item.model:Destroy() end slot.item=nil slot.inTransit=false end
 player:SetAttribute("Rebirths",(player:GetAttribute("Rebirths") or 0)+1)
 player:SetAttribute("Cash",150) player:SetAttribute("Level",1)
 E.sync(player) task.spawn(E.save,player)
 return "Reborn! Income increased by 50%."
end
return E
