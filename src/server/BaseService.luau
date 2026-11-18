local World = require(script.Parent.World)
local Base = {}
local V = Vector3.new
local rgb = Color3.fromRGB
local accents = {
	rgb(27,192,190), rgb(250,115,93), rgb(85,144,247),
	rgb(197,119,247), rgb(103,200,92), rgb(248,177,56),
}

function Base.build(parent)
	local plots = {}
	for index = 1,6 do
		local x = ({-82,0,82})[(index-1)%3+1]
		local z = index <= 3 and -51 or 51
		local origin = CFrame.new(x,0,z)*CFrame.Angles(0,z < 0 and math.pi or 0,0)
		local house = Instance.new("Model")
		house.Name = ("SAFEHOUSE %02d"):format(index)
		house.Parent = parent
		local accent = accents[index]
		local function part(name,sx,sy,sz,dx,y,dz,color,material,solid,alpha)
			return World.part(house,name,V(sx,sy,sz),origin*CFrame.new(dx,y,dz),color,material,solid,alpha)
		end
		local wallColor = rgb(215,229,235)
		local function wallBand(side, level, height, color, material, alpha)
			local sx,sz,dx,dz = table.unpack(side)
			part("Wall panel",sx,height,sz,dx,level,dz,color,material,true,alpha)
		end
		local walls = {
			{0.8,40,-12.6,0}, {0.8,40,12.6,0}, {26,0.8,0,19.6},
			{10,0.8,-8,-19.6}, {10,0.8,8,-19.6},
		}
		part("Safehouse deck",26,0.4,40,0,0.2,0,rgb(224,231,224))
		for _, side in walls do
			wallBand(side,2.9,5,wallColor)
			wallBand(side,7.025,3.25,rgb(155,221,236),Enum.Material.Glass,0.78)
			wallBand(side,9.125,0.95,wallColor)
		end
		part("Door lintel",6,2.1,0.8,0,8.55,-19.6,wallColor)
		for _, px in {-12.4,12.4} do
			for _, pz in {-19.4,19.4} do
				part("Graphite corner pillar",1.2,9.2,1.2,px,5,pz,World.ink)
			end
		end
		for _, px in {-6.8,6.8} do
			part("Canopy wing",13.6,0.5,38,px,10.1,-1,accent)
		end
		part("Service canopy",27.2,0.5,10,0,11.4,14,accent)
		local sign = part("Nameboard",15,1.55,0.35,0,9.05,-20.12,World.ink)
		World.sign(sign,house.Name)
		local ownerLabel = World.sign(part("Owner board",10,0.85,0.25,8,7.95,-20.12,accent),"Available")
		local delivery = part("Wave shelter delivery",12,0.11,6,0,0.455,-14.9,accent)
		World.sign(delivery,"DELIVERY / WAVE SHELTER",Enum.NormalId.Top,World.ink)
		local shieldTerminal = part("Shield terminal",2.3,2.55,1.25,-5,1.68,-18.35,World.ink)
		local expandTerminal = part("Expansion terminal",2.3,2.55,1.25,5,1.68,-18.35,World.ink)
		World.sign(shieldTerminal,"SHIELD")
		World.sign(expandTerminal,"EXPAND BASE")
		local slots = {}
		for _, row in {-11,-4,3,10} do
			for _, col in {-8,8} do
				local stand = part("Display stand",4.6,0.6,3.8,col,0.7,row,World.steel)
				local pose = origin*CFrame.new(col,1,row)
				if col < 0 then
					pose *= CFrame.Angles(0,-math.pi/2,0)
				else
					pose *= CFrame.Angles(0,math.pi/2,0)
				end
				table.insert(slots,{stand = stand, pose = pose})
			end
		end
		plots[index] = {
			index = index, origin = origin, model = house, slots = slots,
			shieldPrompt = World.prompt(shieldTerminal,"Activate","SHIELD",0,8),
			expandPrompt = World.prompt(expandTerminal,"Expand","EXPAND BASE",0,8),
			ownerLabel = ownerLabel,
		}
	end
	return plots
end

function Base.paint(plot,capacity)
	for index, slot in plot.slots do
		slot.stand.Color = index <= capacity and World.aqua or World.steel
	end
end

function Base.claim(plots,player)
	for _, plot in plots do
		if not plot.owner then
			plot.owner = player
			plot.ownerLabel.Text = player.DisplayName
			Base.paint(plot,4)
			return plot
		end
	end
end

function Base.release(plot)
	plot.owner = nil
	plot.ownerLabel.Text = "Available"
	Base.paint(plot,0)
end

function Base.freeSlot(plot,capacity)
	for index, slot in plot.slots do
		if index <= capacity and not slot.item then
			return slot
		end
	end
end

function Base.isSheltered(plot,position)
	local point = plot.origin:PointToObjectSpace(position)
	return math.abs(point.X) < 12.2 and point.Z > -19 and point.Z < 19 and point.Y >= 0 and point.Y < 13
end

return Base
