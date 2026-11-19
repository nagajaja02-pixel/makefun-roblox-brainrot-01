local D=require(game.ReplicatedStorage.Shared.BrainrotData)
local Models=require(script.Parent.BrainrotModels)
local W=require(script.Parent.World)
local B=require(script.Parent.BaseService)
local E=require(script.Parent.MoneyService)
local Steal=require(script.Parent.StealService)
local C={offers={},elapsed=0,spawnCount=0}
function C.spawn(item,x)
 item.model=Models.create(item,W.root)
 local offer={item=item,x=x}
 item.model:PivotTo(CFrame.new(x,1.8,0))
 local prompt
 prompt=W.prompt(item.model.PrimaryPart,"Buy $"..item.price,D.cast[item.id][1],function(player)
  if offer.sold or not Steal.near(player,item.model.PrimaryPart) or Steal.carriers[player] then return end
  if not B.freeSlot(player) then C.notify(player,"Expand your base or free a stand.") return end
  if not E.spend(player,item.price) then C.notify(player,"Not enough cash.") return end
  offer.sold=true
  if Steal.carry(player,item,"purchase") then
   prompt:Destroy() Steal.attach(item) Steal.prompts(item,false)
   C.notify(player,"Bring it to your safehouse!")
  else offer.sold=false E.add(player,item.price) end
 end)
 table.insert(C.offers,offer)
end
function C.init(notify)
 C.notify=notify
 for i=1,7 do
  local starters={[5]=2,[6]=1,[7]=3}
  C.spawn(starters[i] and D.make(starters[i],false) or D.random(true),-115+i*17)
 end
end
function C.step(dt,now)
 C.elapsed+=dt
 while C.elapsed>=3.4 do
  C.elapsed-=3.4 C.spawnCount+=1
  local item=C.spawnCount%3==0 and D.make(math.random(1,3),false) or D.random(true)
  C.spawn(item,-121)
 end
 for i=#C.offers,1,-1 do
  local offer=C.offers[i]
  if offer.sold then table.remove(C.offers,i)
  else
   offer.x+=4.2*dt
   if offer.x>=121 then offer.item.model:Destroy() table.remove(C.offers,i)
   else offer.item.model:PivotTo(CFrame.new(offer.x,1.8+math.abs(math.sin(now*3))*0.26,0)) end
  end
 end
end
return C
