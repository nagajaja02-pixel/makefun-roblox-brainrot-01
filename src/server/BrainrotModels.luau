local Data=require(game:GetService("ReplicatedStorage").Shared.BrainrotData)
local World=require(script.Parent.World)
local Models={}
local C=World.Colors
local brown=Color3.fromRGB(111,67,43)
local pink=Color3.fromRGB(245,151,174)
local green=Color3.fromRGB(65,148,77)
function Models.create(offer,parent)
 local model=Instance.new("Model") model.Name=offer.data.name model.Parent=parent
 local root=World.part(model,"Root",Vector3.new(0.3,0.3,0.3),CFrame.new(),C.ink,nil,false) root.Transparency=1 model.PrimaryPart=root
 local bodyColor=offer.data.color
 if offer.mutation=="Gold" then bodyColor=C.gold elseif offer.mutation=="Diamond" then bodyColor=Color3.fromRGB(122,225,255) end
 local function p(name,size,x,y,z,color,shape,angle)
  local part=World.part(model,name,size,CFrame.new(x,y,z)*(angle or CFrame.new()),color or bodyColor,nil,false)
  if shape then part.Shape=shape end
  return part
 end
 local function ball(name,size,x,y,z,color) return p(name,size,x,y,z,color,Enum.PartType.Ball) end
 local function limb(name,x,y,z,sx,sy,sz,color) return p(name,Vector3.new(sx,sy,sz),x,y,z,color) end
 local faceY,faceZ=3.3,-0.8
 local key=offer.data.key
 if key=="sahur" then
  limb("TimberBody",0,2.4,0,1.8,3.8,1.3)
  for x=-0.7,0.7,0.35 do limb("WoodGrain",x,2.5,-0.67,0.04,3.2,0.025,brown) end
  for _,x in ipairs({-1,1}) do limb("Arm",x*1.3,2.2,0,0.5,2,0.5) limb("Leg",x*0.5,0.5,0,0.45,1,0.5) limb("Foot",x*0.5,0.16,-0.3,0.65,0.3,1) end
  limb("DrumMallet",1.5,2,-0.8,0.25,2.8,0.25,brown) ball("MalletHead",Vector3.new(0.9,0.7,0.7),1.5,3.4,-0.8,C.gold)
  faceY=3.3 faceZ=-0.69
 elseif key=="boneca" then
  p("Tire",Vector3.new(0.9,2,2),0,1,0,C.ink,Enum.PartType.Cylinder)
  p("SilverRim",Vector3.new(0.95,1.2,1.2),0,1,0,C.white,Enum.PartType.Cylinder)
  ball("FrogHead",Vector3.new(2.7,1.7,1.7),0,3.3,0)
  for _,x in ipairs({-1,1}) do ball("EyeBump",Vector3.new(0.9,1,0.8),x*0.85,4,0) limb("LongLeg",x,1.8,0,0.35,2.4,0.35) limb("WebFoot",x,0.3,-0.5,0.9,0.3,1.3) end
  faceY=3.8 faceZ=-0.78
 elseif key=="trippi" then
  for i=0,4 do ball("ShrimpSegment",Vector3.new(1.9-i*0.22,1.6-i*0.18,1.25),0,1.6-i*0.13,i*0.7,offer.mutation=="" and Color3.fromRGB(243,139+i*10,99+i*20) or bodyColor) end
  ball("CatHead",Vector3.new(2.4,2.1,1.6),0,2.8,-0.5,C.white)
  for _,x in ipairs({-1,1}) do
   local ear=Instance.new("WedgePart") ear.Name="PointedEar" ear.Size=Vector3.new(0.65,1,0.65) ear.CFrame=CFrame.new(x*0.8,4,-0.4) ear.Color=pink ear.Anchored=true ear.CanCollide=false ear.Parent=model
   limb("TailFan",x*0.5,1,3.1,1.3,0.25,1,pink)
   for j=0,2 do limb("Whisker",x*1.25,2.5+j*0.18,-1.34,1,0.04,0.04,C.ink) end
  end
  faceY=3 faceZ=-1.32
 elseif key=="lirili" then
  ball("CactusBody",Vector3.new(2.2,3,1.7),0,2,0)
  for x=-0.8,0.8,0.4 do limb("CactusRib",x,2,-0.8,0.07,2.5,0.08,green) end
  ball("ElephantHead",Vector3.new(2.3,1.8,1.7),0,3.6,-0.1,C.steel)
  limb("Trunk",0,2.7,-1.25,0.5,1.7,0.5,C.steel)
  for _,x in ipairs({-1,1}) do ball("ElephantEar",Vector3.new(1,1.5,0.35),x*1.3,3.6,0,C.steel) limb("Leg",x*0.6,0.55,0,0.5,1,0.5) limb("Sandal",x*0.6,0.15,-0.25,0.9,0.3,1.3,brown) end
  faceY=3.8 faceZ=-0.98
 elseif key=="frigo" then
  limb("Refrigerator",0,2,0,2.2,2.8,1.7)
  limb("WhiteDoor",0,2,-0.88,2,2.6,0.12,C.white) limb("DoorHandle",0.65,2.1,-1,0.12,1,0.15,C.ink)
  limb("CamelNeck",0,3.7,0,0.8,1.6,0.8,C.gold) ball("CamelHead",Vector3.new(1.6,1.2,1.4),0,4.5,-0.2,C.gold)
  ball("Muzzle",Vector3.new(1.1,0.6,0.7),0,4.1,-1,brown)
  for _,x in ipairs({-1,1}) do limb("Ear",x*0.8,4.9,0,0.4,0.7,0.4,C.gold) limb("Boot",x*0.65,0.35,-0.1,0.8,0.7,1.1,brown) end
  faceY=4.6 faceZ=-0.93
 elseif key=="banana" then
  ball("BananaBody",Vector3.new(1.7,3,1.5),0,2,0)
  ball("MonkeyHead",Vector3.new(2,1.7,1.7),0,3.6,0,brown) ball("MonkeyMuzzle",Vector3.new(1.5,0.8,0.4),0,3.2,-0.8,C.gold)
  for _,x in ipairs({-1,1}) do ball("MonkeyEar",Vector3.new(0.8,0.8,0.4),x*1.1,3.6,0,brown) limb("Peel",x*1.1,2,0,0.6,2.5,0.6) limb("Leg",x*0.5,0.45,0,0.5,0.9,0.6,brown) end
  limb("BananaStem",0,4.6,0,0.35,0.6,0.35,green) faceY=3.7 faceZ=-0.89
 elseif key=="patapim" then
  limb("TreeTrunk",0,1.8,0,1.8,3.1,1.5,brown)
  ball("MossCanopy",Vector3.new(3.4,2.5,2.1),0,3.4,0)
  limb("LongNose",0,3,-1.5,0.55,0.5,1.7,C.gold)
  for _,x in ipairs({-1,1}) do limb("BranchArm",x*1.5,2.4,0,1.8,0.5,0.5,brown) ball("MossClump",Vector3.new(1.3,1.1,1.2),x*1.4,3,0) limb("RootFoot",x*0.7,0.3,-0.3,1.2,0.6,1.8,brown) end
  faceY=3.6 faceZ=-1.03
 elseif key=="ballerina" or key=="assassino" then
  local dancer=key=="ballerina"
  limb("Bodice",0,1.9,0,1.2,1.5,0.9,dancer and pink or C.ink)
  local cupColor=dancer and C.white or bodyColor
  p("Cup",Vector3.new(1.6,2.1,2.1),0,3.4,0,cupColor,Enum.PartType.Cylinder,CFrame.Angles(0,0,math.pi/2))
  p("CupLip",Vector3.new(0.15,2.3,2.3),0,4.2,0,cupColor,Enum.PartType.Cylinder,CFrame.Angles(0,0,math.pi/2))
  p("Coffee",Vector3.new(0.06,1.9,1.9),0,4.3,0,brown,Enum.PartType.Cylinder,CFrame.Angles(0,0,math.pi/2))
  ball("Foam",Vector3.new(1.1,0.15,0.8),0,4.35,0,C.white)
  for _,x in ipairs({-1,1}) do limb("Arm",x*1.05,2.1,0,1.1,0.3,0.3,dancer and C.white or C.ink) limb("Leg",x*0.4,0.6,0,0.3,1.2,0.3,C.white) limb("Shoe",x*0.4,0.12,-0.2,0.55,0.25,0.8,dancer and pink or C.ink) end
  if dancer then
   p("Tutu",Vector3.new(0.4,2.8,2.8),0,1.4,0,pink,Enum.PartType.Cylinder,CFrame.Angles(0,0,math.pi/2))
   for _,x in ipairs({-0.4,0.4}) do limb("Ribbon",x,0.65,-0.17,0.4,0.1,0.1,pink) end
  else
   limb("Headband",0,3.8,-1.05,2.2,0.25,0.15,pink) limb("BandTail",1.4,3.8,0,1.3,0.2,0.3,pink)
   limb("FoamSword",1.6,2.2,-0.4,0.2,2.5,0.35,C.steel) limb("SwordHilt",1.6,1,-0.4,0.8,0.15,0.4,C.gold)
  end
  faceY=3.4 faceZ=-1.08
 elseif key=="ananasini" then
  ball("Pineapple",Vector3.new(2.5,2.8,2),0,1.8,0)
  for y=0.8,2.8,0.5 do for x=-0.8,0.8,0.4 do limb("PineappleScale",x,y,-0.95,0.23,0.23,0.1,C.gold) end end
  ball("OrangutanHead",Vector3.new(2,1.6,1.7),0,3.6,0,brown) ball("FacePatch",Vector3.new(1.6,1.1,0.3),0,3.5,-0.8,C.gold)
  for _,x in ipairs({-1,1}) do limb("LongArm",x*1.7,1.8,0,0.7,2.9,0.7,brown) ball("Knuckle",Vector3.new(1,0.6,1),x*1.7,0.5,-0.2,brown) limb("Foot",x*0.6,0.2,-0.2,0.8,0.4,1,brown) end
  for i=-2,2 do p("LeafCrown",Vector3.new(0.35,1.7,0.5),i*0.35,4.7,0,green,nil,CFrame.Angles(0,0,-i*0.23)) end
  faceY=3.6 faceZ=-0.99
 elseif key=="tralalero" then
  ball("SharkBody",Vector3.new(2.4,1.9,3.5),0,2,0)
  ball("WhiteBelly",Vector3.new(1.8,1.1,2.7),0,1.55,-0.2,C.white) ball("Snout",Vector3.new(2,1.2,1.8),0,2.2,-1.5)
  limb("DorsalFin",0,3.3,0,0.3,1.5,1.1) limb("TailFin",0,2.2,2,1.9,0.4,1.2)
  for _,x in ipairs({-1,1}) do limb("SideFin",x*1.4,1.8,0,1.6,0.25,1.1) end
  for i=1,3 do local x=(i-2)*0.85 local z=i==2 and 0.8 or -0.7 limb("Leg",x,0.8,z,0.4,1,0.4) limb("Sneaker",x,0.3,z-0.2,0.75,0.6,1.2,Color3.fromRGB(45,110,239)) for j=1,3 do limb("ShoeLace",x,0.62,z-0.55+j*0.2,0.5,0.04,0.06,C.white) end end
  faceY=2.5 faceZ=-2.35
 elseif key=="bombardiro" then
  ball("Aircraft",Vector3.new(2,1.5,4.5),0,2,0,C.steel) limb("Tail",0,2.9,2,0.3,1.7,1.3,C.steel)
  ball("CrocodileHead",Vector3.new(2,1.5,1.8),0,2.5,-1.7)
  limb("LongSnout",0,2.3,-3,1.5,0.7,2.1) limb("LowerJaw",0,1.85,-3,1.5,0.25,2.1,C.gold)
  for _,x in ipairs({-1,1}) do
   limb("Wing",x*2,1.9,0,3.3,0.25,1.6,C.steel)
   ball("Engine",Vector3.new(0.9,0.9,1.8),x*2.2,1.7,-0.6,C.ink)
   limb("Propeller",x*2.2,1.7,-1.6,2,0.15,0.15,C.white)
   for z=-3.8,-2.2,0.4 do limb("Tooth",x*0.6,2,-0+z,0.12,0.25,0.12,C.white) end
  end
  faceY=2.9 faceZ=-2.56
 elseif key=="saturnita" then
  ball("PlanetBody",Vector3.new(3.3,2.8,3.3),0,1.8,0)
  for i=0,19 do local a=i*math.pi/10 p("SaturnRing",Vector3.new(0.9,0.17,0.6),math.cos(a)*2.3,1.9+math.sin(a)*0.45,math.sin(a)*2.3,C.gold,nil,CFrame.Angles(0,-a,0)) end
  ball("CowHead",Vector3.new(2.1,1.8,1.7),0,3.5,-0.5,C.white) ball("PinkMuzzle",Vector3.new(1.6,0.75,0.5),0,3.1,-1.35,pink)
  ball("CowPatch",Vector3.new(0.6,0.7,0.2),0.6,3.7,-1.31,C.ink)
  for _,x in ipairs({-1,1}) do limb("Ear",x*1.2,3.6,-0.3,0.8,0.3,0.5,C.white) limb("Horn",x*0.65,4.5,-0.4,0.25,0.8,0.25,C.gold) limb("Hoof",x*0.9,0.2,0,0.8,0.4,0.8,C.ink) end
  faceY=3.6 faceZ=-1.39
 end
 for _,side in ipairs({-1,1}) do
  ball("EyeWhite",Vector3.new(0.43,0.48,0.14),side*0.47,faceY,faceZ,C.white)
  ball("Pupil",Vector3.new(0.21,0.29,0.09),side*0.47,faceY-0.01,faceZ-0.09,C.ink)
  ball("EyeHighlight",Vector3.new(0.08,0.1,0.04),side*0.47-0.04,faceY+0.07,faceZ-0.15,C.white)
  p("Eyebrow",Vector3.new(0.5,0.08,0.09),side*0.47,faceY+0.34,faceZ,C.ink,nil,CFrame.Angles(0,0,side*0.15))
 end
 limb("Smile",0,faceY-0.43,faceZ-0.03,0.5,0.09,0.1,C.ink)
 if offer.mutation~="" then
  local sparkle=Instance.new("Sparkles") sparkle.SparkleColor=bodyColor sparkle.Parent=root
  if offer.mutation=="Diamond" then
   for i=-1,1 do local crystal=p("DiamondCrystal",Vector3.new(0.3,0.8,0.3),i*0.7,4.8,0,bodyColor,nil,CFrame.Angles(0,0,i*0.4)) crystal.Material=Enum.Material.Neon end
  end
 end
 local gui=Instance.new("BillboardGui") gui.Name="BrainrotLabel" gui.Size=UDim2.fromOffset(186,79) gui.StudsOffset=Vector3.new(0,4.25,0) gui.MaxDistance=38 gui.AlwaysOnTop=true gui.Adornee=root gui.Parent=root
 local rarity=Data.Rarities[offer.data.tier]
 local rows={{offer.mutation,bodyColor,11},{offer.data.name,C.white,13},{rarity.name,rarity.color,11},{"+$"..offer.rate.."/s",C.aqua,13},{offer.data.caption,C.white,10}}
 for i,row in ipairs(rows) do
  local label=Instance.new("TextLabel") label.BackgroundTransparency=1 label.Position=UDim2.fromOffset(0,(i-1)*15) label.Size=UDim2.new(1,0,0,16) label.Font=Enum.Font.GothamBold label.Text=row[1] label.TextColor3=row[2] label.TextSize=row[3] label.TextStrokeTransparency=0.25 label.TextStrokeColor3=C.ink label.Parent=gui
 end
 return model
end
function Models.anchor(model,anchored)
 for _,part in ipairs(model:GetDescendants()) do
  if part:IsA("BasePart") then part.Anchored=anchored part.CanCollide=false part.Massless=true end
 end
end
function Models.rig(model)
 for _,part in ipairs(model:GetDescendants()) do
  if part:IsA("BasePart") and part~=model.PrimaryPart then
   local weld=Instance.new("WeldConstraint") weld.Part0=model.PrimaryPart weld.Part1=part weld.Parent=model.PrimaryPart
  end
 end
end
return Models
