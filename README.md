# Shadow-of-the-Pyramid

Gra zręcznościowo-eksploracyjna. Poszukiwaczem skarbów, wchodzi w głąb ciemnej piramidy i szuka starożytnego sarkofagu, zanim zgaśnie jego jedyna pochodnia.

## Uruchomienie

## 🎮 Sterowanie
* **W, A, S, D** lub **Strzałki** - Poruszanie się postacią.
* **ESC** - Pauza / Wyjście do menu.
* **R** - Szybki restart poziomu.

## 🛠 Technologie i Architektura
* **Silnik:** Godot Engine 4.x
* **Język:** GDScript
* **Fizyka/Ruch:** `CharacterBody2D` (płynny ruch wektorowy).
* **Grafika/Poziom:** Oparta o węzły `TileMap` / `TileMapLayer` z warstwą nawigacyjną i kolizyjną.
* **System Światła:** Dynamiczne cienie w czasie rzeczywistym realizowane z użyciem `CanvasModulate` (symulacja ciemności), `PointLight2D` z włączonymi cieniami oraz `LightOccluder2D` wewnątrz TileMapy.
