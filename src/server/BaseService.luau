local World = require(script.Parent.World)
local flat = Enum.Material.SmoothPlastic
local Money = require(script.Parent.MoneyService)
local Shield = require(script.Parent.ShieldService)
local Models = require(script.Parent.BrainrotModels)

local Base = {}
Base.startingCash = 150

local width, depth = 26, 40
local halfWidth, halfDepth = width / 2, depth / 2

local plotColors = {
	Color3.fromRGB(27, 192, 190), Color3.fromRGB(250, 115, 93), Color3.fromRGB(85, 144, 247),
	Color3.fromRGB(197, 119, 247), Color3.fromRGB(103, 200, 92), Color3.fromRGB(248, 177, 56),
}

function Base.build(map)
	local bases = {}
	for _, z in ipairs({ -World.plotRow, World.plotRow }) do
		for _, x in ipairs({ 0, -World.plotSpacing, World.plotSpacing }) do
			local model = Instance.new("Model")
			model.Name = "Safehouse " .. (#bases + 1)
			model.Parent = map
			local frame = CFrame.new(x, 0, z) * CFrame.Angles(0, z < 0 and math.pi or 0, 0)
			local function part(name, size, lx, ly, lz, color, material)
				return World.part(model, name, size, frame * CFrame.new(lx, ly, lz), color, material)
			end
			local plot = #bases + 1
			local accent = plotColors[plot]
			local pale = accent:Lerp(World.white, 0.78)
			part("Shelter deck", Vector3.new(width, 0.4, depth), 0, 0.2, 0, pale, Enum.Material.SmoothPlastic)
			part("Back wall", Vector3.new(width, 7, 0.65), 0, 3.5, halfDepth - 0.5, pale)
			local function trim(name, sx, sy, sz, lx, ly, lz, color, material)
				local item = part(name, Vector3.new(sx, sy, sz), lx, ly, lz, color, material)
				item.CanCollide = false
				item.CanTouch = false
				item.CanQuery = false
				return item
			end
			for _, side in ipairs({ -1, 1 }) do
				part("Shelter column", Vector3.new(1, 8, 1), side * (halfWidth - 0.5), 4, -halfDepth + 1, World.steel)
				trim("Side cladding", 0.38, 7.45, depth - 1, side * (halfWidth - 0.5), 4.125, 0, accent, flat)
				trim("Side transom", 0.55, 0.45, depth - 2, side * (halfWidth - 0.5), 7.65, 0, accent, flat)
				for _, zBay in ipairs({ -14, -4.7, 4.7, 14 }) do
					trim("Side window", 0.55, 3.35, 8.5, side * (halfWidth - 0.5), 5.62, zBay, pale, flat)
					trim("Side mullion", 0.65, 4.1, 0.45, side * (halfWidth - 0.5), 5.75, zBay + 4.4, accent, flat)
				end
				trim("Entry floor stripe", 0.26, 0.04, depth - 4, side * 4.75, 0.42, 0, accent)
				trim("Interior light", 0.5, 0.18, depth - 7, side * 8, 7.65, 1, World.white, Enum.Material.Neon)
			end
			for lx = -9, 9, 6 do
				trim("Back wall rib", 0.28, 6.7, 0.24, lx, 3.9, halfDepth - 0.9, pale, flat)
			end
			trim("Shelter roof", width + 1, 0.65, depth - 1, 0, 8.35, 0.5, accent, flat)
			trim("Roof raised center", width - 6, 0.55, depth - 5, 0, 8.85, 0.5, accent:Lerp(World.white, 0.3), flat)
			local fascia = trim("Safehouse nameboard", 22, 1.65, 0.65, 0, 8.85, -halfDepth + 0.25, World.ink)
			World.surfaceSign(fascia, string.format("SAFEHOUSE  %02d", plot), World.white)
			local gate = part("Shield status", Vector3.new(width, 0.42, 0.7), 0, 7.7, -halfDepth + 0.5, World.aqua, Enum.Material.Neon)
			local title = World.sign(gate, "AVAILABLE SAFEHOUSE", World.white, 255, 34, Vector3.new(0, 2.8, 0))
			local drop = part("Drop zone", Vector3.new(9, 0.19, 6), 0, 0.5, -14, World.aqua, Enum.Material.Neon)
			World.sign(drop, "DELIVERY  /  WAVE SHELTER", World.aqua, 235, 27, Vector3.new(0, 0.85, 0), 33)
			local controls = {}
			for index, titleText in ipairs({ "SHIELD", "EXPAND BASE" }) do
				local color = index == 1 and World.aqua or World.gold
				local terminal = part(titleText, Vector3.new(3.2, 1.25, 2.5), (index - 1.5) * 6, 1.02, 16.5, color)
				World.sign(terminal, titleText, color, 115, 23, Vector3.new(0, 1.4, 0), 23)
				controls[index] = terminal
			end
			local stands = {}
			for index = 1, 8 do
				local side = index % 2 == 1 and -1 or 1
				local column = 8
				local row = -11 + math.floor((index - 1) / 2) * 7
				local stand = part("Income stand " .. index, Vector3.new(5.2, 0.55, 4), side * column, 0.67, row, World.steel)
				trim("Display pedestal", 5.4, 0.2, 4.2, side * column, 0.5, row, accent, flat)
				trim("Display front trim", 4.5, 0.12, 0.08, side * column, 0.74, row - 2.02, pale, Enum.Material.Neon)
				stands[index] = stand
			end
			table.insert(bases, {
				frame = frame, gate = gate, title = title, stands = stands, controls = controls, model = model,
				entrance = (frame * CFrame.new(0, 0, -halfDepth + 4)).Position,
				shieldVisual = Shield.build(frame, width, depth),
			})
		end
	end
	return bases
end

function Base.isSheltered(base, position)
	local point = base.frame:PointToObjectSpace(position)
	return math.abs(point.X) < halfWidth - 0.8 and point.Z > -halfDepth + 1 and point.Z < halfDepth - 1 and point.Y >= 0 and point.Y < 13
end

function Base.freeSlot(state)
	for index = 1, Money.capacity(state) do
		if not state.slots[index] then
			return index
		end
	end
end

function Base.refreshStands(state)
	for index, stand in ipairs(state.base.stands) do
		stand.Color = index <= Money.capacity(state) and World.aqua or World.steel
	end
end

function Base.parkUnit(state, index, slot, onRaid)
	local stand = state.base.stands[index]
	slot.inTransit = false
	slot.model = Models.sculpt(state.base.model, slot.unit, stand.CFrame * CFrame.new(0, 0.29, 0), slot.unit.entry[7])
	state.slots[index] = slot
	for _, part in ipairs(slot.model:GetChildren()) do
		if part:IsA("BasePart") then
			part.CanQuery = true
		end
	end
	local click = Instance.new("ClickDetector")
	click.MaxActivationDistance = 10
	click.Parent = slot.model
	click.MouseClick:Connect(function(player)
		if player == state.player then
			onRaid(player, state, index, slot)
		end
	end)
	local prompt = World.prompt(slot.model.PrimaryPart, "Raid", slot.unit.entry[1], 1.25)
	prompt:SetAttribute("HideForUserId", state.player.UserId)
	prompt.Triggered:Connect(function(player)
		if player ~= state.player then
			onRaid(player, state, index, slot)
		end
	end)
	Money.publish(state)
end

function Base.clearCollection(state)
	for _, slot in pairs(state.slots) do
		if slot.model then
			slot.model:Destroy()
		end
	end
	table.clear(state.slots)
end

return Base
