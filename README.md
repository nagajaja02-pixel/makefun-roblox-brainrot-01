# Brainrot Blitz

[![make.fun · roblox-brainrot-01](https://make.fun/badge/roblox-brainrot-01.svg)](https://make.fun/bounty/roblox-brainrot-01?utm_source=github&utm_medium=readme&utm_campaign=roblox-brainrot-01)
[![rank](https://make.fun/badge/roblox-brainrot-01/nagajaja02-pixel/makefun-roblox-brainrot-01/rank.svg)](https://make.fun/bounty/roblox-brainrot-01/leaderboard?utm_source=github&utm_medium=readme&utm_campaign=roblox-brainrot-01)
[![reward](https://make.fun/badge/roblox-brainrot-01/nagajaja02-pixel/makefun-roblox-brainrot-01/reward.svg)](https://make.fun/bounty/roblox-brainrot-01?utm_source=github&utm_medium=readme&utm_campaign=roblox-brainrot-01)

Built for the [roblox-brainrot-01 bounty on make.fun](https://make.fun/bounty/roblox-brainrot-01).

Play it live: https://www.roblox.com/games/105239944014039 — Brainrot Blitz - Steal And Tsunami (Public).

Experience thumbnail: the aerial cover is live and approved on Roblox.

A colorful harbor tycoon with a moving import conveyor, six safehouses, risky raids, and a sweeping tsunami. Buy a brainrot, carry it home, and turn its income into rarer arrivals. Gold and Diamond mutations multiply income. Activate your laser shield for 26 seconds, followed by a full 48-second cooldown after the shield ends.

The thirteen viral characters are Tung Tung Tung Sahur, Boneca Ambalabu, Trippi Troppi, Lirili Larila, Frigo Camelo, Chimpanzini Bananini, Brr Brr Patapim, Ballerina Cappuccina, Cappuccino Assassino, Orangutini Ananasini, Tralalero Tralala, Bombardiro Crocodilo, and La Vaca Saturno Saturnita. Each has a distinct part-built silhouette, face, caption, rarity, and income label.

Start with $150 and four stands. Use E on PC or tap a prompt on mobile to buy or pick up; hold Raid for 1.25 seconds to steal from another safehouse. A shield blocks intruders in both directions. Return to your own safehouse to deliver a purchase or stolen character. For rearrangement, pick up your own character, leave home, then re-enter. A failed raid returns its character to the victim. Sell a carried character at the Brainrot Shop for 50% of its purchase price, including mutation pricing.

Expand to six and then eight stands. Rebirth from the menu costs $12,000 times your next rebirth number and grants another 50% income bonus. It resets cash to $150, clears your collection, and resets stand upgrades; carry and raids in transit must finish first. Only rebirth counts persist between sessions outside Studio. Use the Index menu to browse the cast. When the evacuation warning appears, reach a safehouse before the tsunami sweeps the island.

Build with Rojo 7.7 and Node 22.18 or later:

```sh
rojo build default.project.json -o game.rbxl
MAKEFUN_OUTPUT_DIR=out node main.ts
```

The packaging entrypoint copies the binary place, play link, source, and screenshots to the output directory and creates a deterministic dossier using the unchanged kit vendor. Roblox Studio is required to play-test the experience.
