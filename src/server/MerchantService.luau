local W=require(script.Parent.World)
local Steal=require(script.Parent.StealService)
local M={}
function M.build(notify)
 local npc=Instance.new("Model") npc.Name="Brainrot Shop Merchant" npc.Parent=W.root
 local origin=CFrame.new(41,0,-16)*CFrame.Angles(0,math.pi,0)
 local function p(n,size,pos,col) return W.part(npc,n,size,origin*CFrame.new(pos),col) end
 local body=p("Merchant coat",Vector3.new(2,2.5,1),Vector3.new(0,2.5,0),Color3.fromRGB(25,169,164))
 p("Head",Vector3.new(1.4,1.4,1.4),Vector3.new(0,4.4,0),W.gold)
 p("Hat",Vector3.new(2,0.4,2),Vector3.new(0,5.2,0),W.ink)
 for _,x in ipairs({-0.65,0.65}) do p("Leg",Vector3.new(0.6,1.3,0.7),Vector3.new(x,0.65,0),W.ink) p("Arm",Vector3.new(0.5,2,0.6),Vector3.new(x*2,2.5,0),W.gold) end
 for _,x in ipairs({-0.3,0.3}) do p("Eye",Vector3.new(0.15,0.2,0.1),Vector3.new(x,4.5,-0.75),W.ink) end
 local sign=p("Brainrot Shop",Vector3.new(12,3,0.5),Vector3.new(0,7,0),W.ink)
 W.sign(sign,"BRAINROT SHOP / SELL 50%",W.aqua)
 local counter=p("Counter",Vector3.new(7,2.4,2),Vector3.new(0,1.2,-2),W.steel)
 W.prompt(counter,"Sell carried brainrot","Brainrot Shop · 50% refund",function(player)
  if Steal.near(player,counter) then notify(player,Steal.sell(player)) end
 end)
end
return M
