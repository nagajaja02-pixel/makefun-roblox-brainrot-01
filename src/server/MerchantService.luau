local World=require(script.Parent.World)
local Base=require(script.Parent.BaseService)
local Steal=require(script.Parent.StealService)
local Merchant={}
function Merchant.build()
 local folder=Instance.new("Model") folder.Name="BrainrotShop" folder.Parent=World.root
 local cf=CFrame.new(41,0,-16)*CFrame.Angles(0,math.pi,0)
 local C=World.Colors
 local function part(name,size,x,y,z,color)
  return World.part(folder,name,size,cf*CFrame.new(x,y,z),color,nil,false)
 end
 part("ShopPlatform",Vector3.new(12,0.3,9),0,0.15,0,C.ink)
 part("Counter",Vector3.new(9,2,2),0,1.2,-2.5,Color3.fromRGB(25,169,164))
 for _,x in ipairs({-5,5}) do part("AwningPost",Vector3.new(0.4,6,0.4),x,3,0,C.ink) end
 part("ShopAwning",Vector3.new(12,0.5,7),0,6,0,C.gold)
 local board=part("ShopSign",Vector3.new(11,2,0.3),0,6.7,-3.5,C.ink)
 World.sign(folder,board,"BRAINROT SHOP",C.aqua,38)
 local body=part("MerchantTorso",Vector3.new(1.8,2,1),0,2.5,0,C.steel)
 local head=part("MerchantHead",Vector3.new(1.5,1.5,1.5),0,4.2,0,C.gold) head.Shape=Enum.PartType.Ball
 part("MerchantHat",Vector3.new(2.1,0.35,1.8),0,5,0,C.ink)
 for _,x in ipairs({-1,1}) do
  part("MerchantArm",Vector3.new(0.5,1.8,0.5),x*1.2,2.6,0,C.gold)
  part("MerchantLeg",Vector3.new(0.6,1,0.6),x*0.5,0.8,0,C.ink)
  part("MerchantEye",Vector3.new(0.15,0.2,0.1),x*0.3,4.3,-0.74,C.ink)
 end
 local terminal=part("SellTerminal",Vector3.new(3,0.5,1.5),0,2.5,-2.5,C.gold)
 World.prompt(terminal,"Sell Carried Brainrot","50% of purchase price",0,function(player)
  if Base.near(player,terminal,12) then Steal.sell(player) end
 end)
 Merchant.terminal=terminal
end
return Merchant
