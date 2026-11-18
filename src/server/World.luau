local Lighting = game:GetService("Lighting")
local World = {}
World.ink = Color3.fromRGB(19, 28, 48)
World.steel = Color3.fromRGB(42, 57, 79)
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
	Lighting.ClockTime = 15.5
	Lighting.Brightness = 2.5
	Lighting.Ambient = Color3.fromRGB(112, 126, 153)
	Lighting.OutdoorAmbient = Color3.fromRGB(155, 178, 196)
	local atmosphere = Instance.new("Atmosphere")
	atmosphere.Density = 0.23
	atmosphere.Color = Color3.fromRGB(186, 222, 248)
	atmosphere.Decay = Color3.fromRGB(140, 163, 212)
	atmosphere.Parent = Lighting
	local map = Instance.new("Folder")
	map.Name = "Blitz Harbor"
	map.Parent = workspace
	World.part(map, "Ocean", Vector3.new(1300, 8, 1300), CFrame.new(0, -8, 0), Color3.fromRGB(28, 126, 159), Enum.Material.Glass)
	World.part(map, "Harbor island", Vector3.new(200, 8, 112), CFrame.new(0, -4, 0), World.steel, Enum.Material.Concrete)
	local belt = World.part(map, "Conveyor", Vector3.new(179, 0.9, 10), CFrame.new(0, 0.45, 0), World.ink, Enum.Material.Metal)
	for x = -86, 86, 4 do
		World.part(map, "Conveyor tread", Vector3.new(0.24, 0.08, 9.6), CFrame.new(x, 0.94, 0), World.steel)
	end
	for _, z in ipairs({ -5.3, 5.3 }) do
		World.part(map, "Channel lighting", Vector3.new(179, 0.15, 0.25), CFrame.new(0, 0.29, z), World.gold, Enum.Material.Neon)
	end
	for _, x in ipairs({ -88, 88 }) do
		for _, z in ipairs({ -6, 6 }) do
			World.part(map, "Terminal column", Vector3.new(2, 12, 2), CFrame.new(x, 6, z), World.ink)
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
			local post = World.part(map, "Harbor beacon", Vector3.new(2, 8, 2), CFrame.new(x, 4, z), World.ink)
			World.part(map, "Beacon light", Vector3.new(2.1, 0.45, 2.1), post.CFrame * CFrame.new(0, 3.9, 0), World.gold, Enum.Material.Neon)
		end
	end
	return map, belt
end

return World
