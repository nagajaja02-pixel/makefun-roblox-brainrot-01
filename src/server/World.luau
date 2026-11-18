local Lighting = game:GetService("Lighting")
local World = {}
World.ink = Color3.fromRGB(19, 28, 48)
World.steel = Color3.fromRGB(99, 150, 181)
World.aqua = Color3.fromRGB(78, 255, 218)
World.gold = Color3.fromRGB(255, 199, 101)
World.white = Color3.fromRGB(244, 248, 255)

function World.part(parent, name, size, frame, color, material, shape)
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.Size = size
	part.CFrame = frame
	part.Color = color
	part.Material = material or Enum.Material.SmoothPlastic
	part.Shape = shape or Enum.PartType.Block
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = parent
	return part
end

function World.sign(part, text, color, width, height, offset, distance)
	local board = Instance.new("BillboardGui")
	board.Size = UDim2.fromOffset(width, height)
	board.StudsOffsetWorldSpace = offset
	board.MaxDistance = distance or 64
	board.AlwaysOnTop = true
	board.Parent = part
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundColor3 = World.ink
	label.BackgroundTransparency = 0.12
	label.TextColor3 = color
	label.TextSize = height >= 50 and 15 or 18
	label.Font = Enum.Font.GothamBold
	label.Text = text
	label.Parent = board
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 7)
	corner.Parent = label
	return label
end

function World.surfaceSign(part, text, color)
	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Front
	gui.CanvasSize = Vector2.new(512, 80)
	gui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
	gui.LightInfluence = 0.15
	gui.Parent = part
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(0.94, 0.82)
	label.Position = UDim2.fromScale(0.03, 0.09)
	label.BackgroundTransparency = 1
	label.TextColor3 = color
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.Text = text
	label.Parent = gui
end

function World.prompt(part, action, object, duration)
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = action
	prompt.ObjectText = object
	prompt.HoldDuration = duration or 0.12
	prompt.MaxActivationDistance = 10
	prompt.RequiresLineOfSight = false
	prompt.Parent = part
	return prompt
end

function World.aliveRoot(player)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	return humanoid and humanoid.Health > 0 and character:FindFirstChild("HumanoidRootPart")
end

function World.near(player, part)
	local root = World.aliveRoot(player)
	return root and part.Parent and (root.Position - part.Position).Magnitude <= 13
end

function World.buildHarbor()
	Lighting.ClockTime = 10.5
	Lighting.Brightness = 3.5
	Lighting.Ambient = Color3.fromRGB(180, 172, 160)
	Lighting.OutdoorAmbient = Color3.fromRGB(191, 194, 188)
	local atmosphere = Instance.new("Atmosphere")
	atmosphere.Density = 0.12
	atmosphere.Glare = 0.12
	atmosphere.Haze = 0.35
	atmosphere.Color = Color3.fromRGB(206, 234, 255)
	atmosphere.Decay = Color3.fromRGB(167, 206, 246)
	atmosphere.Parent = Lighting
	local clouds = Instance.new("Clouds")
	clouds.Color = Color3.fromRGB(255, 249, 238)
	clouds.Cover = 0.26
	clouds.Density = 0.72
	clouds.Parent = workspace.Terrain
	local map = Instance.new("Folder")
	map.Name = "Blitz Harbor"
	map.Parent = workspace
	World.part(map, "Ocean", Vector3.new(1300, 8, 1300), CFrame.new(0, -8, 0), Color3.fromRGB(35, 172, 235), Enum.Material.SmoothPlastic)
	World.part(map, "Harbor island", Vector3.new(200, 8, 112), CFrame.new(0, -4, 0), Color3.fromRGB(226, 209, 177), Enum.Material.Concrete)
	local belt = World.part(map, "Conveyor", Vector3.new(179, 0.9, 10), CFrame.new(0, 0.45, 0), Color3.fromRGB(49, 116, 161), Enum.Material.SmoothPlastic)
	for x = -86, 86, 4 do
		World.part(map, "Conveyor tread", Vector3.new(0.24, 0.08, 9.6), CFrame.new(x, 0.94, 0), World.steel)
	end
	for _, z in ipairs({ -5.3, 5.3 }) do
		World.part(map, "Channel lighting", Vector3.new(179, 0.15, 0.25), CFrame.new(0, 0.29, z), World.gold, Enum.Material.Neon)
	end
	for _, x in ipairs({ -88, 88 }) do
		for _, z in ipairs({ -6, 6 }) do
			World.part(map, "Terminal column", Vector3.new(2, 12, 2), CFrame.new(x, 6, z), World.steel)
		end
		local arch = World.part(map, "Terminal arch", Vector3.new(3, 2, 15), CFrame.new(x, 12, 0), World.aqua, Enum.Material.Neon)
		World.sign(arch, x < 0 and "BLITZ HARBOR  /  IMPORTS" or "END OF LINE", World.white, 265, 32, Vector3.new(0, 2, 0), 105)
	end
	for _, z in ipairs({ -19, 19 }) do
		for x = -90, 90, 6 do
			World.part(map, "Evacuation lane", Vector3.new(3, 0.05, 0.26), CFrame.new(x, 0.04, z), World.aqua, Enum.Material.Neon)
		end
	end
	for _, x in ipairs({ -97, 97 }) do
		for z = -48, 48, 16 do
			local post = World.part(map, "Harbor beacon", Vector3.new(2, 8, 2), CFrame.new(x, 4, z), World.steel)
			World.part(map, "Beacon light", Vector3.new(2.1, 0.45, 2.1), post.CFrame * CFrame.new(0, 3.9, 0), World.gold, Enum.Material.Neon)
		end
	end
	local function detail(name, sx, sy, sz, x, y, z, color, material, angle)
		local part = World.part(map, name, Vector3.new(sx, sy, sz),
			CFrame.new(x, y, z) * CFrame.Angles(0, 0, angle or 0), color, material)
		part.CanCollide = false
		part.CanTouch = false
		part.CanQuery = false
		return part
	end
	local teal = Color3.fromRGB(25, 169, 164)
	local vermilion = Color3.fromRGB(244, 101, 75)
	local cream = Color3.fromRGB(255, 232, 185)
	local metal = Enum.Material.Metal
	local glow = Enum.Material.Neon
	local beltLights = { World.gold, World.aqua, Color3.fromRGB(255, 121, 190), Color3.fromRGB(132, 177, 255) }
	for _, side in ipairs({ -1, 1 }) do
		local z = side * 5
		detail("Conveyor edge rail", 175, 0.28, 0.34, 0, 1.22, z, World.steel, metal)
		for x = -80, 80, 10 do
			detail("Belt skirt bracket", 0.6, 1.15, 0.42, x, 0.58, z, World.steel, metal)
			local color = beltLights[(x / 10 + side) % #beltLights + 1]
			detail("Belt marker", 2.2, 0.13, 0.44, x, 1.4, z, color, glow)
		end
		local edge = side * 55
		detail("Quayside curb", 199, 0.26, 0.85, 0, 0.13, edge, cream, Enum.Material.Concrete)
		for x = -96, 96, 8 do
			detail("Quay railing post", 0.24, 2.6, 0.24, x, 1.3, edge, World.steel, metal)
		end
		for _, y in ipairs({ 1.1, 2.55 }) do
			detail("Quay railing", 192, 0.19, 0.23, 0, y, edge, teal, metal)
		end
		for _, x in ipairs({ -32, 32 }) do
			local lane = side * 19
			detail("Street lamp post", 0.4, 9, 0.4, x, 4.5, lane, World.steel, metal)
			detail("Street lamp arm", 0.4, 0.4, 3.2, x, 8.85, lane - side, World.steel, metal)
			detail("Street lamp diffuser", 1, 0.23, 1.2, x, 8.62, lane - side * 2.45, cream, glow)
		end
		for x = -75, 75, 25 do
			detail("Wake stripe", 12, 0.05, 0.45, x, -3.96, side * (67 + math.abs(x) % 12),
				Color3.fromRGB(169, 235, 255))
		end
	end

	-- Backdrop structures stand beyond the original walking and wave bounds.
	detail("Cargo wharf", 105, 1.8, 33, -47, -1.1, 72, teal, Enum.Material.Concrete)
	for x = -94, -4, 10 do
		detail("Wharf piling", 1.8, 7, 1.8, x, -2.8, 86, World.steel, Enum.Material.Wood)
		detail("Wharf deck seam", 0.2, 0.05, 29, x, -0.18, 72, World.steel)
	end
	detail("Customs warehouse", 33, 12, 15, -73, 6, 76, cream, Enum.Material.Concrete)
	for _, side in ipairs({ -1, 1 }) do
		detail("Warehouse cladding", 0.42, 11.8, 15.2, -73 + side * 16.4, 6, 76, teal, metal)
		detail("Warehouse roof", 18, 0.65, 17, -73 + side * 8.5, 13.45, 76, teal, metal, -side * 0.17)
	end
	for _, x in ipairs({ -82, -64 }) do
		detail("Loading door frame", 10.2, 8.5, 0.45, x, 4.25, 68.4, teal, metal)
		detail("Loading roller door", 8.8, 7.2, 0.48, x, 3.6, 68.15, World.steel, metal)
		for y = 1, 7 do
			detail("Door slat", 8.7, 0.12, 0.12, x, y, 67.86, cream, metal)
		end
	end
	local fascia = detail("Customs fascia", 16, 2.5, 0.35, -73, 10, 68.3, teal, metal)
	World.surfaceSign(fascia, "BLITZ CUSTOMS", World.white)

	for _, cargo in ipairs({
		{ -46, 3, 74, vermilion }, { -30, 3, 74, teal },
		{ -38, 9, 74, World.gold }, { -15, 3, 81, Color3.fromRGB(87, 136, 239) },
	}) do
		local x, y, z, color = table.unpack(cargo)
		detail("Freight container", 15.6, 6, 7.4, x, y, z, color, metal)
		for offset = -7, 7 do
			detail("Container rib", 0.18, 5.6, 0.22, x + offset, y, z - 3.76, color:Lerp(World.ink, 0.26), metal)
		end
		for _, side in ipairs({ -1, 1 }) do
			detail("Container frame", 15.8, 0.25, 7.55, x, y + side * 2.87, z, color:Lerp(World.white, 0.22), metal)
		end
	end

	detail("Crane pedestal", 7, 1.5, 7, -10, 0.55, 67, World.steel, metal)
	for _, side in ipairs({ -1, 1 }) do
		detail("Crane tower upright", 0.75, 24, 2, -10 + side * 1.6, 12.8, 67, World.gold, metal)
	end
	for y = 3, 23, 4 do
		detail("Crane lattice", 5.2, 0.32, 1.2, -10, y, 67, World.gold, metal, y % 8 == 3 and 0.78 or -0.78)
	end
	detail("Crane boom", 38, 1.6, 2.3, -20, 24.8, 67, World.gold, metal)
	detail("Crane boom stay", 24, 0.38, 0.55, -20, 27, 67, World.steel, metal, -0.18)
	detail("Crane operator cab", 4, 3, 3.3, -7, 22, 67, teal, metal)
	detail("Crane cab window", 3.3, 1.95, 0.15, -7, 22.2, 65.27, Color3.fromRGB(137, 219, 240), Enum.Material.Glass)
	detail("Crane hoist cable", 0.17, 10, 0.17, -32, 19, 67, World.ink, metal)
	detail("Crane hook", 1.15, 0.65, 0.7, -32, 13.75, 67, World.gold, metal)
	return map, belt
end

return World
