local Data=require(game:GetService("ReplicatedStorage").Shared.BrainrotData)
local Models=require(script.Parent.BrainrotModels)
local World=require(script.Parent.World)
local Money=require(script.Parent.MoneyService)
local Base=require(script.Parent.BaseService)
local Conveyor={offers={},rng=Random.new(),elapsed=0,count=0,time=0}
function Conveyor.spawn(offer,x)
 local model=Models.create(offer,World.root)
 model:PivotTo(CFrame.new(x,1.8,0))
 local item={offer=offer,model=model,x=x,phase=Conveyor.rng:NextNumber(0,math.pi*2)}
 table.insert(Conveyor.offers,item)
 local prompt=World.prompt(model.PrimaryPart,"Buy $"..offer.price,offer.data.name,0,function(player)
  if item.sold or not model.Parent or not Base.near(player,model.PrimaryPart,11) then return end
  local s=Money.states[player]
  if not s or s.carry or not Base.freeSlot(player) then Base.notify(player,"Empty your hands and unlock a free stand.") return end
  if not Money.spend(player,offer.price) then Base.notify(player,"Not enough cash.") return end
  item.sold=true
  for _,obj in ipairs(model:GetDescendants()) do if obj:IsA("ProximityPrompt") then obj:Destroy() end end
  if not Base.install(player,offer,model) then item.sold=false Money.credit(player,offer.price) model:Destroy() return end
  Base.notify(player,offer.data.name.." delivered to your safehouse.")
 end)
 return item
end
function Conveyor.start()
 for i=1,7 do
  local starter=({[5]=2,[6]=1,[7]=3})[i]
  Conveyor.spawn(starter and Data.offer(starter,false,Conveyor.rng) or Data.randomOffer(Conveyor.rng,false),-115+i*17)
 end
end
function Conveyor.step(dt)
 Conveyor.time+=dt Conveyor.elapsed+=dt
 while Conveyor.elapsed>=3.4 do
  Conveyor.elapsed-=3.4 Conveyor.count+=1
  Conveyor.spawn(Data.randomOffer(Conveyor.rng,Conveyor.count%3==0),-121)
 end
 for i=#Conveyor.offers,1,-1 do
  local item=Conveyor.offers[i]
  if item.sold or not item.model.Parent then table.remove(Conveyor.offers,i)
  else
   item.x+=4.2*dt
   if item.x>=121 then item.model:Destroy() table.remove(Conveyor.offers,i)
   else item.model:PivotTo(CFrame.new(item.x,1.8+math.abs(math.sin(Conveyor.time*3+item.phase))*0.26,0)) end
  end
 end
end
return Conveyor
