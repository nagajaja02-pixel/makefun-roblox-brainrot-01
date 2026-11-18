local World = require(script.Parent.World)
local Models = {}

function Models.sculpt(parent, unit, pose, caption)
	local model = Instance.new("Model")
	model.Name = unit.entry[1]
	local hue = unit.mutation == "Gold" and World.gold
		or unit.mutation == "Diamond" and Color3.fromRGB(148, 244, 255) or unit.entry[6]
	local function piece(name, size, offset, color, shape, material)
		local part = World.part(model, name, size, offset, color, material, shape)
		part.CanCollide = false
		part.CanTouch = false
		return part
	end
	local ball = Enum.PartType.Ball
	local silhouette = unit.entry[5]
	local body = piece("Body", Vector3.new(2.7, 2.65, 1.85), CFrame.new(0, 2.05, 0), hue, silhouette == "toast" and Enum.PartType.Block or ball)
	model.PrimaryPart = body
	for _, side in ipairs({ -1, 1 }) do
		piece("Boot", Vector3.new(0.93, 0.72, 1.25), CFrame.new(side * 0.76, 0.39, -0.24), World.ink, ball)
		piece("Glove", Vector3.new(0.76, 0.76, 0.76), CFrame.new(side * 1.47, 1.48, -0.16), World.white, ball)
		piece("Eye", Vector3.new(0.57, 0.69, 0.34), CFrame.new(side * 0.48, 2.34, -0.87), World.white, ball)
		piece("Pupil", Vector3.new(0.24, 0.32, 0.16), CFrame.new(side * 0.48 + 0.05, 2.33, -1.02), World.ink, ball)
	end
	piece("Mouth", Vector3.new(0.71, 0.19, 0.23), CFrame.new(0, 1.81, -0.91), World.ink, ball)
	if silhouette == "toast" then
		piece("Toast crown", Vector3.new(1.9, 0.87, 1.05), CFrame.new(0, 3.48, 0) * CFrame.Angles(0, 0, 0.17), World.gold)
		piece("Control light", Vector3.new(0.31, 0.23, 0.13), CFrame.new(0, 1.31, -0.94), World.aqua, nil, Enum.Material.Neon)
	elseif silhouette == "lamp" then
		piece("Reactor cap", Vector3.new(1.15, 0.64, 1.15), CFrame.new(0, 3.48, 0), World.ink)
		piece("Reactor glow", Vector3.new(0.65, 0.65, 0.65), CFrame.new(0, 4, 0), unit.rarity.color, ball, Enum.Material.Neon)
	elseif silhouette == "wrap" then
		piece("Wrapper", Vector3.new(2.54, 0.9, 1.78), CFrame.new(0, 1.22, 0), World.white, ball)
		for index = -1, 1 do
			piece("Garnish", Vector3.new(0.67, 0.65, 0.67), CFrame.new(index * 0.59, 3.24 + (1 - math.abs(index)) * 0.3, 0), index == 0 and World.gold or World.aqua, ball)
		end
	else
		piece("Fin", Vector3.new(0.51, 1.06, 1.12), CFrame.new(0, 3.24, 0.21) * CFrame.Angles(-0.46, 0, 0), unit.rarity.color, ball)
	end
	if unit.entry[2] >= 4 or unit.mutation ~= "" then
		for _, side in ipairs({ -1, 1 }) do
			piece("Floating gem", Vector3.new(0.48, 0.48, 0.48), CFrame.new(side * 1.62, 3.16, 0) * CFrame.Angles(0, 0, math.pi / 4), unit.rarity.color, nil, Enum.Material.Neon)
		end
	end
	if caption then
		local rank = unit.mutation == "" and unit.rarity.name or unit.mutation .. " " .. unit.rarity.name
		World.sign(body, string.format("%s\n%s  •  +$%d/s\n%s", unit.entry[1], rank, unit.rate, caption), unit.rarity.color, 164, 59, Vector3.new(0, 3.08, 0), 43)
	end
	-- The primary part sits above the feet, so retain that offset when positioning the model.
	model:PivotTo(pose * CFrame.new(0, 2.05, 0))
	model.Parent = parent
	return model
end

return Models
