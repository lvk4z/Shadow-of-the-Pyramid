extends Node2D

@onready var time_label    = $UI/TimeLabel
@onready var game_timer    = $GameTimer
@onready var player_light  = $Player/PointLight2D
@onready var inv_label     = $UI/InventoryLabel
@onready var pickup_label  = $UI/PickupLabel

var max_light_scale  = 1.0
var max_light_energy = 1.0
var _pickup_timer    : float = 0.0

func _ready() -> void:
	max_light_energy = player_light.energy
	max_light_scale  = player_light.texture_scale
	add_to_group("hud")
	Inventory.reset()
	Inventory.inventory_changed.connect(_update_inventory_hud)
	if pickup_label:
		pickup_label.visible = false
	_update_inventory_hud()

func _process(delta: float) -> void:
	time_label.text = "Czas: " + str(int(game_timer.time_left))
	var time_ratio = game_timer.time_left / game_timer.wait_time
	player_light.texture_scale = max(0.2, max_light_scale * time_ratio)
	player_light.energy        = max(0.3, max_light_energy * time_ratio)

	# Ukryj komunikat o podniesieniu
	#if _pickup_timer > 0.0:
#0		_pickup_timer -= delta
		#if _pickup_timer <= 0.0 and pickup_label:
			#pickup_label.visible = false

func _update_inventory_hud() -> void:
	if not inv_label:
		return
	var items := []
	if Inventory.has_torch:  items.append("🔦 Pochodnia")
	if Inventory.has_pistol: items.append("🔫 Pistolet")
	if Inventory.has_rope:   items.append("🪢 Lina")
	if Inventory.has_key:    items.append("🗝 Klucz")
	inv_label.text = "\n".join(items)

# Wywoływane przez ItemPickup przez grupę "hud"
func show_pickup(message: String) -> void:
	if not pickup_label:
		return
	pickup_label.text    = message
	pickup_label.visible = true
	_pickup_timer        = 2.5

func _on_game_timer_timeout() -> void:
	print("Koniec czasu! Przegrana!")
	get_tree().reload_current_scene()

func _on_sarcophagus_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Wygrana")
		time_label.text = "🏆 Wygrana!"
		get_tree().paused = true
