local PhysicsService = game:GetService("PhysicsService")
local World = require(script.Parent.World)
local Shield = {}
local V = Vector3.new

local function ownerGroup(index)
	return "BlitzOwner"..index
end

local function barrierGroup(index)
	return "BlitzBarrier"..index
end

function Shield.build(plots)
	for _, plot in plots do
		PhysicsService:RegisterCollisionGroup(ownerGroup(plot.index))
		PhysicsService:RegisterCollisionGroup(barrierGroup(plot.index))
	end
	for _, plot in plots do
		local group = barrierGroup(plot.index)
		PhysicsService:CollisionGroupSetCollidable(group,"Default",true)
		for _, other in plots do
			PhysicsService:CollisionGroupSetCollidable(group,ownerGroup(other.index),plot ~= other)
			PhysicsService:CollisionGroupSetCollidable(group,barrierGroup(other.index),false)
		end
		plot.shieldUntil = 0
		plot.shieldReady = 0
		plot.lasers = {}
		local function laser(name,size,x,y,z,collision,alpha)
			local part = World.part(plot.model,name,size,plot.origin*CFrame.new(x,y,z),World.aqua,Enum.Material.Neon,false,1)
			part.CollisionGroup = group
			table.insert(plot.lasers,{part=part, collision=collision, alpha=alpha})
		end
		for _, side in {-1,1} do
			laser("Shield barrier",V(0.3,10,40),side*13.25,5.4,0,true,0.87)
			laser("Shield barrier",V(26.8,10,0.3),0,5.4,side*20,true,0.87)
			laser("Shield top frame",V(0.26,0.26,40),side*13.25,10.4,0,false,0.17)
			laser("Shield top frame",V(26.8,0.26,0.26),0,10.4,side*20,false,0.17)
			for z = -20,20,4 do
				laser("Laser bar",V(0.26,10,0.26),side*13.25,5.4,z,false,0.27)
			end
			for x = -12,12,3 do
				laser("Laser bar",V(0.26,10,0.26),x,5.4,side*20,false,0.27)
			end
		end
	end
end

function Shield.assign(character,plot)
	local function assignPart(part)
		if part:IsA("BasePart") then
			part.CollisionGroup = plot and ownerGroup(plot.index) or "Default"
		end
	end
	character.DescendantAdded:Connect(assignPart)
	for _, part in character:GetDescendants() do
		assignPart(part)
	end
end

local function show(plot,active)
	for _, laser in plot.lasers do
		laser.part.Transparency = active and laser.alpha or 1
		laser.part.CanCollide = active and laser.collision
	end
end

function Shield.active(plot,now)
	return now < plot.shieldUntil
end

function Shield.activate(plot,now)
	if now < plot.shieldReady then
		return false
	end
	plot.shieldUntil = now+26
	plot.shieldReady = plot.shieldUntil+48
	show(plot,true)
	return true
end

function Shield.step(plots,now)
	for _, plot in plots do
		if plot.shieldUntil > 0 and not Shield.active(plot,now) then
			plot.shieldUntil = 0
			show(plot,false)
		end
	end
end

function Shield.reset(plot)
	plot.shieldUntil = 0
	plot.shieldReady = 0
	show(plot,false)
end

return Shield
