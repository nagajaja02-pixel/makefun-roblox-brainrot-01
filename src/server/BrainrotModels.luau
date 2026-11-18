local Data = require(game:GetService("ReplicatedStorage"):WaitForChild("BrainrotData"))
local World = require(script.Parent.World)
local Models = {}
local V = Vector3.new
local rgb = Color3.fromRGB
local ink, white, gold = World.ink, World.white, World.gold
local wood = rgb(118,65,41)
local silver = rgb(192,208,217)
local pink = rgb(255,142,179)
local shapes = Enum.PartType
local neon = Enum.Material.Neon

local function face(p, y, z, spacing, mood)
	for _, side in {-1,1} do
		local x = spacing*side
		p("Eye",x,y,z,0.37,0.46,0.22,white,shapes.Ball)
		p("Pupil",x+0.035,y-0.025,z-0.105,0.17,0.24,0.11,ink,shapes.Ball)
		p("Catchlight",x+0.065,y+0.025,z-0.158,0.065,0.065,0.04,white,shapes.Ball)
		p("Brow",x,y+0.31,z,0.35,0.09,0.12,ink,nil,side*mood)
	end
	p("Mouth",0,y-0.34,z-0.02,0.38,mood > 0 and 0.08 or 0.16,0.12,ink,shapes.Ball)
end

local function feet(p, color, separation, y, z, size)
	for _, side in {-1,1} do
		p("Foot",separation*side,y,z,size,2*y,size*1.4,color,shapes.Ball)
	end
end

local function cup(p, c, dark)
	p("Cup",0,2.85,0,1.15,1.7,1.7,c,shapes.Cylinder,nil,math.pi/2)
	p("Lip",0,3.45,0,0.12,1.86,1.86,c,shapes.Cylinder,nil,math.pi/2)
	p("Coffee",0,3.53,0,0.045,1.65,1.65,wood,shapes.Cylinder,nil,math.pi/2)
	p("Handle",0.94,2.94,0,0.57,0.55,0.24,c,shapes.Ball)
	if not dark then
		for _, x in {-0.21,0,0.21} do
			p("Foam",x,3.56,0,0.31,0.04,0.68,white,shapes.Ball,nil,x)
		end
	end
	face(p,2.98,-0.82,0.37,dark and 0.36 or -0.15)
end

local builders = {}

function builders.sahur(p,c)
	p("Timber body",0,1.98,0,1.65,2.7,1.15,c)
	for _, x in {-0.62,-0.3,0.26,0.59} do
		p("Wood grain",x,1.46,-0.58,0.055,1.13,0.025,wood,nil,x*0.12)
	end
	for _, s in {-1,1} do
		p("Wood arm",s*1.01,1.88,0,0.36,1.55,0.46,c,nil,s*0.26)
		p("Wood leg",s*0.44,0.53,0,0.42,0.9,0.48,c)
	end
	feet(p,wood,0.46,0.17,-0.2,0.61)
	p("Mallet handle",1.34,1.9,-0.3,0.21,1.88,0.21,wood,nil,-0.21)
	p("Mallet head",1.5,2.87,-0.3,0.91,0.47,0.57,gold,shapes.Cylinder)
	face(p,2.55,-0.59,0.39,-0.2)
end

function builders.boneca(p,c)
	p("Tire",0,0.68,0,0.62,1.36,1.36,ink,shapes.Cylinder)
	for _, s in {-1,1} do
		p("Rim",s*0.33,0.68,0,0.06,0.79,0.79,silver,shapes.Cylinder)
		p("Amphibian leg",s*0.65,0.89,0,0.27,1.54,0.34,c,shapes.Ball,s*0.33)
		p("Eye bump",s*0.45,2.52,-0.19,0.76,0.78,0.73,c,shapes.Ball)
	end
	feet(p,c,0.79,0.2,-0.33,0.61)
	p("Frog head",0,1.99,0,1.95,1.37,1.24,c,shapes.Ball)
	face(p,2.47,-0.54,0.46,-0.14)
end

function builders.trippi(p,c)
	for index = 0,4 do
		local size = 1.35-index*0.19
		p("Shrimp shell",0,0.55+index*0.13,index*0.42,size,size*0.8,size,c:Lerp(pink,index/4),shapes.Ball)
	end
	p("Kitten",0,1.49,-0.45,1.62,1.39,1.22,white,shapes.Ball)
	for _, s in {-1,1} do
		p("Pointed cat ear",s*0.6,2.13,-0.48,0.46,0.67,0.34,white,nil,s*0.48)
		p("Tail fan",s*0.31,1.17,1.96,0.55,0.28,0.75,pink,shapes.Ball,s*0.55)
		for index = 0,2 do
			p("Whisker",s*0.61,1.29+index*0.12,-1.05,0.61,0.045,0.06,ink,nil,s*(index-1)*0.15)
		end
	end
	feet(p,c,0.43,0.12,-0.6,0.5)
	face(p,1.62,-1.03,0.32,-0.24)
end

function builders.lirili(p,c)
	p("Cactus torso",0,1.14,0,1.35,1.86,1.19,c,shapes.Ball)
	for _, x in {-0.43,-0.21,0.21,0.43} do
		p("Rib",x,1.05,-0.52,0.085,0.93,0.09,c:Lerp(ink,0.28),shapes.Ball)
	end
	p("Elephant head",0,2.36,0,1.52,1.27,1.35,silver,shapes.Ball)
	for _, s in {-1,1} do
		p("Elephant ear",s*0.78,2.39,0.04,0.86,1.05,0.36,silver,shapes.Ball)
		p("Foot",s*0.46,0.28,-0.25,0.6,0.35,0.89,silver,shapes.Ball)
	end
	feet(p,wood,0.47,0.11,-0.27,0.67)
	p("Trunk",0,1.99,-0.89,0.35,0.79,0.36,silver,shapes.Ball,nil,-0.15)
	p("Trunk tip",0.09,1.66,-1.07,0.39,0.22,0.43,silver,shapes.Ball)
	face(p,2.52,-0.63,0.34,-0.15)
end

function builders.frigo(p,c)
	p("Refrigerator",0,1.23,0,1.52,1.89,1.24,c)
	for _, y in {0.99,1.89} do
		p("Door",0,y,-0.64,1.36,y < 1 and 1.02 or 0.59,0.15,white)
		p("Handle",0.47,y,-0.76,0.12,0.33,0.13,silver)
	end
	p("Camel neck",0,2.35,0.13,0.48,0.93,0.62,gold,shapes.Ball)
	p("Camel head",0,2.94,-0.14,1.03,0.78,1.33,gold,shapes.Ball)
	p("Muzzle",0,2.70,-0.8,0.79,0.4,0.62,wood,shapes.Ball)
	for _, s in {-1,1} do
		p("Ear",s*0.36,3.33,0.12,0.23,0.47,0.26,gold,shapes.Ball,s*0.26)
	end
	feet(p,ink,0.46,0.19,-0.21,0.61)
	face(p,3,-0.75,0.26,-0.12)
end

function builders.banana(p,c)
	p("Banana",0,1.29,0.03,1.36,2.2,1.05,c,shapes.Ball,nil,-0.15)
	for _, s in {-1,1} do
		p("Peel",s*0.75,1.21,-0.07,0.46,1.32,0.53,c,shapes.Ball,s*0.76)
		p("Round ear",s*0.63,2.26,-0.15,0.49,0.54,0.42,wood,shapes.Ball)
		p("Leg",s*0.37,0.39,0,0.32,0.73,0.39,wood,shapes.Ball)
	end
	feet(p,wood,0.43,0.16,-0.19,0.52)
	p("Monkey head",0,2.31,-0.18,1.27,1.17,1.07,wood,shapes.Ball)
	p("Muzzle",0,2.09,-0.69,0.74,0.46,0.35,gold,shapes.Ball)
	p("Stem",0.12,2.99,0.03,0.21,0.33,0.26,wood,nil,-0.3)
	face(p,2.41,-0.67,0.28,-0.2)
end

function builders.patapim(p,c)
	p("Tree trunk",0,1.48,0,1.44,2.34,1.15,wood)
	p("Moss canopy",0,2.62,0,2.12,1.47,1.55,c,shapes.Ball)
	for _, s in {-1,1} do
		p("Branch arm",s*1.02,1.45,0.04,0.35,1.73,0.45,wood,nil,s*0.47)
		p("Moss tuft",s*0.79,2.75,0.26,0.98,1.1,0.99,c,shapes.Ball)
	end
	feet(p,wood,0.59,0.26,-0.15,0.98)
	p("Long nose",0,2.32,-1,0.27,0.38,1.21,gold,shapes.Ball)
	face(p,2.62,-0.73,0.34,-0.18)
end

function builders.ballerina(p,c)
	cup(p,white,false)
	p("Bodice",0,1.77,0,0.91,0.95,0.65,c,shapes.Ball)
	p("Tutu",0,1.35,0,2,0.39,1.54,c,shapes.Ball)
	for _, s in {-1,1} do
		p("Ballet arm",s*0.74,2.04,0,0.24,1.06,0.26,white,shapes.Ball,s*0.99)
		p("Ballet leg",s*0.25,0.73,0,0.23,1.15,0.28,white)
		p("Ribbon",s*0.25,0.31,-0.13,0.26,0.12,0.08,c,nil,s*0.39)
	end
	feet(p,c,0.25,0.14,-0.13,0.34)
end

function builders.assassino(p,c)
	cup(p,c,true)
	p("Headband",0,3.28,-0.69,1.45,0.2,0.19,pink)
	for index = 1,2 do
		p("Ribbon tail",0.91+index*0.12,3.15-index*0.12,0.23,0.2,0.83,0.11,pink,nil,0.73+index*0.24)
	end
	p("Ninja tunic",0,1.45,0,1.28,1.32,0.96,ink)
	for _, s in {-1,1} do
		p("Sleeve",s*0.79,1.37,-0.04,0.35,1.05,0.43,ink,nil,s*0.24)
		p("Trouser",s*0.32,0.49,0,0.42,0.9,0.58,ink)
	end
	feet(p,ink,0.32,0.17,-0.15,0.56)
	p("Foam blade",1.31,2.07,-0.19,0.35,1.53,0.14,silver,nil,-0.36)
	p("Sword guard",1.06,1.34,-0.19,0.61,0.13,0.22,gold,nil,-0.36)
	p("Sword grip",0.99,1.15,-0.19,0.19,0.39,0.17,gold,nil,-0.36)
end

function builders.ananasini(p,c)
	p("Pineapple",0,1.26,0,1.77,2.17,1.4,c,shapes.Ball)
	for row = 0,3 do
		for column = -1,1 do
			local x = column*0.41+(row%2)*0.1
			p("Pineapple scale",x,0.64+row*0.28,-0.53-math.sqrt(1-x*x)*0.14,0.23,0.23,0.075,gold,nil,math.pi/4)
		end
	end
	p("Orangutan head",0,2.51,-0.04,1.57,1.14,1.16,wood,shapes.Ball)
	p("Face patch",0,2.43,-0.52,1.15,0.84,0.32,gold,shapes.Ball)
	for index = -2,2 do
		p("Crown leaf",index*0.22,3.29,0.13,0.26,0.89,0.29,rgb(72,168,82),shapes.Ball,-index*0.31)
	end
	for _, s in {-1,1} do
		p("Long arm",s*1.03,1.28,0,0.47,1.75,0.54,wood,shapes.Ball,s*0.32)
		p("Knuckles",s*1.23,0.53,-0.08,0.59,0.48,0.64,wood,shapes.Ball)
	end
	feet(p,wood,0.45,0.15,-0.21,0.57)
	face(p,2.55,-0.67,0.28,-0.2)
end

function builders.tralalero(p,c)
	p("Shark body",0,1.62,0.23,1.54,1.49,2.94,c,shapes.Ball)
	p("White belly",0,1.34,0.15,1.43,0.84,2.65,white,shapes.Ball)
	p("Snout",0,1.66,-1.01,1.35,0.68,0.95,c,shapes.Ball)
	p("Dorsal fin",0,2.45,0.33,0.23,1.02,0.87,c,shapes.Ball,nil,0,-0.36)
	p("Tail fin",0,1.63,1.69,0.31,1.45,0.69,c,shapes.Ball,nil,0,0.34)
	for _, s in {-1,1} do
		p("Side fin",s*0.81,1.53,0.33,1.09,0.25,0.64,c,shapes.Ball,s*0.27)
	end
	for _, step in {{-0.56,-0.49},{0.56,-0.49},{0,0.98}} do
		local x,z = step[1],step[2]
		p("Shark leg",x,0.74,z,0.38,0.95,0.43,c)
		p("Sneaker",x,0.27,z-0.14,0.65,0.49,0.91,rgb(56,107,224),shapes.Ball)
		p("Sole",x,0.075,z-0.19,0.67,0.15,0.9,white)
		for index = 0,2 do
			p("Lace",x,0.46,z-0.25+index*0.09,0.33,0.046,0.04,white)
		end
	end
	face(p,1.9,-1.38,0.32,0.26)
end

function builders.bombardiro(p,c)
	p("Fuselage",0,1.34,0.25,1.43,1.4,3.51,silver,shapes.Ball)
	p("Tailplane",0,1.58,1.83,1.81,0.2,0.71,silver)
	p("Tail",0,2.01,1.69,0.25,1.11,0.87,silver,shapes.Ball)
	p("Wings",0,1.26,0.28,4.49,0.24,1.27,silver)
	p("Crocodile head",0,2.03,-0.71,1.29,0.94,1.24,c,shapes.Ball)
	p("Long muzzle",0,1.9,-1.61,1.1,0.46,1.51,c,shapes.Ball)
	p("Lower jaw",0,1.56,-1.62,1.02,0.25,1.49,gold,shapes.Ball)
	for _, s in {-1,1} do
		p("Engine",s*1.51,1.03,0.11,0.6,0.59,0.95,c,shapes.Ball)
		p("Propeller",s*1.51,1.05,-0.49,0.14,1.11,0.13,ink,nil,s*0.65)
		p("Propeller hub",s*1.51,1.05,-0.56,0.23,0.23,0.23,gold,shapes.Ball)
		for index = 0,3 do
			p("Tooth",s*0.39,1.72,-1.27-index*0.19,0.12,0.21,0.13,white,shapes.Ball)
		end
	end
	feet(p,ink,0.46,0.17,0.29,0.43)
	face(p,2.23,-1.23,0.31,0.3)
end

function builders.saturnita(p,c)
	p("Saturn body",0,1.53,0.16,2.09,2.09,2.1,c,shapes.Ball)
	for index = 0,19 do
		local angle = index*math.pi/10
		local frame = CFrame.new(0,1.58,0.16)*CFrame.Angles(0,0,0.22)
			*CFrame.Angles(0,angle,0)*CFrame.new(1.54,0,0)
		p("Saturn ring",0,0,0,0.48,0.13,0.54,gold,nil,nil,nil,nil,frame)
	end
	p("Cow head",0,2.27,-0.88,1.55,1.25,1.06,white,shapes.Ball)
	p("Pink muzzle",0,1.96,-1.39,1.14,0.49,0.55,pink,shapes.Ball)
	p("Cow patch",0.43,2.46,-1.28,0.49,0.54,0.19,ink,shapes.Ball)
	for _, s in {-1,1} do
		p("Cow ear",s*0.84,2.42,-0.88,0.63,0.3,0.38,pink,shapes.Ball,s*0.39)
		p("Horn",s*0.46,2.92,-0.87,0.22,0.43,0.24,gold,shapes.Ball,-s*0.31)
		for _, z in {-0.49,0.68} do
			p("Leg",s*0.58,0.43,z,0.34,0.68,0.36,white)
			p("Hoof",s*0.58,0.16,z,0.48,0.32,0.52,ink)
		end
	end
	face(p,2.48,-1.36,0.34,-0.18)
end

local function billboard(root, offer)
	local gui = Instance.new("BillboardGui")
	gui.Name = "Brainrot label"
	gui.Size = UDim2.fromOffset(186,79)
	gui.StudsOffsetWorldSpace = V(0,4.25,0)
	gui.MaxDistance = 38
	gui.AlwaysOnTop = true
	gui.Parent = root
	local rarity = Data.rarities[offer.character.tier]
	local function row(text, y, height, size, color, font)
		local label = Instance.new("TextLabel")
		label.Position = UDim2.fromOffset(0,y)
		label.Size = UDim2.new(1,0,0,height)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextSize = size
		label.TextColor3 = color
		label.TextStrokeTransparency = 0.2
		label.Font = font
		label.Parent = gui
	end
	if offer.mutation then
		row(offer.mutation,0,14,13,Data.mutations[offer.mutation].color,Enum.Font.GothamBold)
	end
	row(offer.character.name,14,19,14,white,Enum.Font.GothamBold)
	row(rarity.name,33,15,13,rarity.color,Enum.Font.GothamBold)
	row(("+$%d/s"):format(offer.rate),48,16,14,rgb(126,249,182),Enum.Font.GothamBold)
	row(offer.character.caption,64,15,12,white,Enum.Font.Gotham)
end

function Models.create(offer, parent, pose)
	local model = Instance.new("Model")
	model.Name = offer.character.name
	local root = World.part(model,"Pivot",V(0.2,0.2,0.2),V(0,0,0),ink,nil,false,1)
	model.PrimaryPart = root
	local function piece(name,x,y,z,sx,sy,sz,color,shape,roll,pitch,material,frame)
		local offset = frame or CFrame.new(x,y,z)*CFrame.Angles(pitch or 0,0,roll or 0)
		local part = World.part(model,name,V(sx,sy,sz),offset,color,material,false)
		part.Shape = shape or shapes.Block
		part.Massless = true
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = root
		weld.Part1 = part
		weld.Parent = part
		part.Anchored = false
		return part
	end
	local mutation = offer.mutation and Data.mutations[offer.mutation]
	builders[offer.character.key](piece,mutation and mutation.color or offer.character.color)
	if offer.mutation == "Diamond" then
		for _, s in {-1,1} do
			piece("Diamond crystal",s*0.96,0.37,0.43,0.31,0.58,0.31,mutation.color,nil,s*0.47,nil,neon)
		end
	elseif offer.mutation == "Gold" then
		local sparkles = Instance.new("Sparkles")
		sparkles.SparkleColor = gold
		sparkles.Parent = root
	end
	billboard(root,offer)
	model:PivotTo(pose)
	model.Parent = parent
	return model
end

return Models
