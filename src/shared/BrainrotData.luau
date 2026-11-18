local Data = {}

Data.rarities = {
	{ name = "Common", color = Color3.fromRGB(126, 249, 182), weight = 52 },
	{ name = "Rare", color = Color3.fromRGB(103, 202, 255), weight = 26 },
	{ name = "Epic", color = Color3.fromRGB(215, 143, 255), weight = 14 },
	{ name = "Legendary", color = Color3.fromRGB(255, 191, 80), weight = 6 },
	{ name = "Mythic", color = Color3.fromRGB(255, 112, 158), weight = 2 },
}

-- Name, tier, price, income, silhouette, body color, caption.
Data.cast = {
	{ "Burrito Bailiff", 1, 40, 4, "wrap", Color3.fromRGB(235, 167, 88), "Charged with contempt of lunch." },
	{ "Toaster Intern", 1, 65, 7, "toast", Color3.fromRGB(242, 104, 107), "Burned through the onboarding." },
	{ "Puddle Auditor", 1, 90, 10, "blob", Color3.fromRGB(71, 182, 230), "Found a liquidity problem." },
	{ "Pickle Pilot", 2, 190, 22, "wrap", Color3.fromRGB(129, 217, 89), "Authorized for dill takeoff." },
	{ "Fax Machine DJ", 2, 330, 39, "toast", Color3.fromRGB(108, 148, 242), "Dropping a paper jam." },
	{ "Clam McSpam", 2, 490, 58, "blob", Color3.fromRGB(247, 152, 185), "You have 900 unread clams." },
	{ "Waffle Locksmith", 3, 850, 103, "toast", Color3.fromRGB(238, 167, 83), "Every key is syrup-coated." },
	{ "Lava Lamp Lawyer", 3, 1350, 170, "lamp", Color3.fromRGB(224, 89, 192), "Objects in slow motion." },
	{ "Microwave Mayor", 3, 2100, 275, "toast", Color3.fromRGB(99, 213, 207), "Reheating the economy." },
	{ "Disco Dumpster", 4, 3700, 510, "toast", Color3.fromRGB(182, 121, 241), "Trash night is every night." },
	{ "Moon Mozzarella", 4, 5600, 820, "blob", Color3.fromRGB(248, 211, 126), "One small dip for cheese." },
	{ "Soup Singularity", 5, 9500, 1550, "lamp", Color3.fromRGB(134, 116, 255), "Even spoons cannot escape." },
	{ "Cosmic Coupon", 5, 14500, 2500, "wrap", Color3.fromRGB(255, 128, 163), "Expires before time begins." },
}

function Data.create(index, allowMutation)
	local entry = Data.cast[index]
	local roll = allowMutation and math.random(100) or 100
	local mutation = roll <= 4 and "Diamond" or roll <= 19 and "Gold" or ""
	local multiplier = mutation == "Diamond" and 3 or mutation == "Gold" and 2 or 1
	return {
		entry = entry,
		rarity = Data.rarities[entry[2]],
		mutation = mutation,
		price = math.floor(entry[3] * (1 + (multiplier - 1) * 0.35)),
		rate = entry[4] * multiplier,
	}
end

function Data.randomOffer()
	local roll = math.random(100)
	for tier, rarity in ipairs(Data.rarities) do
		roll -= rarity.weight
		if roll <= 0 then
			local candidates = {}
			for index, entry in ipairs(Data.cast) do
				if entry[2] == tier then
					table.insert(candidates, index)
				end
			end
			return Data.create(candidates[math.random(#candidates)], true)
		end
	end
end

return Data
