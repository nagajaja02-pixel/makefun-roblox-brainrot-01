local RunService = game:GetService("RunService")
local CarryPose = {}

function CarryPose.bind(player)
	local shoulders = {}
	local function restore()
		for joint, resting in shoulders do
			if joint.Parent then
				joint.C0 = resting
				joint.Transform = CFrame.identity
			end
		end
		table.clear(shoulders)
	end
	player.CharacterRemoving:Connect(restore)
	local function apply(transformOnly)
		local character = player.Character
		if not character or not player:GetAttribute("Carrying") then
			if next(shoulders) then
				restore()
			end
			return
		end
		local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
		if not torso then
			return
		end
		for _, side in {"Left","Right"} do
			local joint = torso:FindFirstChild(side.."Shoulder")
				or torso:FindFirstChild(side.." Shoulder")
			if not joint then
				local arm = character:FindFirstChild(side.."UpperArm")
				joint = arm and arm:FindFirstChild(side.."Shoulder")
			end
			if joint and joint:IsA("Motor6D") then
				local resting = shoulders[joint] or joint.C0
				shoulders[joint] = resting
				if not transformOnly then
					local rotation = CFrame.Angles(math.rad(155),0,math.rad(side == "Left" and -14 or 14))
					joint.C0 = CFrame.new(resting.Position)*rotation*resting.Rotation
				end
				joint.Transform = CFrame.identity
			end
		end
	end
	RunService.RenderStepped:Connect(function()
		apply(false)
	end)
	RunService.PreSimulation:Connect(function()
		apply(true)
	end)
end

return CarryPose
