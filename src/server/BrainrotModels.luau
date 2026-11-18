local World = require(script.Parent.World)
local Models = {}

local rgb = Color3.fromRGB
local ink, ivory, gold = World.ink, World.white, World.gold
local silver = rgb(177, 202, 213)
local rose = rgb(244, 96, 110)
local ball = Enum.PartType.Ball
local tube = Enum.PartType.Cylinder
local metal = Enum.Material.Metal
local neon = Enum.Material.Neon

-- All sculpts face -Z and share a floor plane. Cylinders run along local X.
local cast = {}

cast["Burrito Bailiff"] = function(p, face, hue)
	p("Tortilla roll", 2.05, 2.95, 1.65, 0, 1.92, 0, hue, ball)
	p("Foil wrapper", 2.02, 1.1, 1.65, 0, 1.02, 0, silver, ball, nil, metal)
	p("Folded seam", 0.22, 1.45, 0.22, 0.66, 1.62, -0.66, ivory, ball, -0.54)
	for _, side in ipairs({ -1, 1 }) do
		p("Lettuce fringe", 0.66, 0.56, 0.92, side * 0.66, 3.16, 0, rgb(81, 168, 69), ball)
		p("Uniform boot", 0.7, 0.62, 1.06, side * 0.61, 0.32, -0.13, ink, ball)
	end
	p("Bailiff cap", 0.56, 2.05, 1.55, 0, 3.46, 0, ink, tube, math.pi / 2)
	p("Cap visor", 1.83, 0.14, 1.05, 0, 3.24, -0.69, ink, ball)
	p("Cap badge", 0.37, 0.37, 0.12, 0, 3.49, -0.77, gold, nil, math.pi / 4)
	p("Chest badge", 0.26, 0.26, 0.12, 0.52, 1.51, -0.78, gold, nil, math.pi / 4)
	face(0, 2.37, -0.77, 0.38, 1)
end

cast["Toaster Intern"] = function(p, face, hue)
	p("Enamel toaster", 2.42, 1.62, 1.46, 0, 1.34, 0, hue)
	p("Chrome plinth", 2.52, 0.24, 1.55, 0, 0.45, 0, silver, nil, nil, metal)
	p("Toast slot", 1.8, 0.07, 0.55, 0, 2.17, 0, ink)
	p("Toast crust", 1.5, 1.08, 0.34, -0.15, 2.57, 0, rgb(158, 95, 47), ball, 0.14)
	p("Toast crumb", 1.28, 0.85, 0.15, -0.15, 2.59, -0.14, gold, ball, 0.14)
	p("Lever", 0.65, 0.18, 0.35, 1.45, 1.23, 0, silver)
	p("Intern tie", 0.35, 0.55, 0.11, 0, 0.83, -0.76, rgb(57, 78, 144), nil, -0.18)
	for _, side in ipairs({ -1, 1 }) do
		p("Spectacle frame", 0.71, 0.57, 0.12, side * 0.43, 1.69, -0.77, ink)
	end
	p("Spectacle bridge", 0.4, 0.1, 0.1, 0, 1.76, -0.8, ink)
	face(0, 1.69, -0.85, 0.43, 0.8)
end

cast["Puddle Auditor"] = function(p, face, hue)
	p("Puddle", 3.85, 0.34, 2.65, 0, 0.2, 0, hue, ball)
	p("Raised splash", 1.85, 1.32, 1.38, -0.33, 0.71, 0, hue, ball)
	p("Splash tail", 1.05, 0.33, 1.22, 1.77, 0.18, 0.59, hue, ball)
	p("Suspended drop", 0.44, 0.61, 0.38, -1.18, 1.48, 0.19, hue, ball, -0.42)
	for _, side in ipairs({ -1, 1 }) do
		p("Round spectacles", 0.56, 0.52, 0.13, -0.33 + side * 0.32, 0.95, -0.54, ink, ball)
	end
	face(-0.33, 0.95, -0.63, 0.32, 0.7)
	p("Clipboard", 0.95, 1.25, 0.16, 1.12, 0.9, -0.42, rgb(144, 91, 56), nil, -0.24)
	p("Audit sheet", 0.72, 0.91, 0.06, 1.12, 0.9, -0.53, ivory, nil, -0.24)
	p("Clipboard clamp", 0.42, 0.15, 0.13, 1.25, 1.46, -0.57, silver)
end

cast["Pickle Pilot"] = function(p, face, hue)
	p("Bent gherkin", 1.56, 3.45, 1.42, 0, 1.83, 0, hue, ball, -0.26)
	p("Leather flight cap", 1.49, 1.02, 1.39, 0.35, 3.07, 0.01, rgb(122, 69, 43), ball, -0.23)
	p("Goggle strap", 1.65, 0.22, 1.25, 0.31, 2.88, 0, ink, ball)
	for _, side in ipairs({ -1, 1 }) do
		p("Aviator goggles", 0.64, 0.59, 0.23, 0.28 + side * 0.34, 2.8, -0.57, gold, ball)
		p("Pickle bump", 0.26, 0.3, 0.23, side * 0.5, 1.22 + side * 0.21, -0.49, hue:Lerp(ink, 0.3), ball)
	end
	face(0.28, 2.8, -0.69, 0.34, 0.74)
	p("Scarf wrap", 1.62, 0.3, 1.46, 0.11, 2.17, 0, rose, ball, -0.21)
	p("Streaming scarf", 1.32, 0.37, 0.2, 1.17, 2.01, 0.03, rose, nil, -0.28)
end

cast["Fax Machine DJ"] = function(p, face, hue)
	p("Fax console", 2.62, 1.23, 1.86, 0, 0.86, 0, hue)
	p("Upright paper tray", 1.83, 1.32, 0.4, 0, 1.94, 0.61, hue)
	p("Fax printout", 1.52, 1.6, 0.16, 0, 2.18, 0.41, ivory)
	for y = 2.2, 2.75, 0.18 do
		p("Printed line", 0.99, 0.055, 0.025, 0, y, 0.32, silver)
	end
	p("Headphone band", 2.96, 0.26, 0.32, 0, 3.12, 0.32, ink, ball)
	for _, side in ipairs({ -1, 1 }) do
		p("Headphone arm", 0.22, 1.17, 0.24, side * 1.34, 2.59, 0.31, ink)
		p("Bass ear cup", 0.61, 0.91, 0.72, side * 1.4, 1.98, 0.26, rose, ball)
	end
	p("Output slot", 2.05, 0.18, 0.12, 0, 0.46, -0.97, ink)
	face(0, 1.08, -0.94, 0.45, 0.95)
end

cast["Clam McSpam"] = function(p, face, hue)
	p("Lower shell", 3.34, 0.87, 2.59, 0, 0.49, 0.05, hue, ball)
	p("Upper shell", 3.34, 0.66, 2.46, 0, 2.07, 0.71, hue, ball)
	for i = -2, 2 do
		p("Scallop ridge", 0.63, 0.87 - math.abs(i) * 0.12, 1.8, i * 0.57, 2.1, 0.44, hue:Lerp(ivory, 0.34), ball, -i * 0.18)
	end
	p("Clam mantle", 2.79, 0.48, 2.14, 0, 0.83, 0, ivory, ball)
	p("Spam tin", 1.32, 1.37, 0.88, 0, 1.45, -0.23, rgb(53, 89, 173))
	p("Tin lid", 1.4, 0.14, 0.96, 0, 2.15, -0.23, silver, nil, nil, metal)
	p("Tin label", 1.12, 0.79, 0.08, 0, 1.49, -0.69, gold)
	face(0, 1.57, -0.74, 0.29, 0.74)
end

cast["Waffle Locksmith"] = function(p, face, hue)
	p("Pressed waffle", 2.68, 2.42, 0.77, -0.22, 1.64, 0, hue)
	for _, x in ipairs({ -1.15, -0.53, 0.09, 0.71 }) do
		for _, y in ipairs({ 0.78, 1.38, 1.98, 2.58 }) do
			p("Waffle pocket", 0.43, 0.41, 0.08, x, y, -0.4, rgb(159, 90, 42))
		end
	end
	p("Butter forelock", 0.63, 0.16, 0.53, -0.31, 2.92, -0.16, gold, nil, 0.2)
	p("Key loop", 0.67, 0.58, 0.21, 1.56, 1.94, -0.08, silver, ball)
	p("Key loop inset", 0.31, 0.28, 0.12, 1.56, 1.94, -0.19, ink, ball)
	for _, side in ipairs({ -1, 1 }) do
		local x = 1.56 + side * 0.22
		p("Key shaft", 0.16, 0.9, 0.17, x, 1.34, -0.1, gold, nil, side * 0.26)
		p("Key tooth", 0.28, 0.18, 0.17, x + side * 0.11, 1.04, -0.1, gold)
	end
	face(-0.22, 2.22, -0.45, 0.43, 1)
end

cast["Lava Lamp Lawyer"] = function(p, face, hue)
	p("Lamp foot", 0.39, 1.86, 1.53, 0, 0.26, 0, ink, tube, math.pi / 2)
	p("Jacket", 1.83, 1.19, 1.46, 0, 0.97, 0, ink, ball)
	p("Shirtfront", 0.83, 0.85, 0.15, 0, 1.05, -0.68, ivory)
	p("Lawyer tie", 0.19, 0.65, 0.13, 0, 1.04, -0.79, rose)
	local globe = p("Glass lamp", 1.47, 2.85, 1.42, 0, 2.02, 0, hue, ball, nil, Enum.Material.Glass)
	globe.Transparency = 0.38
	p("Lava droplet", 0.81, 0.91, 0.71, -0.16, 2.66, 0, hue, ball, 0.33, neon)
	p("Lava bubble", 0.41, 0.5, 0.41, 0.26, 1.85, 0, rose, ball, nil, neon)
	p("Lamp cap", 0.42, 0.91, 0.88, 0, 3.45, 0, ink, tube, math.pi / 2)
	p("Briefcase handle", 0.55, 0.4, 0.18, 1.43, 1.32, 0.08, silver)
	p("Briefcase", 1.06, 0.79, 0.43, 1.43, 0.86, 0.08, rgb(134, 72, 39))
	face(0, 2.34, -0.7, 0.33, 0.82)
end

cast["Microwave Mayor"] = function(p, face, hue)
	p("Microwave cabinet", 3.23, 1.94, 1.59, 0, 1.37, 0, hue)
	p("Oven window", 2.16, 1.41, 0.16, -0.38, 1.42, -0.83, ink)
	p("Window reflection", 0.13, 1.28, 0.08, -1.15, 1.4, -0.94, silver, nil, -0.32)
	p("Door handle", 0.15, 1, 0.2, 0.79, 1.41, -0.91, silver, ball)
	for y = 1.15, 1.85, 0.35 do
		p("Control button", 0.33, 0.13, 0.08, 1.22, y, -0.83, ivory)
	end
	p("Mayoral sash", 2.47, 0.32, 0.15, -0.19, 1.07, -1.03, rose, nil, 0.31)
	p("Sash medal", 0.36, 0.36, 0.18, 0.52, 1.31, -1.14, gold, ball)
	face(-0.34, 1.77, -0.93, 0.42, 0.89)
end

cast["Disco Dumpster"] = function(p, face, hue)
	p("Dumpster bin", 2.96, 1.64, 1.6, 0, 1.15, 0, hue)
	p("Open ribbed lid", 3.18, 0.25, 1.87, 0, 2.35, 0.56, ink).Orientation = Vector3.new(-34, 0, 0)
	for _, side in ipairs({ -1, 1 }) do
		p("Caster wheel", 0.31, 0.66, 0.66, side * 1.18, 0.39, 0.05, ink, tube)
		p("Lift pocket", 0.43, 0.61, 1.11, side * 1.52, 1.47, 0.03, silver)
	end
	p("Mirror ball", 1.18, 1.18, 1.18, 0, 2.65, -0.31, silver, ball, nil, metal)
	for i = -1, 1 do
		for j = -1, 1 do
			p("Mirror tile", 0.22, 0.22, 0.1, i * 0.28, 2.65 + j * 0.28,
				-0.9 + (math.abs(i) + math.abs(j)) * 0.08, (i + j) % 2 == 0 and ivory or hue, nil, 0.16, neon)
		end
	end
	p("Reflective bumper", 2.74, 0.18, 0.11, 0, 0.6, -0.84, gold, nil, nil, neon)
	face(0, 1.51, -0.82, 0.49, 1.03)
end

cast["Moon Mozzarella"] = function(p, face, hue)
	p("Space suit", 1.72, 1.03, 1.16, 0, 0.85, 0, ivory, ball)
	p("Oxygen pack", 1.03, 1.11, 0.6, 0, 0.96, 0.69, silver)
	for _, side in ipairs({ -1, 1 }) do
		p("Moon boot", 0.7, 0.59, 0.88, side * 0.62, 0.32, -0.03, ivory, ball)
		p("Helmet hinge", 0.48, 0.62, 0.65, side * 1.02, 2.17, 0, silver, ball)
	end
	p("Cheese moon", 1.91, 1.78, 1.65, 0, 2.15, 0, hue, ball)
	p("Cheese crater", 0.46, 0.33, 0.16, 0.39, 2.72, -0.49, hue:Lerp(ink, 0.27), ball)
	p("Cheese crater", 0.33, 0.26, 0.16, -0.63, 1.91, -0.51, hue:Lerp(ink, 0.27), ball)
	face(0, 2.21, -0.8, 0.39, 0.89)
	p("Bubble helmet", 2.37, 2.24, 2.17, 0, 2.19, 0, rgb(170, 232, 255), ball, nil, Enum.Material.Glass).Transparency = 0.78
	p("Suit collar", 0.28, 1.99, 1.77, 0, 1.19, 0, silver, tube, math.pi / 2)
end

cast["Soup Singularity"] = function(p, face, hue)
	p("Ceramic bowl", 3.27, 1.28, 2.85, 0, 0.91, 0, hue, ball)
	p("Bowl rim", 0.24, 3.32, 2.88, 0, 1.46, 0, ivory, tube, math.pi / 2)
	p("Soup surface", 0.075, 2.98, 2.58, 0, 1.6, 0, rgb(245, 128, 51), tube, math.pi / 2)
	for i = 0, 11 do
		local angle = i * 0.57
		local radius = 1.22 - i * 0.095
		p("Cream spiral", 0.32, 0.055, 0.3, math.cos(angle) * radius, 1.65,
			math.sin(angle) * radius * 0.86, gold, ball)
	end
	p("Spoon handle", 0.19, 1.59, 0.17, 1.15, 2.18, 0.31, silver, nil, -0.45, metal)
	p("Spoon scoop", 0.59, 0.85, 0.29, 1.59, 3.07, 0.31, silver, ball, -0.45, metal)
	face(0, 1.09, -1.37, 0.55, 0.96)
end

cast["Cosmic Coupon"] = function(p, face, hue)
	p("Ticket card", 2.61, 2.02, 0.35, 0, 1.94, 0, hue, nil, -0.12)
	p("Coupon face panel", 2.14, 1.53, 0.08, 0, 1.94, -0.2, hue:Lerp(ivory, 0.48), nil, -0.12)
	local plum = rgb(85, 52, 136)
	p("Trailing cloak", 3.15, 2.65, 0.45, 0, 1.39, 0.51, plum, ball)
	for _, side in ipairs({ -1, 1 }) do
		p("Cloak lapel", 0.42, 1.92, 0.38, side * 1.25, 1.71, 0.1, plum, nil, side * 0.25)
		for i = 0, 2 do
			p("Ticket perforation", 0.16, 0.16, 0.07, side * 1.17, 1.36 + i * 0.44, -0.22, ivory, ball)
		end
	end
	for i = -2, 2 do
		p("Barcode stripe", i % 2 == 0 and 0.08 or 0.04, 0.3, 0.07, i * 0.15, 1.43, -0.26, ink)
	end
	p("Star clasp", 0.34, 0.34, 0.13, 0.92, 2.57, -0.27, gold, nil, math.pi / 4)
	p("Floating star", 0.51, 0.51, 0.25, -0.78, 3.28, 0.09, gold, nil, math.pi / 4, neon)
	face(0, 2.25, -0.26, 0.43, 0.94)
end

function Models.sculpt(parent, unit, pose, caption)
	local model = Instance.new("Model")
	model.Name = unit.entry[1]
	local mutation = unit.mutation
	local diamond = mutation == "Diamond"
	local hue = mutation == "Gold" and gold or diamond and rgb(122, 225, 255) or unit.entry[6]
	local function piece(name, sx, sy, sz, x, y, z, color, shape, tilt, material)
		local part = World.part(model, name, Vector3.new(sx, sy, sz),
			CFrame.new(x, y, z) * CFrame.Angles(0, 0, tilt or 0), color, material, shape)
		part.CanCollide = false
		part.CanTouch = false
		part.CanQuery = false
		return part
	end
	local function face(x, y, z, spread, scale)
		for _, side in ipairs({ -1, 1 }) do
			local eyeX = x + side * spread
			piece("Eye", 0.47 * scale, 0.48 * scale, 0.2, eyeX, y, z, ivory, ball)
			piece("Pupil", 0.2 * scale, 0.28 * scale, 0.13, eyeX + 0.045, y, z - 0.09, ink, ball)
		end
		piece("Mouth", 0.49 * scale, 0.17 * scale, 0.13, x, y - 0.37 * scale, z - 0.02, ink, ball)
	end

	-- Preserve the existing conveyor, carry and prompt reference point across all body shapes.
	local pivot = piece("Interaction anchor", 0.25, 0.25, 0.25, 0, 2.05, 0, ink)
	pivot.Transparency = 1
	model.PrimaryPart = pivot
	cast[unit.entry[1]](piece, face, hue)
	if mutation ~= "" then
		local shine = diamond and rgb(176, 245, 255) or rgb(255, 220, 112)
		for _, side in ipairs({ -1, 1 }) do
			piece(diamond and "Diamond crystal" or "Gold sparkle", diamond and 0.23 or 0.37,
				diamond and 0.72 or 0.37, 0.28, side * 1.89, 2.48 + side * 0.39, 0.3,
				shine, nil, side * math.pi / 4, neon)
		end
	end

	if caption then
		local rank = mutation == "" and unit.rarity.name or mutation .. " " .. unit.rarity.name
		local text = string.format("%s\n%s  •  +$%d/s\n%s", unit.entry[1], rank, unit.rate, caption)
		World.sign(pivot, text, unit.rarity.color, 250, 66, Vector3.new(0, 2.55, 0), 46)
	end
	model:PivotTo(pose * CFrame.new(0, 2.05, 0))
	model.Parent = parent
	return model
end

return Models
