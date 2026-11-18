local World = require(script.Parent.World)
local Steal = require(script.Parent.StealService)
local Merchant = {}
local V = Vector3.new

function Merchant.build(parent,notice)
	local origin = CFrame.new(41,0,-16)*CFrame.Angles(0,math.pi,0)
	local shop = Instance.new("Model")
	shop.Name = "Brainrot Shop"
	shop.Parent = parent
	local function piece(name,x,y,z,sx,sy,sz,color)
		return World.part(shop,name,V(sx,sy,sz),origin*CFrame.new(x,y,z),color)
	end
	piece("Shop plinth",0,0.1,0,9,0.2,5.5,World.steel)
	piece("Counter",0,1.05,-1.33,6,1.7,0.85,World.ink)
	piece("Counter trim",0,1.98,-1.33,6.3,0.17,1.03,World.aqua)
	for _, side in {-1,1} do
		piece("Awning post",side*3.7,2.55,0.75,0.34,4.9,0.34,World.ink)
		piece("Merchant boot",side*0.37,0.47,0.12,0.53,0.54,0.81,World.ink)
		piece("Merchant sleeve",side*0.83,1.94,0.16,0.32,1.19,0.51,World.gold)
		piece("Merchant eye",side*0.29,3.08,-0.55,0.14,0.17,0.1,World.ink)
	end
	piece("Merchant jacket",0,1.92,0.14,1.34,1.52,0.92,World.gold)
	piece("Merchant head",0,3,0.05,1.19,1.14,1.1,Color3.fromRGB(187,126,86))
	piece("Merchant cap",0,3.58,0,1.29,0.33,1.17,World.aqua)
	piece("Merchant cap brim",0,3.48,-0.61,1.23,0.12,0.48,World.aqua)
	piece("Shop awning",0,4.78,0,8.3,0.36,5.7,World.aqua)
	local sign = piece("Shop sign",0,4.26,-2.74,7.2,0.85,0.2,World.ink)
	World.sign(sign,"BRAINROT SHOP")
	local promptPart = piece("Till",0,2.24,-1.34,0.8,0.39,0.59,World.steel)
	local prompt = World.prompt(promptPart,"Sell Carried Brainrot","Brainrot Shop",0,9)
	prompt.Triggered:Connect(function(player)
		if not Steal.near(player,promptPart,9) then
			return
		end
		if Steal.carrying[player] then
			Steal.sell(player)
		else
			notice:FireClient(player,"Bring a brainrot to sell.",3)
		end
	end)
end

return Merchant
