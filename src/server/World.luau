local World = {}
World.Colors = {ink=Color3.fromRGB(19,28,48),steel=Color3.fromRGB(99,150,181),aqua=Color3.fromRGB(78,255,218),gold=Color3.fromRGB(255,199,101),white=Color3.fromRGB(244,248,255)}
function World.part(parent,name,size,cf,color,material,collide)
 local p = Instance.new("Part")
 p.Name=name p.Size=size p.CFrame=cf p.Color=color
 p.Material=material or Enum.Material.SmoothPlastic
 p.Anchored=true p.CanCollide=collide ~= false p.TopSurface=Enum.SurfaceType.Smooth p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent
 return p
end
function World.sign(parent,adornee,text,color,size)
 local gui=Instance.new("SurfaceGui") gui.Name="Sign" gui.Face=Enum.NormalId.Front gui.CanvasSize=Vector2.new(600,180) gui.Parent=adornee
 local label=Instance.new("TextLabel") label.Size=UDim2.fromScale(1,1) label.BackgroundTransparency=1 label.Font=Enum.Font.GothamBold
 label.Text=text label.TextColor3=color or World.Colors.white label.TextSize=size or 40 label.TextWrapped=true label.Parent=gui
 return label
end
function World.prompt(part,action,object,hold,callback)
 local p=Instance.new("ProximityPrompt") p.ActionText=action p.ObjectText=object p.HoldDuration=hold or 0
 p.MaxActivationDistance=10 p.RequiresLineOfSight=false p.KeyboardKeyCode=Enum.KeyCode.E p.Parent=part
 p.Triggered:Connect(callback)
 return p
end
function World.build()
 local old=workspace:FindFirstChild("BlitzHarbor") if old then old:Destroy() end
 local root=Instance.new("Folder") root.Name="BlitzHarbor" root.Parent=workspace World.root=root
 local C=World.Colors
 local function block(n,s,x,y,z,c,m) return World.part(root,n,s,CFrame.new(x,y,z),c,m) end
 block("Ocean",Vector3.new(1300,2,1300),0,-4,0,Color3.fromRGB(35,172,235))
 block("Island",Vector3.new(268,4,200),0,-2,0,Color3.fromRGB(103,188,62),Enum.Material.Grass)
 block("Conveyor",Vector3.new(262,1.8,16),0,0.9,0,C.ink)
 for _,z in ipairs({-8.5,8.5}) do block("BeltRail",Vector3.new(262,0.35,0.4),0,1.9,z,C.steel) end
 for x=-126,126,7 do block("BeltStripe",Vector3.new(0.35,0.03,15),x,1.815,0,C.steel) end
 for _,z in ipairs({-25,25}) do
  block("EvacuationLane",Vector3.new(260,0.08,7),0,0.04,z,Color3.fromRGB(231,218,171))
  for x=-120,120,12 do block("LaneMark",Vector3.new(4,0.02,0.2),x,0.09,z,C.white) end
 end
 for _,z in ipairs({-100,100}) do
  block("PerimeterWall",Vector3.new(268,18,3),0,9,z,Color3.fromRGB(139,87,51))
  block("WallCoping",Vector3.new(270,0.7,3.8),0,18.35,z,Color3.fromRGB(195,134,83))
  for x=-132,132,24 do block("WallPilaster",Vector3.new(2,18.5,4),x,9.25,z,Color3.fromRGB(195,134,83)) end
 end
 for _,x in ipairs({-134,134}) do
  block("PerimeterWall",Vector3.new(3,18,200),x,9,0,Color3.fromRGB(139,87,51))
  block("WallCoping",Vector3.new(3.8,0.7,202),x,18.35,0,Color3.fromRGB(195,134,83))
  for z=-100,100,20 do block("WallPilaster",Vector3.new(4,18.5,2),x,9.25,z,Color3.fromRGB(195,134,83)) end
 end
 for _,x in ipairs({-121,121}) do
  local face=x<0 and 1 or -1
  for _,z in ipairs({-10,10}) do block("MachineHousing",Vector3.new(20,10,3),x,5,z,Color3.fromRGB(25,169,164)) end
  block("MachineRoof",Vector3.new(20,2,23),x,11,0,C.steel)
  for _,z in ipairs({-8,8}) do block("WarningLamp",Vector3.new(2,1,2),x,12.5,z,C.gold,Enum.Material.Neon) end
  for z=-6,6,2 do block("RubberCurtain",Vector3.new(0.4,7,1.8),x+face*6,5.3,z,C.ink).Transparency=0.35 end
  for dx=-6,6,3 do block("Vent",Vector3.new(1,4,0.2),x+dx,6,-11.6,C.ink) end
  local plate=block("MachineSign",Vector3.new(17,2.5,0.3),x,9,-11.7,C.ink)
  World.sign(root,plate,x<0 and "BLITZ IMPORTS" or "RETURN PROCESSOR",C.aqua,32)
 end
 for _,x in ipairs({-110,-41,41,110}) do
  for _,z in ipairs({-31,31}) do
   block("StreetLamp",Vector3.new(0.5,12,0.5),x,6,z,C.ink)
   local bulb=block("LampLight",Vector3.new(2.5,0.6,2.5),x,12,z,C.gold,Enum.Material.Neon)
   local light=Instance.new("PointLight") light.Brightness=0.7 light.Range=20 light.Parent=bulb
   block("HarborBanner",Vector3.new(2.4,4,0.2),x+1.4,8,z,z<0 and Color3.fromRGB(250,115,93) or Color3.fromRGB(27,192,190))
  end
 end
 for _,x in ipairs({-111,-41,41,111}) do
  for _,z in ipairs({-78,78}) do
   block("PalmTrunk",Vector3.new(1.2,13,1.2),x,6.5,z,Color3.fromRGB(139,87,51))
   for a=0,5 do
    World.part(root,"PalmLeaf",Vector3.new(1.7,0.4,8),CFrame.new(x,13,z)*CFrame.Angles(0,a*math.pi/3,0)*CFrame.new(0,-0.8,3),Color3.fromRGB(52,139,66))
   end
   local shrub=block("PalmShrub",Vector3.new(4,2,4),x,1,z,Color3.fromRGB(70,155,65)) shrub.Shape=Enum.PartType.Ball
  end
 end
 for _,x in ipairs({-41,41}) do
  for _,z in ipairs({-53,53}) do
   block("CargoCrate",Vector3.new(4,4,4),x,2,z,Color3.fromRGB(176,105,56))
   local barrel=block("Barrel",Vector3.new(3,2,2),x+4,1.5,z,C.steel) barrel.Shape=Enum.PartType.Cylinder barrel.Orientation=Vector3.new(0,0,90)
   block("CargoFence",Vector3.new(12,2,0.3),x,1,z+4,C.ink)
  end
 end
 for _,z in ipairs({-30,30}) do
  block("WayfinderPost",Vector3.new(0.4,4.5,0.4),17,2.25,z,C.ink)
  local sign=block("Wayfinder",Vector3.new(10,2,0.25),17,4.5,z,C.ink) World.sign(root,sign,"SAFEHOUSES",C.aqua,30)
 end
 block("BackdropDock",Vector3.new(120,2,26),-44,0,128,Color3.fromRGB(139,87,51))
 local warehouse=block("CustomsWarehouse",Vector3.new(38,12,22),-73,6,128,C.steel)
 block("WarehouseRoof",Vector3.new(42,1,26),-73,12.5,128,C.ink)
 local customs=block("CustomsSign",Vector3.new(32,4,0.3),-73,8,116.8,C.ink) World.sign(root,customs,"BLITZ CUSTOMS",C.white)
 for i=1,4 do block("Container",Vector3.new(17,7,10),-39+((i-1)%2)*19,3.5+math.floor((i-1)/2)*7,132,i%2==0 and C.steel or Color3.fromRGB(25,169,164)) end
 block("CraneTower",Vector3.new(3,32,3),-10,16,119,C.gold)
 block("CraneArm",Vector3.new(39,2,2),-1,32,119,C.gold)
 block("CraneCabin",Vector3.new(6,5,5),-10,27,119,C.ink)
 block("CraneCable",Vector3.new(0.2,19,0.2),17,22,119,C.ink)
 block("CraneHook",Vector3.new(2,0.5,1),16.2,12.5,119,C.gold)
 local spawn=Instance.new("SpawnLocation") spawn.Name="HarborSpawn" spawn.Size=Vector3.new(8,0.2,6) spawn.CFrame=CFrame.new(0,0.5,-20) spawn.Anchored=true spawn.Neutral=true spawn.Transparency=1 spawn.Parent=root
 local lighting=game:GetService("Lighting") lighting.ClockTime=10.5 lighting.Brightness=3.5 lighting.Ambient=Color3.fromRGB(180,172,160) lighting.OutdoorAmbient=Color3.fromRGB(191,194,188)
 local atmosphere=lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere",lighting) atmosphere.Density=0.12 atmosphere.Glare=0.12 atmosphere.Haze=0.35
 local clouds=workspace.Terrain:FindFirstChildOfClass("Clouds") or Instance.new("Clouds",workspace.Terrain) clouds.Cover=0.26 clouds.Density=0.72
 return root
end
return World
