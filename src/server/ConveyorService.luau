local Data = require(game:GetService("ReplicatedStorage"):WaitForChild("BrainrotData"))
local Models = require(script.Parent.BrainrotModels)
local Steal = require(script.Parent.StealService)
local World = require(script.Parent.World)
local Conveyor = {}
local secondsPerOffer = 3.4
local beltSpeed = 4.2
local yaw = CFrame.Angles(0,-math.pi/2,0)

function Conveyor.start(parent)
	local records = {}
	local random = Random.new()
	local elapsed, serial = 0,0
	local function offerAt(x,offer)
		local model = Models.create(offer,parent,CFrame.new(x,World.beltTop,0)*yaw)
		local prompt = World.prompt(model.PrimaryPart,"Buy",("$%d • %s"):format(offer.price,offer.character.name),0,10)
		local record = {model=model,prompt=prompt,offer=offer,x=x,age=0}
		records[record] = true
		prompt.Triggered:Connect(function(player)
			if records[record] and Steal.buy(player,record) then
				records[record] = nil
			end
		end)
	end
	local starter = {2,1,3}
	for index = 1,7 do
		local characterIndex = starter[index-4]
		local offer = characterIndex and Data.offer(Data.cast[characterIndex]) or Data.roll(random,false)
		offerAt(World.importCurtain+index*17,offer)
	end
	return function(dt)
		for record in records do
			record.x += beltSpeed*dt
			record.age += dt
			if record.x >= World.receiverCurtain+6 then
				record.model:Destroy()
				records[record] = nil
			else
				local bounce = math.abs(math.sin(record.age*7))*0.26
				record.model:PivotTo(CFrame.new(record.x,World.beltTop+bounce,0)*yaw)
			end
		end
		elapsed += dt
		while elapsed >= secondsPerOffer do
			elapsed -= secondsPerOffer
			serial += 1
			offerAt(World.import,Data.roll(random,serial%3 == 0))
		end
	end
end

return Conveyor
