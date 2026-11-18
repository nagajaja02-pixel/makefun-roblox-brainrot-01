local Data=require(game:GetService("ReplicatedStorage").Shared.BrainrotData)
local Menu={}
function Menu.mount(gui,player,remote)
 local ink=Color3.fromRGB(19,28,48) local white=Color3.fromRGB(244,248,255) local aqua=Color3.fromRGB(78,255,218)
 local function text(parent,content,pos,size,fontSize)
  local l=Instance.new("TextLabel") l.BackgroundTransparency=1 l.Text=content l.Position=pos l.Size=size l.Font=Enum.Font.GothamBold l.TextSize=fontSize or 16 l.TextColor3=white l.TextWrapped=true l.Parent=parent return l
 end
 local function button(parent,content,pos,size,callback)
  local b=Instance.new("TextButton") b.Text=content b.Position=pos b.Size=size b.BackgroundColor3=ink b.TextColor3=aqua b.Font=Enum.Font.GothamBold b.TextSize=15 b.Parent=parent
  local corner=Instance.new("UICorner") corner.CornerRadius=UDim.new(0,9) corner.Parent=b b.Activated:Connect(callback) return b
 end
 local panel=Instance.new("Frame") panel.Name="MenuPanel" panel.AnchorPoint=Vector2.new(0.5,0.5) panel.Position=UDim2.fromScale(0.5,0.48) panel.Size=UDim2.new(0.9,0,0,390) panel.BackgroundColor3=ink panel.Visible=false panel.Parent=gui
 local constraint=Instance.new("UISizeConstraint") constraint.MaxSize=Vector2.new(560,390) constraint.Parent=panel
 local corner=Instance.new("UICorner") corner.CornerRadius=UDim.new(0,14) corner.Parent=panel
 local title=text(panel,"",UDim2.fromOffset(20,12),UDim2.new(1,-70,0,34),23)
 button(panel,"×",UDim2.new(1,-45,0,12),UDim2.fromOffset(32,32),function() panel.Visible=false end)
 local rebirth=Instance.new("Frame") rebirth.Name="Rebirth" rebirth.BackgroundTransparency=1 rebirth.Position=UDim2.fromOffset(16,55) rebirth.Size=UDim2.new(1,-32,1,-65) rebirth.Parent=panel
 local description=text(rebirth,"",UDim2.fromOffset(10,5),UDim2.new(1,-20,0,155),17)
 text(rebirth,"Keep your rebirths. Start again with $150, four stands and an empty collection. Finish every delivery and raid first.",UDim2.fromOffset(10,155),UDim2.new(1,-20,0,65),14)
 button(rebirth,"Confirm Rebirth",UDim2.new(0.05,0,1,-70),UDim2.new(0.55,0,0,44),function() remote:FireServer("Rebirth") panel.Visible=false end)
 button(rebirth,"Cancel",UDim2.new(0.65,0,1,-70),UDim2.new(0.3,0,0,44),function() panel.Visible=false end)
 local index=Instance.new("ScrollingFrame") index.Name="CharacterIndex" index.BackgroundTransparency=1 index.Position=UDim2.fromOffset(14,60) index.Size=UDim2.new(1,-28,1,-75) index.CanvasSize=UDim2.fromOffset(0,13*51) index.ScrollBarThickness=5 index.BorderSizePixel=0 index.Parent=panel
 for i,entry in ipairs(Data.Cast) do
  local rarity=Data.Rarities[entry.tier]
  local row=text(index,entry.name.."  ·  "..rarity.name.."\n$"..entry.price.."  /  +$"..entry.rate.."/s",UDim2.fromOffset(5,(i-1)*51),UDim2.new(1,-16,0,48),14)
  row.TextColor3=rarity.color row.TextXAlignment=Enum.TextXAlignment.Left
 end
 local function refresh()
  local price=player:GetAttribute("RebirthPrice") or 12000 local count=player:GetAttribute("Rebirths") or 0
  description.Text="REBIRTH "..(count+1).."\nCost: $"..price.."\nIncome bonus: +"..((count+1)*50).."% total\nCurrent cash: $"..(player:GetAttribute("Cash") or 150)
 end
 player:GetAttributeChangedSignal("RebirthPrice"):Connect(refresh) player:GetAttributeChangedSignal("Cash"):Connect(refresh) player:GetAttributeChangedSignal("Rebirths"):Connect(refresh) refresh()
 local function open(kind)
  panel.Visible=true title.Text=kind=="Rebirth" and "REBIRTH" or "BRAINROT INDEX · 13 CHARACTERS"
  rebirth.Visible=kind=="Rebirth" index.Visible=kind=="Index" refresh()
 end
 button(gui,"REBIRTH",UDim2.new(1,-228,0,12),UDim2.fromOffset(105,36),function() open("Rebirth") end)
 button(gui,"INDEX",UDim2.new(1,-115,0,12),UDim2.fromOffset(103,36),function() open("Index") end)
 return open
end
return Menu
