local D=require(game.ReplicatedStorage.Shared.BrainrotData)
local W=require(script.Parent.World)
local M={}
function M.create(item,parent)
 local data=D.cast[item.id]
 local model=Instance.new("Model") model.Name=data[1]
 local root=W.part(model,"Root",Vector3.new(0.3,0.3,0.3),CFrame.new(),W.ink)
 root.Transparency=1 root.CanCollide=false model.PrimaryPart=root
 local bodyColor=item.mutation=="Gold" and W.gold or (item.mutation=="Diamond" and Color3.fromRGB(122,225,255) or data[6])
 local brown=Color3.fromRGB(115,69,42)
 local function p(n,x,y,z,sx,sy,sz,col,shape,angle)
  local part=W.part(model,n,Vector3.new(sx,sy,sz),CFrame.new(x,y,z)*(angle or CFrame.identity),col or bodyColor)
  if shape then part.Shape=shape end
  part.CanCollide=false part.Massless=true
  return part
 end
 local ball=Enum.PartType.Ball
 local function feet(col)
  for _,x in ipairs({-0.65,0.65}) do p("Leg",x,0.8,0,0.35,1.2,0.4,col) p("Foot",x,0.2,-0.3,0.7,0.4,1,col) end
 end
 local faceY,faceZ=3,-0.85
 local key=data[5]
 if key=="sahur" then
  p("Wood body",0,2.1,0,1.8,3,1.3) feet(brown)
  for x=-0.7,0.7,0.35 do p("Wood grain",x,2.1,-0.67,0.04,2.7,0.04,brown) end
  p("Arm",-1.2,2,0,0.4,1.8,0.4,brown) p("Arm",1.2,2,0,0.4,1.8,0.4,brown)
  p("Drum beater",1.5,2.2,-0.6,0.2,2.2,0.2,brown) p("Beater head",1.5,3.3,-0.6,0.6,0.6,0.6,W.gold,ball)
 elseif key=="boneca" then
  p("Tire",0,0.9,0,1.7,1.7,0.7,W.ink,Enum.PartType.Cylinder,CFrame.Angles(0,0,math.pi/2))
  p("Silver rim",0,0.9,-0.4,1,1,0.15,W.steel,ball)
  p("Frog head",0,3,0,2.4,1.3,1.6,nil,ball)
  for _,x in ipairs({-0.75,0.75}) do p("Eye bump",x,3.7,-0.2,0.8,0.8,0.8,nil,ball) p("Long leg",x,1.7,0.3,0.3,2.3,0.3) p("Web foot",x,0.2,-0.1,0.8,0.3,0.9) end
  faceY=3.6 faceZ=-0.8
 elseif key=="trippi" then
  for i=0,4 do p("Shrimp segment",0,1+i*0.28,i*0.46,1.8-i*0.24,1.3-i*0.13,0.7,Color3.fromRGB(243,139+i*14,99+i*20),ball) end
  p("Cat head",0,2.7,-0.35,2,1.7,1.5,W.white,ball)
  for _,x in ipairs({-0.7,0.7}) do p("Pointed ear",x,3.65,-0.3,0.45,0.8,0.5,W.white,nil,CFrame.Angles(0,0,x*0.4)) for i=1,3 do p("Whisker",x*1.5,2.5+i*0.12,-1.12,0.8,0.04,0.04,W.ink) end end
  for i=-1,1 do p("Tail fan",i*0.5,1.7,2.4,0.6,0.25,1,bodyColor,nil,CFrame.Angles(0,i*0.5,0)) end
  faceZ=-1.1
 elseif key=="lirili" then
  p("Cactus",0,1.8,0,1.6,2.5,1.3,nil,ball) feet(brown)
  for x=-0.6,0.6,0.3 do p("Cactus rib",x,1.9,-0.65,0.06,2,0.08,W.aqua) end
  p("Elephant head",0,3.4,0,1.9,1.5,1.5,W.steel,ball)
  for _,x in ipairs({-1.2,1.2}) do p("Elephant ear",x,3.3,0,0.8,1.5,0.4,W.steel,ball) end
  p("Trunk",0,2.7,-1,0.45,1.7,0.5,W.steel)
  faceY=3.6
 elseif key=="frigo" then
  p("Refrigerator",0,1.7,0,2,2.5,1.5) p("White door",0,1.7,-0.8,1.8,2.2,0.15,W.white) p("Handle",0.65,1.8,-0.95,0.12,0.8,0.15,W.ink)
  p("Camel neck",0,3.2,0.2,0.7,1.5,0.7,W.gold) p("Camel head",0,4,0,1.4,1,1.3,W.gold,ball) p("Muzzle",0,3.8,-0.8,1,0.6,0.8,brown,ball)
  for _,x in ipairs({-0.6,0.6}) do p("Ear",x,4.6,0,0.3,0.6,0.4,W.gold) end feet(W.ink) faceY=4.1 faceZ=-0.65
 elseif key=="banana" then
  p("Banana",0,1.9,0,1.6,2.5,1.3,nil,ball) feet(brown)
  p("Monkey head",0,3.1,-0.15,1.8,1.5,1.4,brown,ball) p("Muzzle",0,2.9,-0.9,1.1,0.7,0.4,W.gold,ball)
  for _,x in ipairs({-1,1}) do p("Ear",x,3.2,0,0.6,0.7,0.4,brown,ball) p("Banana peel",x,1.8,0,0.5,2,0.6,nil,nil,CFrame.Angles(0,0,-x*0.4)) end
  p("Stem",0,4,0,0.4,0.6,0.4,brown) faceY=3.35
 elseif key=="patapim" then
  p("Tree trunk",0,1.9,0,1.5,2.9,1.3,brown)
  p("Moss canopy",0,3.4,0,3,1.6,2.2,nil,ball)
  p("Long nose",0,2.8,-1.1,0.5,0.5,1.7,W.gold)
  for _,x in ipairs({-1,1}) do p("Branch arm",x*1.2,2,0,1.6,0.4,0.4,brown) p("Moss tuft",x,3.9,0,1.1,0.9,1.1,nil,ball) p("Root foot",x*0.7,0.3,-0.3,1.1,0.6,1.5,brown) end
  faceY=3.1 faceZ=-1.05
 elseif key=="ballerina" or key=="assassino" then
  local ninja=key=="assassino"
  local cup=ninja and Color3.fromRGB(51,45,67) or W.white
  p("Cup",0,3.3,0,1.8,1.5,1.7,cup,Enum.PartType.Cylinder,CFrame.Angles(0,0,math.pi/2))
  p("Cup lip",0,4.05,0,2,0.16,1.9,cup)
  p("Coffee",0,4.15,0,1.55,0.08,1.5,brown)
  p("Foam",0.2,4.2,0,0.8,0.08,0.7,W.white,ball)
  p("Bodice",0,1.9,0,1.2,1.4,0.9,ninja and W.ink or bodyColor)
  if ninja then
   p("Headband",0,3.7,-0.9,2,0.25,0.12,Color3.fromRGB(243,129,168))
   p("Ribbon tail",1.1,3.5,0.3,0.3,1.5,0.15,Color3.fromRGB(243,129,168))
   p("Foam sword",1.6,2.2,-0.5,0.2,2.3,0.3,W.steel) p("Sword hilt",1.6,0.95,-0.5,0.7,0.2,0.3,W.gold)
  else p("Tutu",0,1.4,0,2.7,0.4,2,bodyColor,ball) end
  for _,x in ipairs({-1,1}) do p("Arm",x,2,0,0.3,1.6,0.3,cup,nil,CFrame.Angles(0,0,x*0.7)) end feet(ninja and W.ink or bodyColor) faceY=3.35
 elseif key=="ananasini" then
  p("Pineapple",0,1.9,0,2,2.5,1.5,nil,ball)
  for x=-0.7,0.7,0.35 do for y=1,2.6,0.4 do p("Scale",x,y,-0.75,0.22,0.22,0.1,W.gold) end end
  p("Orangutan head",0,3.4,0,1.8,1.5,1.4,brown,ball) p("Face patch",0,3.3,-0.7,1.4,1.1,0.2,W.gold,ball)
  for i=-2,2 do p("Crown leaf",i*0.25,4.4,0,0.3,1.1,0.4,Color3.fromRGB(70,145,61),nil,CFrame.Angles(0,0,-i*0.25)) end
  for _,x in ipairs({-1.3,1.3}) do p("Long arm",x,1.8,0,0.65,2.5,0.7,brown) p("Knuckles",x,0.6,-0.2,0.8,0.5,0.9,brown) end feet(brown) faceY=3.55
 elseif key=="tralalero" then
  p("Shark",0,2,0,2,1.6,3.3,nil,ball) p("White belly",0,1.5,-0.5,1.5,0.8,2,W.white,ball) p("Snout",0,2,-1.5,1.8,0.9,1.2,nil,ball)
  p("Dorsal fin",0,3,0.4,0.25,1.5,1.2) p("Tail",0,2,2,1.8,1.4,0.3)
  for _,x in ipairs({-1.3,1.3}) do p("Side fin",x,1.9,0,1,0.25,1.3) end
  for i=-1,1 do p("Third leg",i*0.9,0.8,i==0 and 0.8 or 0,0.3,0.8,0.4) p("Sneaker",i*0.9,0.3,i==0 and 0.5 or -0.4,0.8,0.6,1.4) p("Laces",i*0.9,0.65,i==0 and 0.3 or -0.6,0.6,0.08,0.5,W.white) end
  faceY=2.3 faceZ=-2
 elseif key=="bombardiro" then
  p("Airframe",0,1.9,0,1.7,1.5,4,W.steel,ball) p("Tail",0,2.7,1.8,0.3,1.6,1.2,W.steel)
  p("Crocodile head",0,2.4,-1.5,1.6,1,2,nil,ball) p("Long snout",0,2.2,-2.6,1.4,0.6,1.9) p("Lower jaw",0,1.8,-2.6,1.4,0.25,1.9,W.gold)
  for _,x in ipairs({-0.55,0.55}) do for z=-3.3,-2,0.3 do p("Tooth",x,2,-z*-1,0.15,0.25,0.15,W.white) end end
  p("Wings",0,1.8,0,6,0.25,1.5,W.steel)
  for _,x in ipairs({-2,2}) do p("Engine",x,1.6,-0.4,0.8,0.8,1.7,W.ink,ball) p("Propeller",x,1.6,-1.3,0.16,2,0.15,W.gold) end faceY=2.65 faceZ=-2
 elseif key=="saturnita" then
  p("Planet",0,1.8,0,2.6,2.6,2.6,nil,ball)
  for i=1,20 do local a=i*math.pi/10 p("Saturn ring",math.cos(a)*2,1.8+math.sin(a)*0.3,math.sin(a)*2,0.75,0.15,0.35,W.gold,nil,CFrame.Angles(0,-a,0)) end
  p("Cow head",0,3.4,-0.3,1.9,1.5,1.5,W.white,ball) p("Pink muzzle",0,3,-1,1.5,0.65,0.5,Color3.fromRGB(243,129,168),ball)
  p("Cow spot",0.6,3.7,-0.9,0.6,0.5,0.15,W.ink)
  for _,x in ipairs({-1,1}) do p("Ear",x,3.5,-0.2,0.7,0.4,0.6,W.white) p("Horn",x*0.65,4.35,-0.2,0.25,0.7,0.25,W.gold) end feet(W.ink) faceY=3.6 faceZ=-1
 end
 for _,side in ipairs({-1,1}) do
  local x=side*0.4
  p("Eye",x,faceY,faceZ,0.48,0.48,0.17,W.white,ball)
  p("Pupil",x,faceY,faceZ-0.1,0.22,0.27,0.12,W.ink,ball)
  p("Highlight",x-0.05,faceY+0.08,faceZ-0.17,0.08,0.08,0.04,W.white,ball)
  p("Eyebrow",x,faceY+0.36,faceZ-0.02,0.5,0.08,0.1,brown,nil,CFrame.Angles(0,0,side*0.15))
 end
 p("Smile",0,faceY-0.4,faceZ-0.08,0.5,0.09,0.1,W.ink)
 if item.mutation~="" then
  local sparkle=Instance.new("Sparkles") sparkle.SparkleColor=bodyColor sparkle.Parent=root
  if item.mutation=="Diamond" then for i=-1,1 do local crystal=p("Neon crystal",i*0.8,4.7,0,0.3,0.8,0.3,bodyColor,nil,CFrame.Angles(0,0,i*0.3)) crystal.Material=Enum.Material.Neon end end
 end
 local gui=Instance.new("BillboardGui") gui.Size=UDim2.fromOffset(186,79) gui.StudsOffset=Vector3.new(0,4.25,0) gui.MaxDistance=38 gui.AlwaysOnTop=true gui.Parent=root
 local lines={item.mutation,data[1],D.rarities[data[2]].name,"+$"..item.rate.."/s",data[7]}
 for i,t in ipairs(lines) do
  local l=Instance.new("TextLabel") l.BackgroundTransparency=1 l.Size=UDim2.new(1,0,0,15) l.Position=UDim2.fromOffset(0,(i-1)*15)
  l.Font=Enum.Font.GothamBold l.Text=t l.TextSize=i==2 and 13 or 11 l.TextColor3=i==3 and D.rarities[data[2]].color or (i==4 and W.aqua or W.white) l.TextStrokeTransparency=0.25 l.Parent=gui
 end
 model.Parent=parent
 return model
end
return M
