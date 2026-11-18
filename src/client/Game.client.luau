local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local Menu = require(script.Parent.Menu)
local CarryPose = require(script.Parent.CarryPose)

local player = Players.LocalPlayer
local events = ReplicatedStorage:WaitForChild("BlitzEvents")
local gui = Instance.new("ScreenGui")
gui.Name = "Brainrot Blitz HUD"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local function label(name,size,position,anchor)
	local element = Instance.new("TextLabel")
	element.Name = name
	element.Size = size
	element.Position = position
	element.AnchorPoint = anchor
	element.BackgroundTransparency = 1
	element.Font = Enum.Font.GothamBold
	element.TextColor3 = Color3.fromRGB(244,248,255)
	element.TextStrokeTransparency = 0.16
	element.Parent = gui
	return element
end

local balance = label("Cash",UDim2.fromOffset(230,30),UDim2.new(0,18,1,-38),Vector2.new(0,1))
balance.TextXAlignment = Enum.TextXAlignment.Left
balance.TextSize = 27
local income = label("Income",UDim2.fromOffset(230,24),UDim2.new(0,18,1,-16),Vector2.new(0,1))
income.TextXAlignment = Enum.TextXAlignment.Left
income.TextSize = 17
income.TextColor3 = Color3.fromRGB(126,249,182)
local function refresh()
	balance.Text = "$"..Menu.format(player:GetAttribute("Cash") or 150)
	income.Text = "+$"..Menu.format(player:GetAttribute("Income") or 0).."/s"
end
player:GetAttributeChangedSignal("Cash"):Connect(refresh)
player:GetAttributeChangedSignal("Income"):Connect(refresh)
refresh()

local banner = label("Harbor notices",UDim2.new(0.84,0,0,48),UDim2.new(0.5,0,0,57),Vector2.new(0.5,0))
banner.TextSize = 22
banner.TextWrapped = true
banner.Visible = false
local generation = 0
events:WaitForChild("Notice").OnClientEvent:Connect(function(message,seconds)
	generation += 1
	local token = generation
	banner.Text = message
	banner.Visible = true
	task.delay(seconds,function()
		if token == generation then
			banner.Visible = false
		end
	end)
end)

local dismiss = Menu.mount(gui,player,events:WaitForChild("Rebirth"))
UserInputService.InputBegan:Connect(function(input,processed)
	if not processed and input.KeyCode == Enum.KeyCode.Escape then
		dismiss()
	end
end)

local function configurePrompt(prompt)
	local action = prompt:GetAttribute("InventoryAction")
	if action and prompt.Parent then
		local mine = prompt.Parent:GetAttribute("PlotOwner") == player.UserId
		prompt.Style = ((action == "Own") == mine) and Enum.ProximityPromptStyle.Default or Enum.ProximityPromptStyle.Custom
	end
end
local harbor = workspace:WaitForChild("Blitz Harbor")
harbor.DescendantAdded:Connect(function(instance)
	if instance:IsA("ProximityPrompt") then
		task.defer(configurePrompt,instance)
	end
end)
for _, instance in harbor:GetDescendants() do
	if instance:IsA("ProximityPrompt") then
		configurePrompt(instance)
	end
end
ProximityPromptService.PromptShown:Connect(configurePrompt)

player.CameraMode = Enum.CameraMode.Classic
player.CameraMinZoomDistance = 4
player.CameraMaxZoomDistance = 32
CarryPose.bind(player)
