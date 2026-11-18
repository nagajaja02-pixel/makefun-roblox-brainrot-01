local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local ui = Instance.new("ScreenGui")
ui.Name = "Brainrot Blitz HUD"
ui.ResetOnSpawn = false
ui.Parent = player:WaitForChild("PlayerGui")

local ink = Color3.fromRGB(18, 26, 44)
local white = Color3.fromRGB(240, 247, 255)
local aqua = Color3.fromRGB(104, 255, 222)
local gold = Color3.fromRGB(255, 204, 112)
local red = Color3.fromRGB(255, 133, 148)
local muted = Color3.fromRGB(169, 193, 215)

local function round(frame, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = frame
end

local function panel(name, position, anchor, width, height)
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.Position = position
	frame.AnchorPoint = anchor
	frame.Size = UDim2.fromOffset(width, height)
	frame.BackgroundColor3 = ink
	frame.BackgroundTransparency = 0.08
	frame.Parent = ui
	round(frame, 12)
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(90, 122, 155)
	stroke.Transparency = 0.45
	stroke.Parent = frame
	return frame
end

local function label(parent, x, y, height, size, color, align)
	local item = Instance.new("TextLabel")
	item.BackgroundTransparency = 1
	item.Position = UDim2.fromOffset(x, y)
	item.Size = UDim2.new(1, -2 * x, 0, height)
	item.TextColor3 = color
	item.TextXAlignment = align or Enum.TextXAlignment.Left
	item.TextSize = size
	item.TextTruncate = Enum.TextTruncate.AtEnd
	item.Font = Enum.Font.GothamBold
	item.Parent = parent
	return item
end

local centered = Enum.TextXAlignment.Center
local economy = panel("Economy", UDim2.new(0, 14, 0, 53), Vector2.zero, 216, 113)
label(economy, 14, 7, 20, 15, aqua).Text = "BRAINROT BLITZ"
local cash = label(economy, 14, 28, 37, 30, white)
local rate = label(economy, 14, 65, 20, 16, aqua)
local crew = label(economy, 14, 85, 19, 13, muted)

local alerts = panel("Tsunami", UDim2.new(1, -14, 0, 53), Vector2.new(1, 0), 200, 69)
local wave = label(alerts, 12, 7, 27, 18, aqua)
local shield = label(alerts, 12, 36, 24, 13, muted)

local orders = panel("Objective", UDim2.new(0.5, 0, 1, -28), Vector2.new(0.5, 1), 440, 57)
local objective = label(orders, 10, 5, 26, 17, white, centered)
local upgrade = label(orders, 10, 30, 21, 13, muted, centered)
local toast = panel("Feedback", UDim2.new(0.5, 0, 1, -97), Vector2.new(0.5, 1), 465, 42)
local toastLabel = label(toast, 10, 4, 34, 15, white, centered)
toast.Visible = false

local flash = Instance.new("Frame")
flash.Size = UDim2.fromScale(1, 1)
flash.BackgroundTransparency = 1
flash.ZIndex = 0
flash.Parent = ui

local toastSerial = 0
local flashTween
ReplicatedStorage:WaitForChild("BlitzFeedback").OnClientEvent:Connect(function(text, style)
	toastSerial += 1
	local serial = toastSerial
	local tint = style == "warning" and red or aqua
	toastLabel.Text = text
	toastLabel.TextColor3 = tint
	toast.Visible = true
	if flashTween then
		flashTween:Cancel()
	end
	flash.BackgroundColor3 = tint
	flash.BackgroundTransparency = 0.89
	flashTween = TweenService:Create(flash, TweenInfo.new(0.55), { BackgroundTransparency = 1 })
	flashTween:Play()
	task.delay(3.5, function()
		if toastSerial == serial then
			toast.Visible = false
		end
	end)
end)

local function refreshEconomy()
	cash.Text = "$" .. tostring(player:GetAttribute("Cash") or 0)
	rate.Text = "+$" .. tostring(player:GetAttribute("Rate") or 0) .. " / sec"
	crew.Text = string.format("%d stands   •   %d rebirths", player:GetAttribute("Capacity") or 4, player:GetAttribute("Rebirths") or 0)
	local price = player:GetAttribute("Level") == 3 and "All stands unlocked"
		or "Expand $" .. tostring(player:GetAttribute("UpgradePrice") or 550)
	upgrade.Text = price .. "   •   Rebirth $" .. tostring(player:GetAttribute("RebirthPrice") or 12000)
	local cargo = player:GetAttribute("Carrying")
	if cargo and cargo ~= "" then
		objective.Text = "DELIVER  /  " .. cargo
		objective.TextColor3 = gold
	else
		objective.Text = "Buy an import on the conveyor"
		objective.TextColor3 = white
	end
end

for _, attribute in ipairs({ "Cash", "Rate", "Capacity", "Level", "Rebirths", "UpgradePrice", "RebirthPrice", "Carrying" }) do
	player:GetAttributeChangedSignal(attribute):Connect(refreshEconomy)
end
refreshEconomy()

local homeMarker = Instance.new("Part")
homeMarker.Name = "Home direction"
homeMarker.Size = Vector3.one
homeMarker.Anchored = true
homeMarker.CanCollide = false
homeMarker.CanTouch = false
homeMarker.CanQuery = false
homeMarker.Transparency = 1
homeMarker.Parent = workspace
local beacon = Instance.new("BillboardGui")
beacon.Size = UDim2.fromOffset(120, 29)
beacon.AlwaysOnTop = true
beacon.MaxDistance = 235
beacon.Parent = homeMarker
label(beacon, 0, 0, 29, 20, aqua, centered).Text = "▼ HOME"

local function markHome()
	local home = player:GetAttribute("Home")
	beacon.Enabled = home ~= nil
	if home then
		homeMarker.Position = home + Vector3.new(0, 10, 0)
	end
end
player:GetAttributeChangedSignal("Home"):Connect(markHome)
markHome()

ProximityPromptService.PromptShown:Connect(function(prompt)
	if prompt:GetAttribute("HideForUserId") == player.UserId then
		prompt.Enabled = false
	end
end)

local function fitHUD()
	local camera = workspace.CurrentCamera
	if not camera then
		return
	end
	local viewport = camera.ViewportSize
	local width = viewport.X
	local compact = width < 480
	economy.Size = UDim2.fromOffset(compact and 158 or 216, 113)
	alerts.Size = UDim2.fromOffset(compact and 147 or 200, 69)
	orders.Size = UDim2.fromOffset(math.max(1, math.min(width - 26, 440)), 57)
	toast.Size = UDim2.fromOffset(math.max(1, math.min(width - 26, 465)), 42)
	wave.TextSize = compact and 13 or 18
	if viewport.Y < 570 then
		orders.Position = UDim2.new(0.5, 0, 1, -63)
		toast.Position = UDim2.new(0.5, 0, 1, -131)
	else
		orders.Position = UDim2.new(0.5, 0, 1, -28)
		toast.Position = UDim2.new(0.5, 0, 1, -97)
	end
end

local clock = 1
RunService.Heartbeat:Connect(function(dt)
	clock += dt
	if clock < 0.15 then
		return
	end
	clock = 0
	local now = workspace:GetServerTimeNow()
	local phase = workspace:GetAttribute("WavePhase") or "CLEAR"
	local seconds = math.max(0, math.ceil((workspace:GetAttribute("WaveAt") or now) - now))
	wave.Text = (phase == "CLEAR" and "WAVE ALERT" or phase) .. "  " .. seconds .. "s"
	wave.TextColor3 = phase == "CLEAR" and aqua or phase == "EVACUATE" and gold or red
	local locked = math.max(0, math.ceil((player:GetAttribute("LockUntil") or now) - now))
	local ready = math.max(0, math.ceil((player:GetAttribute("LockReady") or now) - now))
	shield.Text = locked > 0 and ("Shield up  •  " .. locked .. "s") or ready > 0 and ("Shield ready in " .. ready .. "s") or "Shield ready at base"
	shield.TextColor3 = locked > 0 and aqua or muted
	fitHUD()
end)
