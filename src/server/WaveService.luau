local Players = game:GetService("Players")
local Base = require(script.Parent.BaseService)
local Steal = require(script.Parent.StealService)
local World = require(script.Parent.World)
local Wave = {}
local V = Vector3.new

function Wave.start(parent,plots,notice,started)
	local water = World.part(parent,"Tsunami wall",V(11,16,200),V(-146,8,0),
		Color3.fromRGB(35,172,235),Enum.Material.Glass,false,1)
	local crest = World.part(parent,"Tsunami crest",V(12,2,200),V(-146,16,0),
		World.aqua,Enum.Material.Neon,false,1)
	local nextWave = started+52
	local sweepStart
	local touched = {}
	return function(now)
		if not sweepStart and now >= nextWave then
			notice:FireAllClients("Tsunami incoming! Reach your safehouse.",14)
			sweepStart = nextWave+14
			table.clear(touched)
		end
		if not sweepStart or now < sweepStart then
			return
		end
		local fraction = math.min((now-sweepStart)/8,1)
		local x = -146+292*fraction
		water.Position, crest.Position = V(x,8,0),V(x,16,0)
		water.Transparency, crest.Transparency = 0.29,0.12
		for _, player in Players:GetPlayers() do
			local root = Steal.root(player)
			if not root or touched[player] then
				continue
			end
			local pos = root.Position
			if math.abs(pos.Z) <= 100 and math.abs(pos.X-x) <= 8 then
				touched[player] = true
				local sheltered = false
				for _, plot in plots do
					if Base.isSheltered(plot,pos) then
						sheltered = true
						break
					end
				end
				if sheltered then
					notice:FireClient(player,"Safehouse held.",3)
				else
					root.Parent:FindFirstChildOfClass("Humanoid").Health = 0
					notice:FireClient(player,"Swept away!",3)
				end
			end
		end
		if fraction == 1 then
			water.Transparency, crest.Transparency = 1,1
			nextWave = sweepStart+8+54
			sweepStart = nil
		end
	end
end

return Wave
