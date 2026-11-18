local Data = {}
Data.Rarities = {
 {name="Common", color=Color3.fromRGB(126,249,182), weight=52},
 {name="Rare", color=Color3.fromRGB(103,202,255), weight=26},
 {name="Epic", color=Color3.fromRGB(215,143,255), weight=14},
 {name="Legendary", color=Color3.fromRGB(255,191,80), weight=6},
 {name="Mythic", color=Color3.fromRGB(255,112,158), weight=2},
}
Data.Cast = {
 {name="Tung Tung Tung Sahur",tier=1,price=40,rate=4,key="sahur",color=Color3.fromRGB(176,105,56),caption="Midnight drummer"},
 {name="Boneca Ambalabu",tier=1,price=65,rate=7,key="boneca",color=Color3.fromRGB(103,204,99),caption="One-wheel frog"},
 {name="Trippi Troppi",tier=1,price=90,rate=10,key="trippi",color=Color3.fromRGB(243,139,99),caption="Shrimp-tail cat"},
 {name="Lirili Larila",tier=2,price=190,rate=22,key="lirili",color=Color3.fromRGB(82,171,114),caption="Desert explorer"},
 {name="Frigo Camelo",tier=2,price=330,rate=39,key="frigo",color=Color3.fromRGB(174,221,233),caption="Cold cargo"},
 {name="Chimpanzini Bananini",tier=2,price=490,rate=58,key="banana",color=Color3.fromRGB(246,196,59),caption="Banana bunch"},
 {name="Brr Brr Patapim",tier=3,price=850,rate=103,key="patapim",color=Color3.fromRGB(98,151,67),caption="Forest wanderer"},
 {name="Ballerina Cappuccina",tier=3,price=1350,rate=170,key="ballerina",color=Color3.fromRGB(243,129,168),caption="Porcelain pirouette"},
 {name="Cappuccino Assassino",tier=3,price=2100,rate=275,key="assassino",color=Color3.fromRGB(90,77,110),caption="Silent espresso"},
 {name="Orangutini Ananasini",tier=4,price=3700,rate=510,key="ananasini",color=Color3.fromRGB(231,157,51),caption="Pineapple crown"},
 {name="Tralalero Tralala",tier=4,price=5600,rate=820,key="tralalero",color=Color3.fromRGB(80,158,197),caption="Three fresh kicks"},
 {name="Bombardiro Crocodilo",tier=5,price=9500,rate=1550,key="bombardiro",color=Color3.fromRGB(106,141,115),caption="Crocodile airframe"},
 {name="La Vaca Saturno Saturnita",tier=5,price=14500,rate=2500,key="saturnita",color=Color3.fromRGB(170,134,221),caption="Orbital cow"},
}
function Data.offer(index, allowMutation, rng)
 rng = rng or Random.new()
 local multiplier, mutation = 1, ""
 if allowMutation then
  local roll = rng:NextInteger(1,100)
  if roll <= 4 then multiplier, mutation = 3, "Diamond"
  elseif roll <= 19 then multiplier, mutation = 2, "Gold" end
 end
 local entry = Data.Cast[index]
 return {index=index, data=entry, mutation=mutation, multiplier=multiplier,
  price=math.floor(entry.price*(1+(multiplier-1)*0.35)), rate=entry.rate*multiplier}
end
function Data.randomOffer(rng, starter)
 local tier = 1
 if not starter then
  local roll = rng:NextInteger(1,100)
  for i, rarity in ipairs(Data.Rarities) do
   roll -= rarity.weight
   if roll <= 0 then tier = i break end
  end
 end
 local choices = {}
 for i, entry in ipairs(Data.Cast) do
  if entry.tier == tier then table.insert(choices,i) end
 end
 return Data.offer(choices[rng:NextInteger(1,#choices)], not starter, rng)
end
return Data
