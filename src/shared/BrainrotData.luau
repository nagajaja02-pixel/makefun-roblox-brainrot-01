local Data = {}
local rgb = Color3.fromRGB

Data.rarities = {
	{ name = "Common", color = rgb(126, 249, 182), weight = 52 },
	{ name = "Rare", color = rgb(103, 202, 255), weight = 26 },
	{ name = "Epic", color = rgb(215, 143, 255), weight = 14 },
	{ name = "Legendary", color = rgb(255, 191, 80), weight = 6 },
	{ name = "Mythic", color = rgb(255, 112, 158), weight = 2 },
}

local function entry(name, tier, price, rate, key, color, caption)
	return { name = name, tier = tier, price = price, rate = rate, key = key, color = color, caption = caption }
end

Data.cast = {
	entry("Tung Tung Tung Sahur", 1, 40, 4, "sahur", rgb(176,105,56), "Midnight drummer"),
	entry("Boneca Ambalabu", 1, 65, 7, "boneca", rgb(103,204,99), "One-wheel frog"),
	entry("Trippi Troppi", 1, 90, 10, "trippi", rgb(243,139,99), "Shrimp-tail cat"),
	entry("Lirili Larila", 2, 190, 22, "lirili", rgb(82,171,114), "Desert explorer"),
	entry("Frigo Camelo", 2, 330, 39, "frigo", rgb(174,221,233), "Cold cargo"),
	entry("Chimpanzini Bananini", 2, 490, 58, "banana", rgb(246,196,59), "Banana bunch"),
	entry("Brr Brr Patapim", 3, 850, 103, "patapim", rgb(98,151,67), "Forest wanderer"),
	entry("Ballerina Cappuccina", 3, 1350, 170, "ballerina", rgb(243,129,168), "Porcelain pirouette"),
	entry("Cappuccino Assassino", 3, 2100, 275, "assassino", rgb(90,77,110), "Silent espresso"),
	entry("Orangutini Ananasini", 4, 3700, 510, "ananasini", rgb(231,157,51), "Pineapple crown"),
	entry("Tralalero Tralala", 4, 5600, 820, "tralalero", rgb(80,158,197), "Three fresh kicks"),
	entry("Bombardiro Crocodilo", 5, 9500, 1550, "bombardiro", rgb(106,141,115), "Crocodile airframe"),
	entry("La Vaca Saturno Saturnita", 5, 14500, 2500, "saturnita", rgb(170,134,221), "Orbital cow"),
}

Data.mutations = {
	Gold = { multiplier = 2, color = rgb(255,199,101) },
	Diamond = { multiplier = 3, color = rgb(122,225,255) },
}

local byTier = { {}, {}, {}, {}, {} }
for _, character in Data.cast do
	table.insert(byTier[character.tier], character)
end

function Data.offer(character, mutation)
	local multiplier = mutation and Data.mutations[mutation].multiplier or 1
	return {
		character = character,
		mutation = mutation,
		price = math.floor(character.price * (1 + (multiplier - 1) * 0.35)),
		rate = character.rate * multiplier,
	}
end

function Data.roll(random, starter)
	local tier = 1
	local mutation
	if not starter then
		local roll = random:NextInteger(1, 100)
		for index, rarity in Data.rarities do
			roll -= rarity.weight
			if roll <= 0 then
				tier = index
				break
			end
		end
	end
	local choices = byTier[tier]
	local character = choices[random:NextInteger(1, #choices)]
	if not starter then
		local roll = random:NextInteger(1, 100)
		if roll <= 4 then
			mutation = "Diamond"
		elseif roll <= 19 then
			mutation = "Gold"
		end
	end
	return Data.offer(character, mutation)
end

return Data
