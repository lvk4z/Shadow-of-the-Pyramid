# Shadow of the Pyramid

<video src="pyramid/demo1.mp4" controls width="720"></video>

## 1. About the Game

**Shadow of the Pyramid** is a 2D action-platformer in which a treasure hunter descends into a dark ancient pyramid with a single torch, searching for the true sarcophagus before the flame burns out.

The game is built around two converging pressures: a **countdown timer** (the torch) that forces the player to move quickly, and **uncertainty** fake sarcophagi look identical to the real one and release mummies when opened. The player must find a key, unlock a door, fight through a spider-infested corridor, and make the right choice under time pressure.


---

## 2. Tools

| | |
|---|---|
| **Engine** | Godot Engine 4.x |
| **Scripting language** | GDScript |

---

## 3. Game Mechanics

### World
A single 2D side-scrolling level built with **TileMapLayer** (background, collision, objects, foreground layers). The world is bounded - a fixed pyramid layout with no procedural generation. The camera follows the player with a slight dead-zone.

### Darkness and the Torch
The level is permanently darkened by a **CanvasModulate** node. The player's torch (`PointLight2D`) is the primary — and initially only - light source. The torch dims in real time as the 60-second game timer counts down. When the timer reaches zero the player loses.

**Wall lanterns** are scattered around the level. Pressing **E** near one resets the timer to full and restores the torch to full brightness. Each lantern can only be used once.

### Player Character

| Attribute | Value |
|---|---|
| Movement speed | 200 px/s |
| Jump velocity | −500 px/s |
| Climb speed | 150 px/s |
| Club swing range | 65 px radius |
| Club cooldown | 0.22 s |

The player has no HP — any contact with an enemy is currently cosmetic (damage system is stubbed). The only way to lose is by running out of torch time.

### Movement
- **Run / jump** - standard platformer movement with separate acceleration (1800 px/s²) and braking (2400 px/s²) values for a responsive, snappy feel.
- **Ladders and ropes** - the player enters a climbing state by pressing Up or Down while touching a ladder/rope area. Gravity is suspended during climbing. Pressing Up while standing on the floor near a ladder performs a jump-dismount.

### Combat — Club
Pressing **Space** or **LMB** triggers a melee swing. The attack hits all nodes in the `enemies` group within `swing_range` pixels in front of the player. One hit kills any enemy. After the swing there is a 0.22 s cooldown.

### Enemies

**Mummy** (speed 80 px/s, 1 HP)
- Walks directly toward the player at all times.
- Released from fake sarcophagi when the player activates them.
- On death: falls and fades out with a tween animation; awards +25 points.

**Spider** (stationary, 1 HP)
- Hangs from a web thread, gently swaying. Does not chase the player.
- Blocks passage through the corridor behind the locked door.
- Must be killed with the club to proceed; awards +40 points.
- All spider visuals (body, legs, eyes, web thread) are drawn via `_draw()` in GDScript — no texture file.

### Items and Puzzles
Items are picked up automatically on contact.

### Scoring

| Action | Points |
|---|---|
| Pick up the key | +75 |
| Pick up the rope | +50 |
| Open the locked door | +100 |
| Kill a mummy | +25 |
| Kill a spider | +40 |
| **Win** (real sarcophagus) | +500 + **10 × seconds remaining** |

The leaderboard is seeded with seven fictional Egyptian-named entries so the player always has a table to compare against on the first run.

### Author's Tips
- Activate wall lanterns as you pass them — there is no penalty and they reset the full 60 seconds.
- Clear spiders quickly; the club cooldown is short enough to chain swings.
- Approach sarcophagi carefully — if mummies spawn, use the corridor walls to funnel them into easy swing range.

### UI
- **Top-left:** remaining time (seconds) and current score.
- **Below score:** inventory (icons for club, key, rope, torch).
- **Center-screen flash:** item pickup notification (2.5 s).

---

## 4. Assets

| Asset | Origin |
|---|---|
| `Egypt.png` — tileset / background | Imported from a free online source |
| `character-spritesheet.png` — player walk/jump/attack frames | Imported from a free sprite sheet |
| `—Pngtree—yellow mummy clip art_6065631.png` — mummy sprite | Imported from Pngtree (free clip art) |
| `sarcophagus.png` / `fake-sarcophagus.png` | Imported from free image sources |
| `keybg-removebg-preview.png` — key icon | Imported, background removed |
| `door-removebg-preview.png` — door sprite | Imported, background removed |
| `ladder.png` — ladder texture | Imported from a free source |
| `vector-pixel-art-rope-…png/.webp` — rope texture | Imported from a free vector/pixel art source |
| `torch.svg` — torch icon | Imported SVG |
| `PixelCharacter.svg` — alternate character asset | Imported SVG |
| **Torch flame, lanterns, spiders** | **Drawn procedurally in GDScript** |

---

## 5. Use of AI

- **Debugging:** identifying logic errors in the ladder/climbing state machine and the club swing hit-detection.
- **Procedural drawing:** the torch flame, spider body/web, and lantern glow polygons were designed with AI assistance — describing the desired shape in natural language and iterating on the `_draw()` output.
- **README and documentation:** 

---




