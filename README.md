# Shadow of the Pyramid

A 2D action-exploration game. A treasure hunter descends into a dark pyramid in
search of the real sarcophagus before his only torch burns out. Along the way he
must find a key, open a locked door, fight through a spider corridor, and avoid
mummies and fake sarcophagi.

## Gameplay

<!-- TODO: gameplay GIF goes here -->
<!-- ![Gameplay](docs/gameplay.gif) -->
*A gameplay GIF will be added here.*

## Controls
* **W, A, S, D** or **Arrow keys** – Move, jump, and climb ladders/ropes.
* **Space** or **Left Mouse Button** – Club attack (mummies, spiders). Hits enemies
  on both the left and right side.
* **E** – Interact (open the door with the key, activate a sarcophagus).
* **Up (W / ↑) at a ladder** – Climb on / drop off.

Items (key, rope) are picked up automatically when you walk into them.

## Goal
1. **Find the key** hidden in the pyramid.
2. **Open the locked door** with the key (press **E**).
3. **Fight through the spider corridor** – smash the spiders hanging on their webs
   with the club.
4. **Reach the real sarcophagus** before the torch goes out (timer). Beware of
   **fake sarcophagi** (they release mummies) and wandering **mummies**.
5. Score **as high as possible** and make it onto the **leaderboard**.

## Scoring
| Action | Points |
| --- | --- |
| Pick up the key | +75 |
| Pick up the rope | +50 |
| Open the door with the key | +100 |
| Defeat a mummy | +25 |
| Defeat a spider | +40 |
| Win (real sarcophagus) | +500 plus +10 for every second of remaining time |

## Technology & Architecture
* **Engine:** Godot Engine 4.x
* **Language:** GDScript
* **Physics/Movement:** `CharacterBody2D`
* **Graphics/Level:** `TileMapLayer` layers (background, collisions, objects, foreground).
* **Lighting:** `CanvasModulate` (darkness) + a `PointLight2D` torch with shadows
  and `LightOccluder2D` in the TileMap.
* **Game state:** Autoloads – `Inventory` (items) and `GameState` (score, leaderboard,
  saving to disk at `user://highscores.save`, transitions between screens).
* **UI screens:** `main_menu.tscn` (menu) and `end_screen.tscn` (end screen) – `Control` nodes.

## Key components
* `scripts/game_state.gd` – singleton: scoring, leaderboard (real + "fake" entries),
  save/load, `finish_game()` switching to the end screen.
* `scenes/main_menu.tscn` + `scripts/main_menu.gd` – main menu (Play / instructions /
  goal / Quit) with a generated background. Set as the project's start scene.
* `scenes/end_screen.tscn` + `scripts/end_screen.gd` – end screen: score with a count-up
  animation, a pop-up panel, and the leaderboard with the player's row highlighted.
* `scenes/key_door.tscn` + `scripts/key_door.gd` – a working door opened with the key.
* `scenes/spider.tscn` + `scripts/spider.gd` – a simple spider hanging on a web; it
  gently sways in place and dies from a club hit (falls and fades out).
* `scripts/mummy.gd` – a mummy that walks toward the player and shares the spider's
  fall-and-fade death animation.

> Note: the positions of the door (`LockedDoors`) and the spiders (`SpiderCorridor`)
> in `main_level.tscn` are placed approximately along the corridor behind the locked
> door and can be fine-tuned in the Godot editor.

## Project Roadmap

The list below shows the project's milestones (Checkpoints).

### Checkpoint 1: Environment & Base (Setup)
- [X] Create a GitHub repository with a proper Godot `.gitignore`.
- [X] Initialize the project in Godot Engine 4.x.
- [X] Create the folder structure (`assets`, `scenes`, `scripts`).
- [X] Download placeholder graphics.

### Checkpoint 2: Character Movement (Player)
- [X] Create the player scene (`player.tscn`) based on a `CharacterBody2D` node.
- [X] Add a collision shape for the player (`CapsuleShape2D`).
- [X] Write the `player.gd` script – smooth movement, jump, climbing.
- [X] Hook up the animated character graphics.

### Checkpoint 3: Maze Architecture (Environment)
- [X] Configure the `TileMapLayer` layers (background, collisions, objects, foreground).
- [X] Configure the physics layer in the TileMap (wall collisions).
- [X] Draw the pyramid layout.
- [X] Test player movement across the level.

### Checkpoint 4: Darkness & Light Mechanics (Core Gameplay)
- [X] Add a `CanvasModulate` node that darkens the map.
- [X] Player torch (`PointLight2D` + `torch` node).
- [X] Shadows / torch light fading over time.
- [X] Wall lanterns that refill the torch.

### Checkpoint 5: Game Loop – Goal & Time (Game Loop)
- [X] Sarcophagus scenes (real / fake) with an activation signal.
- [X] A `Timer` node counting down the torch's time.
- [X] UI showing the time and the score.
- [X] WIN / LOSE logic leading to the end screen.

### Checkpoint 6: Key, Doors & Enemies
- [X] Collecting items (key, rope) into the inventory.
- [X] **Working key/door mechanism** – one key opens the locked door (E).
- [X] Mummies coming out of the fake sarcophagus (trap room).
- [X] **Spiders hanging on webs** in the corridor behind the door – killed by the club.
- [X] Shared `enemies` group and club-attack handling for both mummies and spiders.

### Checkpoint 7: Menu, Score & Leaderboard
- [X] **Main menu** (Play, controls instructions, goal, quit).
- [X] **Scoring system** for items, enemies, opening the door, and winning.
- [X] **End screen** with the score, a pop-up animation, and a count-up.
- [X] **Leaderboard** ("fake" top entries + the saved player score, highlighted row).
- [X] Save the best scores to disk (`user://highscores.save`).

### Checkpoint 8: Release
- [X] Consistent game loop: Menu → Level → End screen → Menu / Restart.
- [ ] Export the game to an executable (`.exe`) or a web build (HTML5/Web).
- [ ] Final commit to the GitHub repository and submit the project for review.
