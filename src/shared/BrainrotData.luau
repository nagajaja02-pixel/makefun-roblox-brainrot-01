local D = {}
D.rarities = {
 {name="Common",color=Color3.fromRGB(126,249,182),weight=52},
 {name="Rare",color=Color3.fromRGB(103,202,255),weight=26},
 {name="Epic",color=Color3.fromRGB(215,143,255),weight=14},
 {name="Legendary",color=Color3.fromRGB(255,191,80),weight=6},
 {name="Mythic",color=Color3.fromRGB(255,112,158),weight=2},
}
D.cast = {
 {"Tung Tung Tung Sahur",1,40,4,"sahur",Color3.fromRGB(176,105,56),"Midnight drummer"},
 {"Boneca Ambalabu",1,65,7,"boneca",Color3.fromRGB(103,204,99),"One-wheel frog"},
 {"Trippi Troppi",1,90,10,"trippi",Color3.fromRGB(243,139,99),"Shrimp-tail cat"},
 {"Lirili Larila",2,190,22,"lirili",Color3.fromRGB(82,171,114),"Desert explorer"},
 {"Frigo Camelo",2,330,39,"frigo",Color3.fromRGB(174,221,233),"Cold cargo"},
 {"Chimpanzini Bananini",2,490,58,"banana",Color3.fromRGB(246,196,59),"Banana bunch"},
 {"Brr Brr Patapim",3,850,103,"patapim",Color3.fromRGB(98,151,67),"Forest wanderer"},
 {"Ballerina Cappuccina",3,1350,170,"ballerina",Color3.fromRGB(243,129,168),"Porcelain pirouette"},
 {"Cappuccino Assassino",3,2100,275,"assassino",Color3.fromRGB(90,77,110),"Silent espresso"},
 {"Orangutini Ananasini",4,3700,510,"ananasini",Color3.fromRGB(231,157,51),"Pineapple crown"},
 {"Tralalero Tralala",4,5600,820,"tralalero",Color3.fromRGB(80,158,197),"Three fresh kicks"},
 {"Bombardiro Crocodilo",5,9500,1550,"bombardiro",Color3.fromRGB(106,141,115),"Crocodile airframe"},
 {"La Vaca Saturno Saturnita",5,14500,2500,"saturnita",Color3.fromRGB(170,134,221),"Orbital cow"},
}
function D.make(id, mutate)
 local roll = mutate and math.random(100) or 100
 local multiplier = roll <= 4 and 3 or (roll <= 19 and 2 or 1)
 local c = D.cast[id]
 return {id=id,mutation=multiplier==3 and "Diamond" or (multiplier==2 and "Gold" or ""),rate=c[4]*multiplier,price=math.floor(c[3]*(1+(multiplier-1)*0.35))}
end
function D.random(mutate)
 local roll, tier = math.random(100), 1
 for i,r in ipairs(D.rarities) do
  roll -= r.weight
  if roll <= 0 then tier=i break end
 end
 local pool={}
 for i,c in ipairs(D.cast) do if c[2]==tier then table.insert(pool,i) end end
 return D.make(pool[math.random(#pool)],mutate)
end
return D
