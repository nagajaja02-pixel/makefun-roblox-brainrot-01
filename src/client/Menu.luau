local D=require(game.ReplicatedStorage.Shared.BrainrotData)
local Menu={}
function Menu.mount(gui,player,action)
 local function text(parent,value,size,pos)
  local l=Instance.new("TextLabel") l.BackgroundTransparency=1 l.Text=value l.Size=size l.Position=pos l.TextColor3=Color3.fromRGB(244,248,255) l.Font=Enum.Font.GothamBold l.TextSize=18 l.TextWrapped=true l.Parent=parent return l
 end
 local function button(parent,value,size,pos,callback)
  local b=Instance.new("TextButton") b.Size=size b.Position=pos b.Text=value b.BackgroundColor3=Color3.fromRGB(27,192,190) b.TextColor3=Color3.fromRGB(19,28,48) b.Font=Enum.Font.GothamBold b.TextSize=16 b.Parent=parent
  local corner=Instance.new("UICorner") corner.Parent=b b.Activated:Connect(callback) return b
 end
 local modal=Instance.new("Frame") modal.AnchorPoint=Vector2.new(0.5,0.5) modal.Position=UDim2.fromScale(0.5,0.5) modal.Size=UDim2.new(0.88,0,0.7,0) modal.BackgroundColor3=Color3.fromRGB(19,28,48) modal.Visible=false modal.Parent=gui
 local limit=Instance.new("UISizeConstraint") limit.MaxSize=Vector2.new(600,580) limit.Parent=modal
 local corner=Instance.new("UICorner") corner.Parent=modal
 local title=text(modal,"",UDim2.new(1,-70,0,48),UDim2.fromOffset(10,4))
 local body=Instance.new("Frame") body.BackgroundTransparency=1 body.Size=UDim2.new(1,-24,1,-65) body.Position=UDim2.fromOffset(12,58) body.Parent=modal
 button(modal,"X",UDim2.fromOffset(40,36),UDim2.new(1,-48,0,8),function() modal.Visible=false end)
 local mode=""
 local function reset(name)
  body:ClearAllChildren() mode=name title.Text=name modal.Visible=true
 end
 local function rebirth()
  reset("Rebirth")
  local desc=text(body,"",UDim2.new(1,0,0.6,0),UDim2.fromScale(0,0))
  local function refresh()
   desc.Text="Rebirth for $"..tostring(player:GetAttribute("RebirthPrice") or 12000).."?\n\nGain +50% income per rebirth. Cash resets to $150; your collection and stand upgrades reset.\n\nCurrent rebirths: "..tostring(player:GetAttribute("Rebirths") or 0)
  end
  refresh()
  button(body,"Confirm",UDim2.fromScale(0.45,0.15),UDim2.fromScale(0.02,0.78),function() action:FireServer("Rebirth") modal.Visible=false end)
  button(body,"Cancel",UDim2.fromScale(0.45,0.15),UDim2.fromScale(0.53,0.78),function() modal.Visible=false end)
 end
 player:GetAttributeChangedSignal("RebirthPrice"):Connect(function() if mode=="Rebirth" and modal.Visible then rebirth() end end)
 local function index()
  reset("Brainrot Index · 13 characters")
  local scroll=Instance.new("ScrollingFrame") scroll.Size=UDim2.fromScale(1,1) scroll.BackgroundTransparency=1 scroll.ScrollBarThickness=5 scroll.CanvasSize=UDim2.fromOffset(0,13*48) scroll.Parent=body
  for i,c in ipairs(D.cast) do
   local l=text(scroll,c[1].." · "..D.rarities[c[2]].name.."\n$"..c[3].." · +$"..c[4].."/s",UDim2.new(1,-12,0,46),UDim2.fromOffset(0,(i-1)*48))
   l.TextSize=14 l.TextColor3=D.rarities[c[2]].color
  end
 end
 button(gui,"REBIRTH",UDim2.fromOffset(112,38),UDim2.new(1,-126,0,16),rebirth)
 button(gui,"INDEX",UDim2.fromOffset(112,38),UDim2.new(1,-126,0,62),index)
end
return Menu
