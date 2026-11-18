local World = require(script.Parent.World)
local Money = require(script.Parent.MoneyService)
local Models = require(script.Parent.BrainrotModels)

local Base = {}
Base.lockDuration = 26
Base.lockCooldown = 48
Base.startingCash = 150

local plotColors = {
	Color3.fromRGB(27, 192, 190), Color3.fromRGB(250, 115, 93), Color3.fromRGB(85, 144, 247),
	Color3.fromRGB(197, 119, 247), Color3.fromRGB(103, 200, 92), Color3.fromRGB(248, 177, 56),
}

function Base.build(map)
	local bases = {}
	for _, z in ipairs({ -36, 36 }) do
		for _, x in ipairs({ 0, -64, 64 }) do
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
			local metal = Enum.Material.Metal
			part("Shelter deck", Vector3.new(48, 0.4, 28), 0, 0.2, 0, pale, Enum.Material.Concrete)
			part("Back wall", Vector3.new(48, 7, 0.65), 0, 3.5, 13.5, pale)
			local function trim(name, sx, sy, sz, lx, ly, lz, color, material)
				local item = part(name, Vector3.new(sx, sy, sz), lx, ly, lz, color, material)
				item.CanCollide = false
				item.CanTouch = false
				item.CanQuery = false
				return item
			end
			for _, side in ipairs({ -1, 1 }) do
				part("Shelter column", Vector3.new(1, 8, 1), side * 23.5, 4, -12, World.steel)
				trim("Side cladding", 0.55, 3.5, 26, side * 23.5, 2.17, 0, accent, metal)
				trim("Side transom", 0.55, 0.45, 26, side * 23.5, 7.65, 0, accent, metal)
				for _, zBay in ipairs({ -7, 1.5, 10 }) do
					trim("Side window", 0.35, 3.35, 7.8, side * 23.5, 5.62, zBay, pale, Enum.Material.Glass).Transparency = 0.46
					trim("Side mullion", 0.65, 4.1, 0.45, side * 23.5, 5.75, zBay + 3.9, accent, metal)
				end
				trim("Entry floor stripe", 0.26, 0.04, 21, side * 4.75, 0.42, -2.5, accent)
				trim("Interior light", 19, 0.18, 0.5, side * 12, 7.65, 2, World.white, Enum.Material.Neon)
			end
			for lx = -21, 21, 6 do
				trim("Back wall rib", 0.28, 6.7, 0.24, lx, 3.9, 13.1, pale, metal)
			end
			trim("Shelter roof", 49, 0.65, 27, 0, 8.35, 1, accent, metal)
			trim("Roof raised center", 36, 0.55, 23, 0, 8.85, 1, accent:Lerp(World.white, 0.3), metal)
			local fascia = trim("Safehouse nameboard", 22, 1.65, 0.65, 0, 8.85, -12.54, World.ink)
			World.surfaceSign(fascia, string.format("SAFEHOUSE  %02d", plot), World.white)
			local gate = part("Shield status", Vector3.new(48, 0.42, 0.7), 0, 8, -12, World.aqua, Enum.Material.Neon)
			local title = World.sign(gate, "AVAILABLE SAFEHOUSE", World.white, 255, 34, Vector3.new(0, 2.1, 0))
			local drop = part("Drop zone", Vector3.new(9, 0.19, 6), 0, 0.5, -5, World.aqua, Enum.Material.Neon)
			World.sign(drop, "DELIVERY  /  WAVE SHELTER", World.aqua, 235, 27, Vector3.new(0, 0.85, 0), 33)
			local controls = {}
			for index, titleText in ipairs({ "SHIELD", "EXPAND BASE", "REBIRTH" }) do
				local color = index == 1 and World.aqua or World.gold
				local terminal = part(titleText, Vector3.new(3.2, 1.25, 2.5), (index - 2) * 6, 1.02, 10.2, color)
				World.sign(terminal, titleText, color, 115, 23, Vector3.new(0, 1.4, 0), 23)
				controls[index] = terminal
			end
			local stands = {}
			for index = 1, 8 do
				local side = index % 2 == 1 and -1 or 1
				local column = index <= 4 and 9 or 17
				local row = (index - 1) % 4 < 2 and -5 or 4
				local stand = part("Income stand " .. index, Vector3.new(5.2, 0.55, 4), side * column, 0.67, row, World.steel)
				trim("Display pedestal", 5.4, 0.2, 4.2, side * column, 0.5, row, accent, metal)
				trim("Display front trim", 4.5, 0.12, 0.08, side * column, 0.74, row - 2.02, pale, Enum.Material.Neon)
				stands[index] = stand
			end
			table.insert(bases, { frame = frame, gate = gate, title = title, stands = stands, controls = controls, model = model })
		end
	end
	return bases
end

function Base.isSheltered(base, position)
	local point = base.frame:PointToObjectSpace(position)
	return math.abs(point.X) < 23.2 and point.Z > -12 and point.Z < 13 and point.Y >= 0 and point.Y < 13
end

function Base.updateShield(state, now)
	local locked = now < state.lockUntil
	state.base.gate.Color = locked and World.aqua or World.gold
	state.base.title.Text = string.format("%s  /  %s", state.player.DisplayName, locked and "SHIELDED" or "RAIDABLE")
	state.player:SetAttribute("LockUntil", state.lockUntil)
	state.player:SetAttribute("LockReady", state.lockReady)
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
	local prompt = World.prompt(slot.model.PrimaryPart, "Raid", slot.unit.entry[1], 1.25)
	prompt:SetAttribute("HideForUserId", state.player.UserId)
	prompt.Triggered:Connect(function(player)
		onRaid(player, state, index, slot)
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
