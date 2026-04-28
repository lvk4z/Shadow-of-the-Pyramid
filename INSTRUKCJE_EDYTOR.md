# Shadow of the Pyramid – Instrukcje ręcznej konfiguracji w edytorze Godot

---

## KROK 0 – Pierwsze uruchomienie po zmianach kodu

1. Otwórz projekt w Godot.
2. Poczekaj, aż edytor zaimportuje zasoby (kręci się kółko na dole).
3. **Project → Project Settings → Autoload** – sprawdź, czy na liście widnieje `Inventory` z plikiem `res://scripts/inventory.gd`. Jeśli nie: kliknij „+", wpisz ścieżkę, nadaj nazwę `Inventory`, zaznacz „Enable", kliknij Add.
4. **Project → Project Settings → Input Map** – sprawdź, czy istnieją akcje `shoot` (Spacja lub LPM) i `interact` (E). Jeśli nie: kliknij „Add New Action", wpisz nazwę, kliknij „+", naciśnij klawisz.

---

## KROK 1 – Przypisz bullet_scene do gracza

Otwórz scenę `player.tscn` (lub znajdź węzeł **Player** w `main_level.tscn`).
1. Zaznacz węzeł **Player**.
2. W panelu **Inspector** (prawy panel) znajdź sekcję skryptu.
3. Pole **Bullet Scene** → kliknij ikonkę folderu → wybierz `res://scenes/bullet.tscn`.
4. Zapisz scenę (Ctrl+S).

---

## KROK 2 – Dodaj węzły UI do HUD (InventoryLabel, PickupLabel)

Otwórz `main_level.tscn`. W drzewie sceny znajdź węzeł **UI** (CanvasLayer lub Control).

1. Kliknij prawym na **UI** → **Add Child Node** → szukaj `Label` → dodaj.  
   - Zmień nazwę na `InventoryLabel`.
   - Inspector: **Position** = `(20, 200)`, **Size** = `(300, 200)`.
   - Zakładka **Theme Overrides → Font Sizes → Font Size** = `22`.

2. Ponownie kliknij prawym na **UI** → **Add Child Node** → `Label`.  
   - Zmień nazwę na `PickupLabel`.
   - Inspector: **Position** = `(700, 40)`, **Size** = `(500, 50)`.
   - **Horizontal Alignment** = Center.
   - **Font Size** = `28`.
   - Możesz ustawić kolor tekstu na żółty (Theme Overrides → Font Color).

3. Zapisz scenę.

---

## KROK 3 – Pokoje – ogólna zasada budowania

Każdy pokój to obszar wybudowany Tilemap (już istnieje). Musisz **dodać logiczne węzły** nad kafelkami.  
Dla czytelności: stwórz węzeł **Node2D** o nazwie pokoju jako dziecko sceny i umieszczaj w nim powiązane elementy.

---

## KROK 4 – Pokój PUŁAPKA (czerwony pokój nr 1)

### 4a – Utwórz węzeł TrapRoom
1. Kliknij prawym na korzeń sceny → **Add Child Node** → `Node2D`.
2. Zmień nazwę na `TrapRoom_Pulapka`.
3. W Inspector → **Script** → przypisz `res://scripts/trap_room.gd`.
4. W Inspector ustaw **Mummy Scene** = `res://scenes/mummy.tscn`.

### 4b – Drzwi lewe (DoorLeft)
1. Kliknij prawym na `TrapRoom_Pulapka` → **Add Child Node** → `StaticBody2D`.
2. Zmień nazwę na `DoorLeft`.
3. Dodaj do niego dzieci:
   - `CollisionShape2D` → kształt: `RectangleShape2D`, rozmiar ~`(20, 200)`.
   - `Sprite2D` → tekstura: dowolna ciemna (np. icon.svg), skaluj by wyglądała jak drzwi.
4. Ustaw pozycję DoorLeft **na wejściu lewym** pokoju Pułapka.
5. Tak samo zrób dla `DoorRight` po prawej stronie pokoju.

### 4c – Trigger wejścia do pokoju
1. Dodaj dziecko `Area2D` do `TrapRoom_Pulapka`, nazwij `TriggerArea`.
2. Dodaj `CollisionShape2D` → kształt obejmujący cały pokój Pułapka.
3. W węźle `TrapRoom_Pulapka` podłącz sygnał:
   - Zaznacz `TrapRoom_Pulapka`, przejdź na zakładkę **Node → Signals**.
   - Dwukliknij wpis `body_entered` z `TriggerArea` LUB:
   - Zaznacz `TriggerArea` → Signals → `body_entered` → podłącz do `TrapRoom_Pulapka` metoda `_on_trigger_entered`.

   > **Ważne:** Upewnij się, że `TriggerArea` ma **Monitorable** = true i Layer/Mask odpowiednio ustawione (Layer 1 = świat, Mask 1 = gracz).

### 4d – Punkty spawnów mumii
1. Dodaj węzeł `Node2D` jako dziecko `TrapRoom_Pulapka`, nazwij `MummySpawns`.
2. Dodaj 2–3 węzły `Node2D` jako dzieci `MummySpawns` (nazwij np. `Spawn1`, `Spawn2`).
3. Przesuń każdy `Spawn_x` na odpowiednie miejsce wewnątrz pokoju.

### 4e – Collision Layer gracza
- Gracz powinien być na **Layer 1**, mumie na **Layer 2**, pociski na **Layer 4**.  
- W `player.tscn`: Inspector → `CollisionLayer` = 1, `CollisionMask` = 2 (żeby blokować go ściany i mumie).  
- W `mummy.tscn`: `CollisionLayer` = 2, `CollisionMask` = 1.  
- W `bullet.tscn`: `CollisionLayer` = 4, `CollisionMask` = 2.

---

## KROK 5 – Pokój FAŁSZYWY GRÓB (czerwony pokój nr 2)

Powtórz dokładnie KROK 4 dla drugiego czerwonego pokoju (Fałszywy Grób), tworząc węzeł `TrapRoom_FalszywyGrob` z tymi samymi dziećmi (DoorLeft, DoorRight, TriggerArea, MummySpawns).

---

## KROK 6 – Przedmiot: LINA (Skrytka lewa)

1. Kliknij prawym na korzeń → **Add Child Node** → `Area2D`.
2. Zmień nazwę na `Pick_Lina`.
3. Dodaj dziecko `CollisionShape2D` → kształt `CircleShape2D`, radius ~30.
4. Dodaj dziecko `Sprite2D` → tekstura: `icon.svg` (placeholder – zastąp ikoną liny).
5. Przypisz skrypt: Inspector → **Script** → `res://scripts/item_pickup.gd`.
6. Inspector: **Item Type** = `rope`, **Label Text** = `Lina`.
7. Umieść węzeł w lewej Skrytce (tam gdzie na mapie ikona pudełka).

---

## KROK 7 – Przedmiot: KLUCZ (Skrytka prawa dolna)

Powtórz KROK 6, ale:
- Nazwa: `Pick_Klucz`
- **Item Type** = `key`, **Label Text** = `Klucz`
- Umieść w dolnej prawej Skrytce (ikona klucza na mapie).

---

## KROK 8 – SZYB z liną (RopeAnchor)

Szyb to pionowe przejście do dolnej Skrytki z kluczem. Gracz może tam zejść liną.

1. Kliknij prawym na korzeń → **Add Child Node** → `Node2D`.
2. Zmień nazwę na `RopeAnchor`.
3. Przypisz skrypt: `res://scripts/rope_anchor.gd`.
4. Dodaj dzieci:

   **a) InteractArea** – strefa wykrywania gracza przy krawędzi szybu:
   - `Area2D` → nazwij `InteractArea`
   - Dodaj `CollisionShape2D` → `RectangleShape2D` ~`(100, 100)`
   - Ustaw Layer/Mask: Mask = 1 (gracz)

   **b) HintLabel** – wskazówka dla gracza:
   - `Label` → nazwij `HintLabel`
   - Tekst: `E – Rozwiń linę`
   - Pozycja powyżej krawędzi szybu, Font Size = 20
   - Visible = false (skrypt zarządza widocznością)

   **c) RopeLadder** – Area2D działająca jak drabina po rozwinięciu liny:
   - `Node2D` → nazwij `RopeLadder`
   - Dodaj dziecko `Area2D` → dodaj do **grupy** `ladders` (zaznacz, Inspector → Group → dodaj `ladders`)
   - Dodaj `CollisionShape2D` → `RectangleShape2D` ~`(40, 300)` (wysokość szybu)
   - Ustaw Layer/Mask: Mask = 1 (gracz)
   - Visible = false (skrypt ustawi true po rozwinięciu)

5. Umieść `RopeAnchor` na krawędzi szybu w pobliżu Sali Kolumnowej.

---

## KROK 9 – DRZWI NA KLUCZ (przed Sarkofagiem)

1. Kliknij prawym na korzeń → **Add Child Node** → `StaticBody2D`.
2. Zmień nazwę na `KeyDoor`.
3. Przypisz skrypt: `res://scripts/key_door.gd`.
4. Dodaj dzieci:

   **CollisionShape2D** – kolizja samych drzwi:
   - `CollisionShape2D` → `RectangleShape2D` ~`(30, 150)`

   **Sprite2D** – wizualizacja drzwi:
   - `Sprite2D` → tekstura: dowolna (np. ciemny prostokąt, zastąp później)
   - Skaluj by pokryć CollisionShape

   **InteractArea** – strefa aktywacji:
   - `Area2D` → nazwij `InteractArea`
   - `CollisionShape2D` → `RectangleShape2D` ~`(120, 160)`
   - Mask = 1 (gracz)

   **HintLabel** – wskazówka:
   - `Label` → nazwij `HintLabel`
   - Pozycja powyżej drzwi, Visible = false

5. Umieść `KeyDoor` na wejściu do pokoju z Sarkofagiem (pod drabiną przy Sanktarium).

---

## KROK 10 – Collision Layer/Mask – tabela referencyjna

| Węzeł               | CollisionLayer | CollisionMask          |
|---------------------|---------------|------------------------|
| Player              | 1             | 1 (ściany), 2 (mumie)  |
| TileMap (ściany)    | 1             | brak (Static)          |
| Mummy               | 2             | 1 (ściany)             |
| Bullet              | 4             | 1 (ściany), 2 (mumie)  |
| Area2D pickup       | 8             | 1 (gracz)              |
| Ladder/RopeArea2D   | 16            | 1 (gracz)              |
| TriggerArea         | 32            | 1 (gracz)              |

> Godot 4: w Inspector Layer/Mask to przyciski bitowe. Bit 1=Layer1, Bit 2=Layer2 itd.

---

## KROK 11 – Sygnały do ręcznego podłączenia

| Węzeł źródłowy           | Sygnał           | Węzeł docelowy        | Metoda               |
|--------------------------|------------------|-----------------------|----------------------|
| `TriggerArea` (każdy)    | `body_entered`   | `TrapRoom_*`          | `_on_trigger_entered`|
| `Sarcophagus`            | `body_entered`   | `MainLevel`           | `_on_sarcophagus_body_entered` |

---

## KROK 12 – Weryfikacja i test

1. **Uruchom grę** (F5).
2. Sprawdź konsolę (`Output`) – nie powinno być błędów o brakujących @onready.
3. Naciśnij **Spację** lub **LPM** → gracz powinien strzelać, amunicja spada.
4. Wejdź do Pułapki → drzwi zamkną się, pojawią mumie.
5. Zestrzel mumie → drzwi otworzą się.
6. Wejdź do lewej Skrytki → podniesienie liny.
7. Podejdź do szybu, naciśnij **E** → lina rozwija się.
8. Wspinaj się liną (W/S).
9. Zejdź do dolnej Skrytki → podniesienie klucza.
10. Podejdź do drzwi Sarkofagu, naciśnij **E** → drzwi otworzą się.
11. Wejdź do pokoju Sarkofagu → wyświetli się `Wygrana!`.

---

## Podsumowanie co zostało zrobione automatycznie

| Plik | Co dodano |
|------|-----------|
| `scripts/inventory.gd` | Nowy – singleton śledzący przedmioty |
| `scripts/bullet.gd` | Nowy – pocisk |
| `scripts/mummy.gd` | Nowy – wróg (mumia) |
| `scripts/trap_room.gd` | Nowy – logika czerwonego pokoju |
| `scripts/item_pickup.gd` | Nowy – podnoszenie przedmiotów |
| `scripts/rope_anchor.gd` | Nowy – rozwijanie liny w szybie |
| `scripts/key_door.gd` | Nowy – drzwi na klucz |
| `scripts/player.gd` | Dodano strzelanie, grupę "player", śledzenie kierunku |
| `scripts/main_level.gd` | Dodano HUD ekwipunku, komunikat o podniesieniu |
| `scenes/bullet.tscn` | Nowy – scena pocisku |
| `scenes/mummy.tscn` | Nowy – scena mumii |
| `project.godot` | Dodano akcje `shoot` i `interact`, autoload `Inventory` |
