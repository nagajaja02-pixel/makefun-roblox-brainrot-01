# Brainrot Blitz — make.fun roblox-brainrot-01 entry

[![make.fun](https://make.fun/badge/roblox-brainrot-01.svg)](https://make.fun/bounty/roblox-brainrot-01)
[![Rank](https://make.fun/badge/roblox-brainrot-01/nagajaja02-pixel/makefun-roblox-brainrot-01/rank.svg)](https://make.fun/bounty/roblox-brainrot-01)
[![Reward](https://make.fun/badge/roblox-brainrot-01/nagajaja02-pixel/makefun-roblox-brainrot-01/reward.svg)](https://make.fun/bounty/roblox-brainrot-01)

A 3D brainrot tycoon game for Roblox: absurd meme brainrot characters walk the conveyor, you buy them, place them in your base, and they earn $/second. Climb the rarity ladder from Common to Mythic, mutate your best ones, lock your base against thieves, and survive the brainrot tsunami. Rebirth for a permanent boost and do it all again, faster.

- `main.ts` (Node 22, standard library only) hands the game in: it copies `game.rbxl`, `src/`, `screenshots/` and `PLAY.json` to `/output`, leaving out every name that starts with a dot, and writes `/output/dossier.json` with `vendor/makefun-roblox.ts`, the kit's copy, unchanged.
- `game.rbxl` is the place Rojo builds from `src/` and `default.project.json`; `screenshots/` holds captures of it; `PLAY.json` names the published place.
- One of the screenshots is also the game's first thumbnail on Roblox: the same picture, uploaded on the Creator Dashboard with the game's icon.

Run it as the grader does, writing `out/` in place of `/output`:

    mkdir -p out && MAKEFUN_OUTPUT_DIR=out node main.ts

Built for [make.fun](https://make.fun/bounty/roblox-brainrot-01).
