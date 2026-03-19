# Shadow-of-the-Pyramid

Gra zręcznościowo-eksploracyjna. Poszukiwacz skarbów, wchodzi w głąb ciemnej piramidy i szuka starożytnego sarkofagu, zanim zgaśnie jego jedyna pochodnia.

## Uruchomienie

## Sterowanie
* **W, A, S, D** lub **Strzałki** - Poruszanie się postacią.
* **SPACE** - Wykonanie akcji (otworzenie drzwi, podniesienie przedmiotu).
* **ESC** - Pauza / Wyjście do menu.
* **R** - Szybki restart poziomu.

## Technologie i Architektura
* **Silnik:** Godot Engine 4.x
* **Język:** GDScript
* **Fizyka/Ruch:** `CharacterBody2D`
* **Grafika/Poziom:** Oparta o węzły `TileMap` / `TileMapLayer` z warstwą nawigacyjną i kolizyjną.
* **System Światła:** Dynamiczne cienie w czasie rzeczywistym realizowane z użyciem `CanvasModulate` (symulacja ciemności), `PointLight2D` z włączonymi cieniami oraz `LightOccluder2D` wewnątrz TileMapy.

## Plan Rozwoju Projektu (Roadmap)

Poniższa lista przedstawia kolejne etapy (Checkpoints) powstawania gry.

### Checkpoint 1: Środowisko i Baza (Setup)
- [X] Utworzenie repozytorium GitHub z odpowiednim `.gitignore` dla Godota.
- [ ] Inicjalizacja projektu w Godot Engine 4.x.
- [ ] Stworzenie struktury folderów (`assets`, `scenes`, `scripts`).
- [ ] Pobranie placeholderów graficznych (np. z darmowych paczek Kenney.nl).

### Checkpoint 2: Poruszanie się postacią (Player)
- [ ] Stworzenie sceny gracza (`Player.tscn`) opartej na węźle `CharacterBody2D`.
- [ ] Dodanie kształtu kolizji dla gracza (`CapsuleShape2D`).
- [ ] Napisanie skryptu `player.gd` obsługującego płynny ruch w 8 kierunkach (Input wektorowy).
- [ ] Podpięcie prostej grafiki / kółka reprezentującego gracza.

### Checkpoint 3: Architektura Labiryntu (Environment)
- [ ] Stworzenie głównej sceny gry (`MainLevel.tscn`).
- [ ] Skonfigurowanie węzła `TileMapLayer` dla podłogi i ścian.
- [ ] Skonfigurowanie warstwy fizyki (Physics Layer) w TileMapie, aby ściany miały kolizje.
- [ ] Narysowanie pierwszego układu labiryntu.
- [ ] Przetestowanie, czy gracz poprawnie porusza się po labiryncie i nie przenika przez ściany.

### Checkpoint 4: Mechanika Ciemności i Światła (Core Gameplay)
- [ ] Dodanie węzła `CanvasModulate` do sceny poziomu, aby całkowicie zaciemnić mapę.
- [ ] Dodanie węzła `PointLight2D` (z teksturą gradientu) do sceny Gracza, służącego jako pochodnia.
- [ ] Włączenie "Shadows" (cieni) w węźle światła gracza.
- [ ] Dodanie wielokątów cieniowania (`LightOccluder2D`) do ścian w TileMapie, aby światło nie przenikało przez ściany labiryntu.

### Checkpoint 5: Pętla Gry - Cel i Czas (Game Loop)
- [ ] Stworzenie sceny Sarkofagu opartej na `Area2D` z sygnałem `body_entered`.
- [ ] Dodanie węzła `Timer` do głównej sceny, odliczającego czas do zera (np. 60 sekund).
- [ ] Stworzenie prostego UI (`CanvasLayer` + `Label`) wyświetlającego upływający czas.
- [ ] Oprogramowanie logiki: Jeśli gracz dotknie Sarkofagu przed upływem czasu -> ekran WYGRANA.
- [ ] Oprogramowanie logiki: Jeśli Timer wskaże 0 -> ekran PRZEGRANA.

### Checkpoint 6: Szlify i Audiowizualia (Polishing)
- [ ] Dodanie ekranu Menu Głównego (przycisk Start, Wyjście).
- [ ] Zaimplementowanie dźwięku tła (Ambient) oraz dźwięku kroków gracza.
- [ ] Podpięcie kamery (`Camera2D`) pod gracza z włączonym płynnym podążaniem (`Position Smoothing`).
- [ ] Balans rozgrywki: dostosowanie czasu trwania Timera i zasięgu światła pochodni.

### Checkpoint 7: Publikacja (Release)
- [ ] Ostateczne testy (Playtesty) - przejście gry od początku do końca.
- [ ] Eksport gry do pliku wykonywalnego (`.exe`) lub wersji przeglądarkowej (HTML5/Web).
- [ ] Finalny commit na repozytorium GitHub i oddanie projektu do oceny.
