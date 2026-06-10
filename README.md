# Shadow of the Pyramid

A 2D action-platformer made in **Godot 4**. Descend into a dark pyramid, find the real sarcophagus, and get out before your torch burns out.

## How to Run

1. Open the project in **Godot Engine 4.x**.
2. Press **F5** (or click the Play button) to launch from the main menu.

## Controls

| Key | Action |
|-----|--------|
| A / D or ← / → | Move left / right |
| W / Space or ↑ | Jump |
| W / ↑ on a ladder or rope | Climb up |
| S / ↓ on a ladder | Climb down |
| Left Mouse Button or Space | Club attack |
| E | Interact (open door, activate sarcophagus) |

Items are picked up automatically by walking over them.

## Objective

1. Explore the pyramid and **find the key**.
2. Use the key to **open the locked door** (press **E** in front of it).
3. Fight through the **spider corridor** beyond the door.
4. **Open the correct sarcophagus** before the torch timer runs out — watch out for fake sarcophagi that spawn mummies.

## Scoring

| Action | Points |
|--------|--------|
| Pick up the key | +75 |
| Pick up the rope | +50 |
| Open the locked door | +100 |
| Kill a mummy | +25 |
| Kill a spider | +40 |
| Win (real sarcophagus) | +500 + 10 per second of torch remaining |

## Built With

- **Engine:** Godot 4.x
- **Language:** GDScript
