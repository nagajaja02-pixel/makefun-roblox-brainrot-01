local World = require(script.Parent.World)

local Shield = {}
local activeDuration = 26
local cooldown = 48
local cyan = Color3.fromRGB(36, 232, 255)

function Shield.build(frame, width, depth)
	local visual = Instance.new("Folder")
	visual.Name = "Shield lasers"
	local height = 7.4
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
		local x, z = side * (width / 2 + 0.1), side * (depth / 2 + 0.1)
		laser("Shield side", 0.1, height, depth, x, height / 2, 0, 0.92)
		laser("Shield end", width, height, 0.1, 0, height / 2, z, 0.92)
		laser("Shield side beam", 0.26, 0.26, depth + 0.4, x, height, 0, 0.12)
		laser("Shield end beam", width + 0.4, 0.26, 0.26, 0, height, z, 0.12)
		for along = -depth / 2, depth / 2, 4 do
			laser("Shield side bar", 0.21, height, 0.21, x, height / 2, along, 0.22)
		end
		for along = -width / 2 + 3, width / 2 - 3, 4 do
			laser("Shield end bar", 0.21, height, 0.21, along, height / 2, z, 0.22)
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
