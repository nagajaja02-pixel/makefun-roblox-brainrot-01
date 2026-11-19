local Run=game:GetService("RunService")
local Pose={}
function Pose.start(player)
 local joints={}
 local character
 local function bind(char)
  joints={} character=char
  task.spawn(function()
   char:WaitForChild("Humanoid",10)
   task.wait(0.4)
   if character~=char then return end
   for _,v in ipairs(char:GetDescendants()) do
    if v:IsA("Motor6D") and (v.Name=="Right Shoulder" or v.Name=="Left Shoulder" or v.Name=="RightShoulder" or v.Name=="LeftShoulder") then
     table.insert(joints,{joint=v,neutral=v.C0})
    end
   end
  end)
 end
 player.CharacterAdded:Connect(bind)
 if player.Character then bind(player.Character) end
 Run.PreSimulation:Connect(function()
  if player:GetAttribute("Carrying") then
   for _,record in ipairs(joints) do if record.joint.Parent then record.joint.Transform=CFrame.identity end end
  end
 end)
 Run.RenderStepped:Connect(function()
  local carrying=player:GetAttribute("Carrying")==true
  for _,record in ipairs(joints) do
   if record.joint.Parent then
    local r6=record.joint.Name:find(" ")~=nil
    local right=record.joint.Name:find("Right")~=nil
    local rotation=r6 and CFrame.Angles(0,0,right and math.rad(155) or math.rad(-155)) or CFrame.Angles(math.rad(165),0,right and -0.15 or 0.15)
    record.joint.C0=carrying and record.neutral*rotation or record.neutral
    if carrying then record.joint.Transform=CFrame.identity end
   end
  end
 end)
end
return Pose
