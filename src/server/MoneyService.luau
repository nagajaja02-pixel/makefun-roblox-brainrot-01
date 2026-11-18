local Money={states={}}
local RunService=game:GetService("RunService")
local store=game:GetService("DataStoreService"):GetDataStore("BlitzRebirthsV1")
function Money.capacity(state) return 4+(state.level-1)*2 end
function Money.upgradePrice(state) return 550*state.level^2 end
function Money.rebirthPrice(state) return 12000*(state.rebirths+1) end
function Money.publish(player)
 local s=Money.states[player] if not s then return end
 local income=0
 for _,slot in pairs(s.slots) do if not slot.inTransit then income+=slot.offer.rate end end
 player:SetAttribute("Cash",s.cash) player:SetAttribute("Level",s.level) player:SetAttribute("Capacity",Money.capacity(s))
 player:SetAttribute("Rebirths",s.rebirths) player:SetAttribute("RebirthPrice",Money.rebirthPrice(s)) player:SetAttribute("UpgradePrice",Money.upgradePrice(s))
 player:SetAttribute("Income",math.floor(income*(1+0.5*s.rebirths)))
end
function Money.addPlayer(player)
 local s={cash=150,level=1,rebirths=0,slots={},carry=nil,loading=true}
 Money.states[player]=s Money.publish(player)
 if not RunService:IsStudio() then
  local ok,value=pcall(function() return store:GetAsync(tostring(player.UserId)) end)
  if Money.states[player]~=s then return end
  if ok and type(value)=="number" and value>=0 and value==math.floor(value) then s.rebirths=value end
 end
 s.loading=false Money.publish(player)
 return s
end
function Money.save(player)
 local s=Money.states[player]
 if s and not RunService:IsStudio() and not s.loading then
  local count=s.rebirths
  local ok,err=pcall(function() store:UpdateAsync(tostring(player.UserId),function(old) return math.max(type(old)=="number" and old or 0,count) end) end)
  if not ok then warn("Rebirth save failed: ",err) end
 end
end
function Money.spend(player,amount)
 local s=Money.states[player]
 if not s or s.loading or amount<0 or s.cash<amount then return false end
 s.cash-=amount Money.publish(player) return true
end
function Money.credit(player,amount)
 local s=Money.states[player] if s then s.cash+=amount Money.publish(player) end
end
function Money.tick()
 for player in pairs(Money.states) do Money.publish(player) Money.credit(player,player:GetAttribute("Income") or 0) end
end
function Money.upgrade(player)
 local s=Money.states[player] if not s or s.level>=3 then return false end
 if not Money.spend(player,Money.upgradePrice(s)) then return false end
 s.level+=1 Money.publish(player) return true
end
function Money.rebirth(player,clear)
 local s=Money.states[player] if not s or s.loading or s.carry then return false,"Put down your brainrot first." end
 for _,slot in pairs(s.slots) do if slot.inTransit then return false,"A raid or delivery is in transit." end end
 if not Money.spend(player,Money.rebirthPrice(s)) then return false,"Not enough cash." end
 clear(player) s.rebirths+=1 s.cash=150 s.level=1 Money.publish(player)
 task.spawn(Money.save,player)
 return true,"Rebirth complete! Income increased."
end
return Money
