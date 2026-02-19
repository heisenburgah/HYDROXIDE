# Hydroxide

A comprehensive Roblox utility suite for Rogue Lineage and Rogue Lineage Battlegrounds. ~41,000 lines of Lua across two game modules.

**Website:** [hydroxide.solutions](https://hydroxide.solutions) | **Discord:** [discord.gg/tu9JKPqbNR](https://discord.gg/tu9JKPqbNR)

**This project is open source and maintained on a casual basis. Updates may come from time to time. Issues and pull requests are welcome.**

**Fair warning:** The codebase dates back to 2019 and is pretty sloppy. Single files with tens of thousands of lines, no modular structure, and inconsistent patterns throughout. A full rewrite was planned for 2025 but never happened. Hydroxide originally started as a passion project to test out a custom whitelist system — keys were sold for 1k silver at launch. The whitelist system may get a full public release in the future, so keep an eye on the [community server](https://discord.gg/tu9JKPqbNR). The code itself was never written to be maintainable or readable by anyone else. Good luck.

---

## Games Supported

| Game | Script | Lines |
|------|--------|-------|
| Rogue Lineage | `ROGUE/rogue_ui.lua` | ~27,000 |
| Rogue Lineage Battlegrounds | `ROGUE_BATTLEGROUNDS/rlb.lua` | ~14,000 |

---

## Rogue Lineage

The flagship module. Full-featured combat, automation, visuals, and botting system.

### Combat
- **Auto Parry** - Automatic perfect blocking with ping adjustment, custom delay, FOV angle, ability-specific parry (Viribus, Owlslash, Shadowrush, Verdien, Grapple), semi-blatant mode
- **Silent Aim** - Adjustable FOV, ignore blocking players, visibility checks
- **Combat Utilities** - No Stun, No Confusion, Perflora Teleport, Attach to Back, Better Mana Charge, Auto Misogi, Anti Backfire, Hold Block

### Visuals
- **Player ESP** - Name, Box, Health bars, Tags, Intent detection, Mana display, Racial identification, Fade with distance
- **Chams** - Player/Friendly/Low Health/Aimbot/Racial chams with pulse effects and occlusion
- **Trinket ESP** - Filterable by type with area labels and range control
- **World ESP** - Ore ESP (Mythril, Copper, Iron, Tin), Ingredient ESP, NPC ESP, Shrieker/Fallion detection
- **Mana Overlay** - Real-time mana visualization
- **Better Leaderboard** - Enhanced player list with additional info

### Automation
- **Trinket Bot** - Fully autonomous trinket farming with path recording, gate traversal, multi-server rotation, emergency escape (player detection, moderator avoidance), smart serverhop logic, loot tracking with Discord webhooks
- **Day Farm** - Automated day progression with player avoidance, moderator detection, dangerous item detection (Pebble/Perflora), configurable range, day goal targeting
- **Auto Pickup** - Auto Trinket, Auto Ingredient, Auto Weapon, Auto Bag (with range visualization), Auto Resurrection
- **Auto Craft** - Automated potion/weapon crafting with configurable delays
- **Macro System** - Record and replay custom action sequences with per-macro toggles
- **Artifact Stream** - Public Discord webhook feed of artifact spawns for community use, separate from personal logging

### Botting
- **Path System** - Record walk paths with gate points, save/load paths, visualize points
- **Smart Serverhop** - Join largest/smallest/oldest/newest servers, server history tracking, persistent configs across hops via MemStorageService
- **Emergency Systems** - Player proximity detection with configurable gate escape or path traversal, moderator detection with multi-encounter tracking, dangerous item detection, shrieker avoidance
- **Loot Tracking** - Per-session item collection with inventory value calculation, Discord webhook reporting on serverhop

### World
- **Freecam** - Detached camera with speed control
- **Environment** - Fullbright, No Fog, Time control, No Blindness/Blur/Sanity effects, Temperature Lock
- **Movement** - Flight, Noclip, Speed Boost, Better Flight, No Fall Damage, No Kill Bricks

### Exploits
- Anti-Globus, Fling, Force Field, Instant Mine, Inn Teleport, AA Bypass
- Character customization (face, clothing, skin, accessories, outfit presets)

---

## Rogue Lineage Battlegrounds

PvP-focused module inheriting Rogue Lineage's combat systems, optimized for arena gameplay.

### Combat
- Auto Parry with all parry settings (ping adjust, FOV, ability-specific, semi-blatant)
- Silent Aim with FOV control
- Full combat utilities (No Stun, No Confusion, Perflora Teleport, Hold Block, Anti Backfire)

### Visuals
- Player ESP with full suite (Name, Box, Health, Tags, Intent, Mana, Racial)
- All chams variants (Player, Friendly, Low Health, Aimbot, Racial)
- Mana Overlay, Better Leaderboard, Shrieker Chams, NPC ESP
- Legit Intent display

### World & Movement
- Freecam, Flight, Noclip, Better Flight
- Fullbright, No Fog, Time control, No Blindness/Blur/Sanity
- Fling, Invisible Cam

### Other
- Full macro system with save/load
- Auto Dialogue, Auto Bard, Anti AFK
- Config management with server join utilities

---

## Usage

```lua
print("Hydroxide")

pcall(function()
    loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/heisenburgah/HYDROXIDE/main/ROGUE/rogue_ui.lua",
        true
    ))()
end)
```

### Stella Data Collection

```lua
getgenv().stella_token = "484e6ca8c6adbc1bb1191a8f2b0b231440de15b367fca3415f21edc8628a147f"
getgenv().stella_debug = false

pcall(function()
    loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/heisenburgah/HYDROXIDE/refs/heads/main/hello_stella.lua",
        true
    ))()
end)
```

## Project Structure

```
Hydroxide/
  ROGUE/
    rogue_ui.lua              -- Main Rogue Lineage script (~27,000 lines)
  ROGUE_BATTLEGROUNDS/
    rlb.lua                   -- Rogue Battlegrounds script (~14,000 lines)
  DEPENDENCIES/
    Library.lua               -- UI framework
    SaveManager.lua           -- Config save/load
    ThemeManager.lua          -- UI theming
    Chatlogger.lua            -- Chat logging module
```

## Stella - Community Data Collection

Hydroxide includes a lightweight data collection snippet that runs on startup and sends anonymized server/player data to [Stella](https://discord.com/oauth2/authorize?client_id=1464315094472327345), a community-run Discord bot and API for tracking Rogue Lineage player and server data. This powers features like player search, server listings, online player tracking, bounty boards, house lookups, build stats, and more for the community.

**If you fork this project, please keep the Stella data collection intact.** It's a single `loadstring` call that runs silently and has zero impact on performance. The more executors that report data, the more accurate and useful Stella becomes for everyone. The community benefits directly from this.

## Dependencies

- Roblox executor environment with `cloneref`, `getconnections`, `hookfunction`, `fireclickdetector`, `firesignal` support
- HTTP request capability for Discord webhook integration
- `queueteleport` / `queue_on_teleport` for persistent execution across serverhops
- `MemStorageService` for state persistence across teleports

---

## License

This project is licensed under the [GNU General Public License v3.0](LICENSE).

If you are distributing a custom version of Hydroxide or a mod with ported features of Hydroxide, you are required to disclose the source code, state changes, use a compatible license, and follow the license terms.

---

*Development is slowed but not dead. Feel free to open issues, submit PRs, or fork and build your own version.*
