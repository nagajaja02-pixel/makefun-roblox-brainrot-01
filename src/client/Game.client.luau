local Players=game:GetService("Players")
local Run=game:GetService("RunService")
local player=Players.LocalPlayer
local remotes=game.ReplicatedStorage:WaitForChild("BlitzRemotes")
local gui=Instance.new("ScreenGui") gui.Name="BrainrotBlitzHUD" gui.ResetOnSpawn=false gui.IgnoreGuiInset=false gui.Parent=player:WaitForChild("PlayerGui")
local function label(name,size,pos,anchor,fontSize)
 local l=Instance.new("TextLabel") l.Name=name l.Size=size l.Position=pos l.AnchorPoint=anchor or Vector2.zero l.BackgroundTransparency=1
 l.TextColor3=Color3.fromRGB(244,248,255) l.TextStrokeColor3=Color3.fromRGB(19,28,48) l.TextStrokeTransparency=0.12 l.Font=Enum.Font.GothamBold l.TextSize=fontSize or 20 l.TextWrapped=true l.Parent=gui return l
end
local money=label("Cash",UDim2.fromOffset(330,82),UDim2.new(0,18,1,-22),Vector2.new(0,1),28) money.TextXAlignment=Enum.TextXAlignment.Left
local wave=label("Wave",UDim2.new(0.6,0,0,56),UDim2.fromScale(0.5,0),Vector2.new(0.5,0),19)
local tip=label("Instructions",UDim2.new(0.72,0,0,55),UDim2.new(0.5,0,1,-10),Vector2.new(0.5,1),14)
local notice=label("Notice",UDim2.new(0.8,0,0,64),UDim2.fromScale(0.5,0.22),Vector2.new(0.5,0),22)
local shield=label("Shield",UDim2.fromOffset(300,65),UDim2.fromOffset(16,15),nil,15) shield.TextXAlignment=Enum.TextXAlignment.Left
local serial=0
remotes.Notice.OnClientEvent:Connect(function(message)
 serial+=1 local current=serial notice.Text=message
 task.delay(4,function() if current==serial then notice.Text="" end end)
end)
require(script.Parent.Menu).mount(gui,player,remotes.Action)
require(script.Parent.CarryPose).start(player)
local function camera(character)
 local hum=character:WaitForChild("Humanoid")
 workspace.CurrentCamera.CameraType=Enum.CameraType.Custom workspace.CurrentCamera.CameraSubject=hum
 player.CameraMinZoomDistance=8 player.CameraMaxZoomDistance=38
end
player.CharacterAdded:Connect(camera)
if player.Character then task.spawn(camera,player.Character) end
Run.RenderStepped:Connect(function()
 local now=workspace:GetServerTimeNow()
 money.Text="$"..math.floor(player:GetAttribute("Cash") or 150).."\n+$"..(player:GetAttribute("Income") or 0).."/s"
 local phase=workspace:GetAttribute("WavePhase") or "CALM"
 local countdown=math.max(0,math.ceil((workspace:GetAttribute("WaveDeadline") or now)-now))
 wave.Text=phase=="CALM" and ("BRAINROT BLITZ · Wave in "..countdown.."s") or (phase.." · "..countdown.."s")
 wave.TextColor3=phase=="CALM" and Color3.fromRGB(244,248,255) or Color3.fromRGB(255,199,101)
 local active=math.ceil((player:GetAttribute("ShieldUntil") or 0)-now)
 local cooldown=math.ceil((player:GetAttribute("CooldownUntil") or 0)-now)
 shield.Text="SAFEHOUSE "..string.format("%02d",player:GetAttribute("Plot") or 0).." · "..(player:GetAttribute("Capacity") or 4).." stands\n"..(active>0 and ("Shield active · "..active.."s") or (cooldown>0 and ("Shield recharge · "..cooldown.."s") or "Shield ready"))
 tip.Text=player:GetAttribute("Carrying") and "CARRYING · Walk into your safehouse to deliver. Leave and return to rearrange. Shop sells for 50%." or "E / Tap: buy or pick up · Hold Raid: steal · Return home when the wave warning starts!"
end)
