local World = require(script.Parent.World)

local Shield = {}
local activeDuration = 26
local cooldown = 48
local cyan = Color3.fromRGB(36, 232, 255)

function Shield.build(frame, cornerX, cornerZ, pierWidth, floor, top)
	local visual = Instance.new("Folder")
	visual.Name = "Shield lasers"
	local beamWidth = 0.26
	local height = top - beamWidth / 2 - floor
	local centerY = floor + height / 2
	local spanX, spanZ = 2 * cornerX - pierWidth, 2 * cornerZ - pierWidth
	local function laser(name, sx, sy, sz, x, y, z, transparency)
		local part = World.part(visual, name, Vector3.new(sx, sy, sz),
			frame * CFrame.new(x, y, z), cyan, Enum.Material.Neon)
		part.Transparency = transparency
		part.CanCollide = false
		part.CanTouch = false
		part.CanQuery = false
		part.CastShadow = false
	end

	for _, side in ipairs({ -1, 1 }) do
		local x, z = side * cornerX, side * cornerZ
		laser("Shield side", 0.1, height, spanZ, x, centerY, 0, 0.92)
		laser("Shield end", spanX, height, 0.1, 0, centerY, z, 0.92)
		laser("Shield side beam", beamWidth, beamWidth, spanZ, x, top, 0, 0.12)
		laser("Shield end beam", spanX, beamWidth, beamWidth, 0, top, z, 0.12)
		-- Bars extend into the top beam so their end faces are separate from the pane edges.
		for along = -16, 16, 4 do
			laser("Shield side bar", 0.21, height + 0.06, 0.21, x, centerY + 0.07, along, 0.22)
		end
		for along = -10, 10, 4 do
			laser("Shield end bar", 0.21, height + 0.06, 0.21, along, centerY + 0.07, z, 0.22)
		end
	end
	return visual
end

function Shield.update(state, now)
	local base = state.base
	local locked = now < state.lockUntil
	local parent = locked and base.model or nil
	if base.shieldVisual.Parent ~= parent then
		base.shieldVisual.Parent = parent
		base.gate.Color = locked and World.aqua or World.gold
		base.title.Text = string.format("%s  /  %s", state.player.DisplayName, locked and "SHIELDED" or "RAIDABLE")
	end
end

function Shield.activate(state, now)
	state.lockUntil = now + activeDuration
	state.lockReady = now + cooldown
	state.player:SetAttribute("LockUntil", state.lockUntil)
	state.player:SetAttribute("LockReady", state.lockReady)
	Shield.update(state, now)
end

function Shield.clear(base)
	base.shieldVisual.Parent = nil
	base.title.Text = "AVAILABLE SAFEHOUSE"
	base.gate.Color = World.aqua
end

return Shield
