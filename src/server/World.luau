local Lighting = game:GetService("Lighting")
local World = {}
local rgb = Color3.fromRGB
local V = Vector3.new
local M = Enum.Material

World.ink = rgb(19,28,48)
World.steel = rgb(99,150,181)
World.aqua = rgb(78,255,218)
World.gold = rgb(255,199,101)
World.white = rgb(244,248,255)
World.import = -121
World.importCurtain = -115
World.receiverCurtain = 115
World.beltTop = 1.8

function World.part(parent, name, size, pose, color, material, collides, alpha)
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.CFrame = typeof(pose) == "CFrame" and pose or CFrame.new(pose)
	part.Color = color
	part.Material = material or M.SmoothPlastic
	part.Anchored = true
	part.CanCollide = collides ~= false
	part.CanTouch = part.CanCollide
	part.CanQuery = part.CanCollide
	part.Transparency = alpha or 0
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = parent
	return part
end

function World.sign(part, text, face, color)
	local gui = Instance.new("SurfaceGui")
	gui.Face = face or Enum.NormalId.Front
	gui.CanvasSize = Vector2.new(600, 160)
	gui.Parent = part
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.TextColor3 = color or World.white
	label.TextStrokeTransparency = 0.55
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.Text = text
	label.Parent = gui
	return label
end

function World.prompt(parent, action, object, hold, distance)
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = action
	prompt.ObjectText = object
	prompt.HoldDuration = hold or 0
	prompt.MaxActivationDistance = distance or 9
	prompt.RequiresLineOfSight = false
	prompt.Parent = parent
	return prompt
end

local function machine(parent, x, direction, title)
	local teal = rgb(25,169,164)
	local function piece(name, sx, sy, sz, dx, y, z, color, material, solid)
		return World.part(parent, name, V(sx,sy,sz), V(x+dx*direction,y,z), color, material, solid)
	end
	piece("Steel roof",20,1.2,22,0,10,0,World.steel,M.Metal)
	for _, side in {-1,1} do
		piece("Machine housing",20,10,2,0,5,side*9,teal)
		piece("Vent plate",8,2.5,0.2,0,6,side*10,World.ink)
		for slat = -3,3 do
			piece("Vent slat",0.5,2,0.25,slat,6,side*10.15,World.steel,M.Metal,false)
		end
		piece("Warning lamp",1,0.6,1,5,10.9,side*9,World.gold,M.Neon,false)
	end
	for strip = -7,7 do
		piece("Rubber portal curtain",0.25,6,0.93,6,5.1,strip,World.ink,M.Rubber,false)
	end
	local sign = piece("Machine sign",0.35,1.7,15,9,8.65,0,World.ink,nil,false)
	World.sign(sign,title,direction == 1 and Enum.NormalId.Right or Enum.NormalId.Left)
end

local function perimeter(parent)
	local brown = rgb(139,87,51)
	local cap = rgb(195,134,83)
	for _, side in {-1,1} do
		World.part(parent,"Harbor wall",V(268,18,3),V(0,9,side*100),brown)
		World.part(parent,"Wall coping",V(269,0.7,3.7),V(0,18.3,side*100),cap)
		World.part(parent,"Harbor wall",V(3,18,200),V(side*134,9,0),brown)
		World.part(parent,"Wall coping",V(3.7,0.7,201),V(side*134,18.3,0),cap)
		for x = -120,120,24 do
			World.part(parent,"Wall pilaster",V(3.2,18.5,4.5),V(x,9.25,side*100),cap)
		end
		for z = -80,80,20 do
			World.part(parent,"Wall pilaster",V(4.5,18.5,3.2),V(side*134,9.25,z),cap)
		end
	end
end

local function harbor(parent)
	local timber = rgb(156,103,63)
	World.part(parent,"Pier",V(126,1,15),V(-41,0.5,92),timber,M.WoodPlanks)
	for x = -101,19,8 do
		World.part(parent,"Pier piling",V(1.4,4,1.4),V(x,1,97),World.ink,M.Wood)
	end
	local building = World.part(parent,"Customs warehouse",V(28,12,12),V(-73,6,76),World.steel,M.Metal)
	World.sign(building,"BLITZ CUSTOMS")
	World.part(parent,"Customs roof",V(30,0.7,14),V(-73,12.4,76),World.ink,M.Metal)
	local colors = {rgb(190,76,54), rgb(25,169,164), rgb(237,166,57), rgb(86,125,188)}
	for index, color in colors do
		local x = -47 + ((index-1)%2)*14
		local y = index <= 2 and 2.1 or 6.3
		World.part(parent,"Cargo container",V(13,4.2,6),V(x,y,78),color,M.Metal)
		for rib = -5,5 do
			World.part(parent,"Container rib",V(0.17,3.8,0.2),V(x+rib,y,74.95),World.ink,M.Metal,false,0.35)
		end
	end
	local yellow = rgb(248,177,56)
	World.part(parent,"Crane mast",V(2,19,2),V(-10,9.5,67),yellow,M.Metal)
	World.part(parent,"Crane boom",V(22,1.2,1.5),V(-4,19,67),yellow,M.Metal)
	World.part(parent,"Crane cab",V(3.8,3.2,3.7),V(-8,15.5,67),World.ink)
	World.part(parent,"Cab window",V(3.1,1.8,0.2),V(-8,15.7,65.05),World.steel,M.Glass,false)
	World.part(parent,"Crane cable",V(0.13,9,0.13),V(5,14,67),World.ink)
	World.part(parent,"Cargo hook",V(1,1.1,0.4),V(5,9.2,67),yellow,M.Metal)
end

local function decorate(parent)
	local sand = rgb(236,212,160)
	for _, side in {-1,1} do
		World.part(parent,"Evacuation lane",V(250,0.08,3.6),V(0,0.045,side*25),sand,nil,false)
		local marker = World.part(parent,"Wayfinding",V(8,1.4,0.35),
			CFrame.new(17,2.25,side*30)*CFrame.Angles(0,side == 1 and 0 or math.pi,0),World.ink)
		World.sign(marker,"SAFEHOUSES")
		World.part(parent,"Sign post",V(0.4,2,0.4),V(17,1,side*30),World.steel)
		for _, x in {-110,-41,41,110} do
			local z = side*31
			World.part(parent,"Streetlight pole",V(0.45,8,0.45),V(x,4,z),World.ink,M.Metal)
			local lamp = World.part(parent,"Light head",V(2.1,0.45,1.2),V(x,8,z),World.gold,M.Neon,false)
			local light = Instance.new("PointLight")
			light.Range = 15
			light.Brightness = 0.75
			light.Color = World.gold
			light.Parent = lamp
			World.part(parent,"Pennant",V(1.6,2.2,0.12),V(x+0.9,5.6,z),side == 1 and rgb(25,169,164) or rgb(223,70,69),M.Fabric,false)
		end
		for _, x in {-111,-41,41,111} do
			local z = side*78
			World.part(parent,"Palm trunk",V(0.85,8,0.85),CFrame.new(x,4,z)*CFrame.Angles(0,0,0.12),rgb(132,89,47),M.Wood)
			for leaf = 0,5 do
				local pose = CFrame.new(x-0.45,8,z)*CFrame.Angles(0,leaf*math.pi/3,0)
				World.part(parent,"Palm frond",V(2,0.45,4.8),pose*CFrame.new(0,-0.25,-2)*CFrame.Angles(-0.18,0,0),rgb(50,142,68),nil,false)
			end
			local bush = World.part(parent,"Low shrub",V(3,1.55,2.4),V(x+1.3,0.7,z),rgb(57,154,69),nil,false)
			bush.Shape = Enum.PartType.Ball
		end
		for _, x in {-41,41} do
			local z = side*53
			World.part(parent,"Supply crate",V(3,3,3),V(x,1.5,z),rgb(156,103,63),M.WoodPlanks)
			local barrel = World.part(parent,"Barrel",V(2.4,2,2),CFrame.new(x+3,1.2,z)*CFrame.Angles(0,0,math.pi/2),World.steel,M.Metal)
			barrel.Shape = Enum.PartType.Cylinder
			for _, dx in {-4,0,4} do
				World.part(parent,"Fence post",V(0.35,2,0.35),V(x+dx,1,z+4),World.ink)
			end
			World.part(parent,"Fence rail",V(8,0.35,0.32),V(x,1.5,z+4),World.steel)
		end
	end
end

function World.build()
	local parent = Instance.new("Folder")
	parent.Name = "Blitz Harbor"
	parent.Parent = workspace
	Lighting.ClockTime = 10.5
	Lighting.Brightness = 3.5
	Lighting.Ambient = rgb(180,172,160)
	Lighting.OutdoorAmbient = rgb(191,194,188)
	local atmosphere = Instance.new("Atmosphere")
	atmosphere.Density = 0.12
	atmosphere.Glare = 0.12
	atmosphere.Haze = 0.35
	atmosphere.Parent = Lighting
	local clouds = Instance.new("Clouds")
	clouds.Cover = 0.26
	clouds.Density = 0.72
	clouds.Parent = workspace.Terrain
	World.part(parent,"Ocean",V(1300,1,1300),V(0,-2,0),rgb(35,172,235),M.SmoothPlastic,false)
	World.part(parent,"Harbor island",V(268,3,200),V(0,-1.5,0),rgb(103,188,62),M.Grass)
	World.part(parent,"Conveyor",V(262,1.8,16),V(0,0.9,0),World.ink,M.Metal)
	for _, side in {-1,1} do
		World.part(parent,"Conveyor rail",V(262,0.23,0.32),V(0,1.73,side*7.85),World.aqua,M.Neon,false)
	end
	for x = -128,128,4 do
		World.part(parent,"Belt tread",V(0.15,0.03,15.1),V(x,1.804,0),World.steel,M.Metal,false)
	end
	perimeter(parent)
	machine(parent,-121,1,"BLITZ IMPORTS")
	machine(parent,121,-1,"RETURN PROCESSOR")
	decorate(parent)
	harbor(parent)
	return parent
end

return World
