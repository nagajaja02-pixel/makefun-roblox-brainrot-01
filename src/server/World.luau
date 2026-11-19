local W = {}
W.ink=Color3.fromRGB(19,28,48)
W.steel=Color3.fromRGB(99,150,181)
W.aqua=Color3.fromRGB(78,255,218)
W.gold=Color3.fromRGB(255,199,101)
W.white=Color3.fromRGB(244,248,255)
function W.part(parent,name,size,cf,color,material)
 local p=Instance.new("Part")
 p.Name=name p.Size=size p.CFrame=cf p.Color=color or W.ink
 p.Anchored=true p.Material=material or Enum.Material.SmoothPlastic
 p.TopSurface=Enum.SurfaceType.Smooth p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent
 return p
end
function W.sign(part,text,color)
 local s=Instance.new("SurfaceGui") s.Face=Enum.NormalId.Front s.CanvasSize=Vector2.new(600,160) s.Parent=part
 local l=Instance.new("TextLabel") l.Size=UDim2.fromScale(1,1) l.BackgroundTransparency=1
 l.Text=text l.TextColor3=color or W.white l.Font=Enum.Font.GothamBold l.TextScaled=true l.Parent=s
 return l
end
function W.prompt(part,action,label,callback,hold)
 local p=Instance.new("ProximityPrompt") p.ActionText=action p.ObjectText=label
 p.KeyboardKeyCode=Enum.KeyCode.E p.HoldDuration=hold or 0 p.MaxActivationDistance=10 p.RequiresLineOfSight=false p.Parent=part
 p.Triggered:Connect(callback)
 return p
end
function W.build()
 local old=workspace:FindFirstChild("BlitzHarbor") if old then old:Destroy() end
 local root=Instance.new("Folder") root.Name="BlitzHarbor" root.Parent=workspace W.root=root
 local function box(n,s,x,y,z,col,mat) return W.part(root,n,s,CFrame.new(x,y,z),col,mat) end
 box("Ocean",Vector3.new(1300,1,1300),0,-4,0,Color3.fromRGB(35,172,235))
 box("Island",Vector3.new(268,5,200),0,-2.5,0,Color3.fromRGB(103,188,62),Enum.Material.Grass)
 box("Conveyor",Vector3.new(262,1.8,16),0,0.9,0,W.ink)
 for x=-126,126,6 do box("Belt slat",Vector3.new(0.25,0.08,15),x,1.84,0,W.steel) end
 for _,z in ipairs({-25,25}) do box("Evacuation path",Vector3.new(244,0.1,7),0,0.08,z,Color3.fromRGB(233,218,170)) end
 for _,z in ipairs({-100,100}) do
  box("Perimeter wall",Vector3.new(268,18,3),0,9,z,Color3.fromRGB(139,87,51))
  box("Coping",Vector3.new(271,0.8,4),0,18.4,z,Color3.fromRGB(195,134,83))
  for x=-120,120,24 do box("Pilaster",Vector3.new(4,19,4),x,9.5,z,Color3.fromRGB(195,134,83)) end
 end
 for _,x in ipairs({-134,134}) do
  box("Perimeter wall",Vector3.new(3,18,200),x,9,0,Color3.fromRGB(139,87,51))
  box("Coping",Vector3.new(4,0.8,203),x,18.4,0,Color3.fromRGB(195,134,83))
  for z=-90,90,20 do box("Pilaster",Vector3.new(4,19,4),x,9.5,z,Color3.fromRGB(195,134,83)) end
 end
 for _,x in ipairs({-121,121}) do
  for _,z in ipairs({-10,10}) do box("Machine housing",Vector3.new(20,11,3),x,5.5,z,Color3.fromRGB(25,169,164)) end
  box("Steel roof",Vector3.new(20,2,23),x,12,0,W.steel)
  local name=box("Machine board",Vector3.new(19,3,0.4),x,9,-11.6,W.ink)
  W.sign(name,x<0 and "BLITZ IMPORTS" or "RETURN PROCESSOR")
  for z=-8,8,2 do box("Rubber curtain",Vector3.new(0.3,6,1.6),x<0 and -115 or 115,5,z,W.ink).CanCollide=false end
  for z=-8,8,4 do box("Warning lamp",Vector3.new(1,1,1),x,13.5,z,W.gold,Enum.Material.Neon) end
  for k=-3,3 do box("Vent",Vector3.new(1,2,0.2),x+k*2,5,-11.6,W.ink) end
 end
 for _,x in ipairs({-110,-41,41,110}) do for _,z in ipairs({-31,31}) do
  box("Streetlight",Vector3.new(0.5,12,0.5),x,6,z,W.ink)
  local lamp=box("Lamp",Vector3.new(3,0.5,2),x,12,z,W.gold,Enum.Material.Neon)
  local light=Instance.new("PointLight") light.Range=19 light.Brightness=1 light.Parent=lamp
  box("Banner",Vector3.new(2,4,0.15),x+1.2,9,z,z<0 and Color3.fromRGB(250,115,93) or W.aqua)
 end end
 for _,x in ipairs({-111,-41,41,111}) do for _,z in ipairs({-78,78}) do
  box("Palm trunk",Vector3.new(1.5,11,1.5),x,5.5,z,Color3.fromRGB(139,87,51))
  for i=1,6 do W.part(root,"Palm frond",Vector3.new(2,0.4,9),CFrame.new(x,11,z)*CFrame.Angles(0,i*math.pi/3,0)*CFrame.new(0,0,3),Color3.fromRGB(44,135,70)) end
  box("Shrub",Vector3.new(5,2,4),x,1,z,Color3.fromRGB(44,135,70))
 end end
 for _,x in ipairs({-41,41}) do for _,z in ipairs({-53,53}) do
  box("Crate",Vector3.new(4,4,4),x,2,z,Color3.fromRGB(176,105,56))
  local barrel=box("Barrel",Vector3.new(3,3,3),x+5,1.5,z,W.steel) barrel.Shape=Enum.PartType.Cylinder
  box("Fence",Vector3.new(12,3,0.4),x,1.5,z+5,W.ink)
 end end
 for _,z in ipairs({-30,30}) do
  box("Signpost",Vector3.new(0.4,4.5,0.4),17,2.25,z,W.ink)
  W.sign(box("Wayfinding",Vector3.new(11,2,0.3),17,4.5,z,W.ink),"SAFEHOUSES",W.aqua)
 end
 box("Dock",Vector3.new(145,2,44),-30,-0.5,128,Color3.fromRGB(139,87,51))
 local warehouse=box("Customs warehouse",Vector3.new(45,12,26),-73,6,128,W.steel)
 W.sign(warehouse,"BLITZ CUSTOMS")
 for i=1,4 do box("Shipping container",Vector3.new(22,9,11),25+(i%2)*24,4.5+math.floor((i-1)/2)*9,130,W.aqua) end
 box("Crane tower",Vector3.new(3,43,3),-10,21.5,119,W.gold)
 box("Crane boom",Vector3.new(49,2,3),-10,43,119,W.gold)
 box("Crane cabin",Vector3.new(7,6,6),-10,38,119,W.ink)
 box("Cable",Vector3.new(0.2,26,0.2),10,29,119,W.ink)
 box("Hook",Vector3.new(3,1,1),9,16,119,W.gold)
 local lighting=game:GetService("Lighting")
 lighting.ClockTime=10.5 lighting.Brightness=3.5 lighting.Ambient=Color3.fromRGB(180,172,160) lighting.OutdoorAmbient=Color3.fromRGB(191,194,188)
 local a=Instance.new("Atmosphere") a.Density=0.12 a.Glare=0.12 a.Haze=0.35 a.Parent=lighting
 local clouds=Instance.new("Clouds") clouds.Cover=0.26 clouds.Density=0.72 clouds.Parent=workspace.Terrain
 return root
end
return W
