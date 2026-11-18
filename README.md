# Brainrot Blitz

Brainrot Blitz is a Roblox tycoon set in a neon harbor. A moving supply belt brings in thirteen absurd imports, from the Burrito Bailiff to the Cosmic Coupon. Each import pays cash per second once delivered to your safehouse. Buy higher rarities, expand the collection and decide when to risk a raid or race home ahead of a tsunami.

## Build and test

With Rojo 7.7 and Node.js 22.18 or newer, run from the repository root.

```sh
rojo --version
rojo build default.project.json --output game.rbxl
mkdir -p out
MAKEFUN_OUTPUT_DIR=out node main.ts
```

Open `game.rbxl` in Roblox Studio and press **Play** to spawn the map and characters. Use Studio's **Server & Clients** testing mode with two players to test raids. The start place supports six concurrent players, one per safehouse.

## How to play

1. Follow the conveyor and use the prompt to buy an import. You start with $150 and four display stands.
2. Bring the import into your own safehouse. The home beacon marks it and delivery installs your cargo automatically. The HUD shows cash, income per second and the wave clock.
3. Spend income on stronger units or use **Expand Base** to unlock two stands per upgrade up to eight. Rarities are Common, Rare, Epic, Legendary and Mythic. Gold units pay 2× and Diamond units pay 3× their normal income.
4. Hold the raid prompt on an opponent's unit while their shield is down, then return to your own base with it. Raise the shield from your base terminal for 26 seconds. The HUD shows when the 48-second cooldown ends.
5. When the evacuation alarm fires, get inside your own safehouse before the wave passes. Falling with a purchased unit in transit refunds it. A stolen unit still in transit goes back to its owner.
6. Use **Rebirth** to restart with $150 and an empty collection. Stand upgrades carry over and each rebirth adds 50% to income permanently in the published experience. Studio keeps rebirths for the test session. Cash, crew and stand upgrades are session-local.

The captures and public play link are pending owner setup in Studio. Build the place from the Luau in `src/` before you capture or publish it.
