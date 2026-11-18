local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local UserInputService=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local player=Players.LocalPlayer
local remote=ReplicatedStorage:WaitForChild("BlitzEvent")
local Menu=require(script.Parent:WaitForChild("Menu"))
local CarryPose=require(script.Parent:WaitForChild("CarryPose"))
local gui=Instance.new("ScreenGui") gui.Name="BrainrotBlitzHUD" gui.ResetOnSpawn=false gui.IgnoreGuiInset=false gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling gui.Parent=player:WaitForChild("PlayerGui")
local white=Color3.fromRGB(244,248,255) local aqua=Color3.fromRGB(78,255,218) local ink=Color3.fromRGB(19,28,48)
local function label(name,pos,size,textSize,color,align)
 local l=Instance.new("TextLabel") l.Name=name l.Position=pos l.Size=size l.BackgroundTransparency=1 l.Font=Enum.Font.GothamBold l.TextSize=textSize l.TextColor3=color or white l.TextStrokeColor3=ink l.TextStrokeTransparency=0.15 l.TextXAlignment=align or Enum.TextXAlignment.Left l.TextWrapped=true l.Parent=gui return l
end
local money=label("Cash",UDim2.new(0,20,1,-134),UDim2.fromOffset(300,42),34,aqua)
local income=label("Income",UDim2.new(0,22,1,-94),UDim2.fromOffset(330,26),18,white)
local progress=label("SafehouseProgress",UDim2.new(0,22,1,-66),UDim2.fromOffset(360,24),14,white)
local carry=label("CarryHint",UDim2.new(0.5,-230,1,-48),UDim2.new(0,460,0,40),15,aqua,Enum.TextXAlignment.Center)
local wave=label("WaveTimer",UDim2.new(0.5,-175,0,60),UDim2.fromOffset(350,31),20,white,Enum.TextXAlignment.Center)
local notice=label("Notification",UDim2.new(0.1,0,0,100),UDim2.new(0.8,0,0,55),20,aqua,Enum.TextXAlignment.Center)
local shield=label("ShieldState",UDim2.new(1,-300,1,-106),UDim2.fromOffset(280,58),15,white,Enum.TextXAlignment.Right)
local function format(number)
 local str=tostring(math.floor(number))
 while true do local nextString,count=string.gsub(str,"^(%-?%d+)(%d%d%d)","%1,%2") str=nextString if count==0 then break end end
 return str
end
local function refresh()
 money.Text="$"..format(player:GetAttribute("Cash") or 150)
 income.Text="+$"..format(player:GetAttribute("Income") or 0).." / second"
 progress.Text="SAFEHOUSE "..(player:GetAttribute("Plot") or "—").."  ·  "..(player:GetAttribute("Capacity") or 4).." stands  ·  "..(player:GetAttribute("Rebirths") or 0).." rebirths"
 carry.Text=player:GetAttribute("Carrying") and ((player:GetAttribute("CarriedName") or "Brainrot").."\nReturn home to deliver · Shop to sell") or "E / tap: buy, pick up or raid · R: rebirth · I: index"
 local active=player:GetAttribute("ShieldSeconds") or 0 local cooldown=player:GetAttribute("ShieldCooldown") or 0
 shield.Text=active>0 and ("SHIELD ACTIVE · "..active.."s") or (cooldown>0 and ("SHIELD COOLDOWN · "..cooldown.."s") or "SHIELD READY · use your terminal")
end
for _,name in ipairs({"Cash","Income","Plot","Capacity","Rebirths","Carrying","CarriedName","ShieldSeconds","ShieldCooldown"}) do player:GetAttributeChangedSignal(name):Connect(refresh) end
local function waveRefresh()
 local phase=workspace:GetAttribute("WavePhase") or "CALM" local seconds=workspace:GetAttribute("WaveSeconds") or 52
 wave.Text=(phase=="CALM" and "NEXT TSUNAMI · " or phase=="EVACUATE" and "EVACUATE · " or "TSUNAMI · ")..seconds.."s"
 wave.TextColor3=phase=="CALM" and white or Color3.fromRGB(255,191,80)
end
workspace:GetAttributeChangedSignal("WaveSeconds"):Connect(waveRefresh) workspace:GetAttributeChangedSignal("WavePhase"):Connect(waveRefresh)
local messageVersion=0
remote.OnClientEvent:Connect(function(kind,message)
 if kind~="Notice" or type(message)~="string" then return end
 messageVersion+=1 local version=messageVersion notice.Text=message notice.TextTransparency=0
 task.delay(5,function() if version==messageVersion then TweenService:Create(notice,TweenInfo.new(0.5),{TextTransparency=1}):Play() end end)
end)
local open=Menu.mount(gui,player,remote)
UserInputService.InputBegan:Connect(function(input,processed)
 if processed then return end
 if input.KeyCode==Enum.KeyCode.R then open("Rebirth") elseif input.KeyCode==Enum.KeyCode.I then open("Index") end
end)
local function camera(character)
 local humanoid=character:WaitForChild("Humanoid",10)
 if humanoid then
  local view=workspace.CurrentCamera view.CameraType=Enum.CameraType.Custom view.CameraSubject=humanoid view.FieldOfView=70
  player.CameraMinZoomDistance=7 player.CameraMaxZoomDistance=45
 end
end
player.CharacterAdded:Connect(camera) if player.Character then task.spawn(camera,player.Character) end
CarryPose.start() refresh() waveRefresh()
