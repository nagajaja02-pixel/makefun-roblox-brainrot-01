local Data = require(game:GetService("ReplicatedStorage"):WaitForChild("BrainrotData"))
local Menu = {}
local ink = Color3.fromRGB(19,28,48)
local white = Color3.fromRGB(244,248,255)
local aqua = Color3.fromRGB(78,255,218)

local function text(parent,class,name,value,size,position)
	local object = Instance.new(class)
	object.Name = name
	object.Text = value
	object.Size = size
	object.Position = position
	object.Font = Enum.Font.GothamBold
	object.TextSize = 15
	object.TextColor3 = white
	object.BackgroundColor3 = ink
	object.BorderSizePixel = 0
	object.Parent = parent
	return object
end

function Menu.format(amount)
	local digits = tostring(amount)
	return digits:reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,","")
end

function Menu.mount(gui,player,remote)
	local function button(parent,label,x,y,width)
		return text(parent,"TextButton",label,label,UDim2.fromOffset(width,36),UDim2.fromOffset(x,y))
	end
	local bar = Instance.new("Frame")
	bar.Size = UDim2.fromOffset(206,36)
	bar.AnchorPoint = Vector2.new(1,0)
	bar.Position = UDim2.new(1,-18,0,12)
	bar.BackgroundTransparency = 1
	bar.Parent = gui
	local rebirthButton = button(bar,"Rebirth",0,0,100)
	local indexButton = button(bar,"Index",106,0,100)

	local panel = Instance.new("Frame")
	panel.Size = UDim2.new(0.9,0,0.73,0)
	panel.AnchorPoint = Vector2.new(0.5,0.5)
	panel.Position = UDim2.fromScale(0.5,0.5)
	panel.BackgroundColor3 = ink
	panel.Visible = false
	panel.BorderSizePixel = 0
	panel.Parent = gui
	local bounds = Instance.new("UISizeConstraint")
	bounds.MaxSize = Vector2.new(460,520)
	bounds.Parent = panel

	local title = text(panel,"TextLabel","Title","",UDim2.new(1,-74,0,46),UDim2.fromOffset(10,0))
	title.TextSize = 21
	local close = button(panel,"Close",0,5,64)
	close.Position = UDim2.new(1,-70,0,5)

	local confirmPane = Instance.new("Frame")
	confirmPane.Size = UDim2.new(1,-24,1,-56)
	confirmPane.Position = UDim2.fromOffset(12,46)
	confirmPane.BackgroundTransparency = 1
	confirmPane.Parent = panel
	local summary = text(confirmPane,"TextLabel","Rebirth details","",UDim2.new(1,0,0,115),UDim2.fromOffset(0,0))
	summary.TextWrapped = true
	local confirm = button(confirmPane,"Confirm",0,124,109)
	confirm.BackgroundColor3 = aqua
	confirm.TextColor3 = ink
	local cancel = button(confirmPane,"Cancel",117,124,100)

	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1,-24,1,-60)
	scroll.Position = UDim2.fromOffset(12,47)
	scroll.CanvasSize = UDim2.fromOffset(0,0)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.ScrollingDirection = Enum.ScrollingDirection.Y
	scroll.ScrollBarThickness = 5
	scroll.BorderSizePixel = 0
	scroll.BackgroundTransparency = 1
	scroll.Parent = panel
	local rows = Instance.new("UIListLayout")
	rows.Padding = UDim.new(0,4)
	rows.Parent = scroll
	for index, entry in Data.cast do
		local rarity = Data.rarities[entry.tier]
		local row = text(scroll,"TextLabel",entry.key,
			("%s\n%s  •  $%s  •  +$%s/s"):format(entry.name,rarity.name,Menu.format(entry.price),Menu.format(entry.rate)),
			UDim2.new(1,-8,0,42),UDim2.fromOffset(0,0))
		row.TextColor3 = rarity.color
		row.BackgroundColor3 = Color3.fromRGB(30,43,64)
		row.TextWrapped = true
		row.LayoutOrder = index
	end

	local function updatePrice()
		local price = player:GetAttribute("RebirthPrice")
		confirm.Active = price ~= nil
		summary.Text = ("Cost $%s\nIncome bonus +50%%\nCash resets to $150 and your collection is cleared."):format(Menu.format(price or 12000))
	end
	local function show(mode)
		title.Text = mode
		confirmPane.Visible = mode == "Rebirth"
		scroll.Visible = mode == "Index"
		panel.Visible = true
		updatePrice()
	end
	player:GetAttributeChangedSignal("RebirthPrice"):Connect(updatePrice)
	rebirthButton.Activated:Connect(function() show("Rebirth") end)
	indexButton.Activated:Connect(function() show("Index") end)
	local function dismiss()
		panel.Visible = false
	end
	close.Activated:Connect(dismiss)
	cancel.Activated:Connect(dismiss)
	confirm.Activated:Connect(function()
		local price = player:GetAttribute("RebirthPrice")
		if price then
			remote:FireServer(price)
			dismiss()
		end
	end)
	return dismiss
end

return Menu
