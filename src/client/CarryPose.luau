local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local CarryPose={records={}}
local function restore(record)
 for motor,original in pairs(record.motors) do if motor.Parent then motor.C0=original motor.Transform=CFrame.identity end end
 record.motors={}
end
local function update(player)
 local record=CarryPose.records[player] if not record then return end
 local char=player.Character
 if record.character~=char then restore(record) record.character=char end
 if not char or not player:GetAttribute("Carrying") then
  if next(record.motors) then restore(record) end
  return
 end
 for _,joint in ipairs(char:GetDescendants()) do
  if joint:IsA("Motor6D") and (joint.Name=="Right Shoulder" or joint.Name=="Left Shoulder" or joint.Name=="RightShoulder" or joint.Name=="LeftShoulder") then
   if not record.motors[joint] then record.motors[joint]=joint.C0 end
   local original=record.motors[joint]
   if joint.Name=="Right Shoulder" then joint.C0=original*CFrame.Angles(0,0,math.rad(165))
   elseif joint.Name=="Left Shoulder" then joint.C0=original*CFrame.Angles(0,0,math.rad(-165))
   else joint.C0=original*CFrame.Angles(math.rad(165),0,0) end
   joint.Transform=CFrame.identity
  end
 end
end
function CarryPose.start()
 local function add(player) CarryPose.records[player]={motors={}} end
 for _,player in ipairs(Players:GetPlayers()) do add(player) end
 Players.PlayerAdded:Connect(add)
 Players.PlayerRemoving:Connect(function(player)
  local record=CarryPose.records[player] if record then restore(record) end CarryPose.records[player]=nil
 end)
 RunService.PreSimulation:Connect(function()
  for player in pairs(CarryPose.records) do update(player) end
 end)
 RunService:BindToRenderStep("BlitzCarryPose",Enum.RenderPriority.Character.Value+1,function()
  for player in pairs(CarryPose.records) do update(player) end
 end)
end
return CarryPose
