# Brainrot Blitz

[![make.fun · roblox-brainrot-01](https://make.fun/badge/roblox-brainrot-01.svg)](https://make.fun/bounty/roblox-brainrot-01?utm_source=github&utm_medium=readme&utm_campaign=roblox-brainrot-01)
[![rank](https://make.fun/badge/roblox-brainrot-01/nagajaja02-pixel/makefun-roblox-brainrot-01/rank.svg)](https://make.fun/bounty/roblox-brainrot-01/leaderboard?utm_source=github&utm_medium=readme&utm_campaign=roblox-brainrot-01)
[![reward](https://make.fun/badge/roblox-brainrot-01/nagajaja02-pixel/makefun-roblox-brainrot-01/reward.svg)](https://make.fun/bounty/roblox-brainrot-01?utm_source=github&utm_medium=readme&utm_campaign=roblox-brainrot-01)

Built for the [roblox-brainrot-01 bounty on make.fun](https://make.fun/bounty/roblox-brainrot-01).

Play it live: https://www.roblox.com/games/105239944014039 — Brainrot Blitz - Steal And Tsunami (Public).

Experience thumbnail: the aerial cover is live and approved on Roblox.

Brainrot Blitz is a 3D harbor tycoon with a moving import conveyor, six colorful safehouses, player raids, and a sweeping tsunami. Every collectible is assembled from parts, with a face, a distinctive silhouette, a rarity label, and its own income rate. Gold and Diamond mutations increase income by 2× and 3×.

The thirteen characters are Tung Tung Tung Sahur, Boneca Ambalabu, Trippi Troppi, Lirili Larila, Frigo Camelo, Chimpanzini Bananini, Brr Brr Patapim, Ballerina Cappuccina, Cappuccino Assassino, Orangutini Ananasini, Tralalero Tralala, Bombardiro Crocodilo, and La Vaca Saturno Saturnita.

Start with $150 and four stands. Use E on PC or tap a prompt on mobile to buy a passing brainrot. Your collection earns cash each second. Expand your safehouse to six and then eight stands. Pick up your own collectible, leave and re-enter home to deliver it, or carry it to the Brainrot Shop to sell for 50% of its purchase price, including its mutation premium.

Hold the Raid prompt for 1.25 seconds to steal an unshielded collectible. Bring it to your safehouse to claim it; dying returns the carry to its owner. Your shield stays active for 26 seconds and has a 48-second cooldown from activation. Its lasers let the owner pass and block other players in both directions. Follow the evacuation warning and return to your safehouse before the tsunami reaches you.

Open Rebirth from anywhere using the menu or R. A rebirth costs $12,000 times the next rebirth number, resets cash and the collection, and adds a permanent 50% income bonus. Finish all carries and raids first. Only rebirth counts persist between sessions. Open Index or press I to browse the full cast.

Build with Rojo 7.7 and Node 22.18 or newer:

```sh
rojo build default.project.json -o game.rbxl
MAKEFUN_OUTPUT_DIR=out node main.ts
```

The entrypoint copies the binary place, play link, source tree, and screenshots into the output directory, then uses the unchanged kit vendor to create a deterministic dossier. Open the place in Roblox Studio for multiplayer playtesting; a command-line build does not simulate Roblox physics or rendering.
