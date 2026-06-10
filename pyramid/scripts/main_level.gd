extends Node2D

@onready var time_label     = $UI/TimeLabel
@onready var score_label    = $UI/ScoreLabel
@onready var game_timer     = $GameTimer
@onready var player_light   = $Player/PointLight2D
@onready var inv_label      = $UI/InventoryLabel
@onready var pickup_label   = $UI/PickupLabel
@onready var torch_node     = $TorchFollow
@onready var canvas_mod     = $CanvasModulate

var _pickup_timer : float = 0.0
var _game_over    : bool  = false
var _full_time    : float = 60.0

func _ready() -> void:
	# Full torch time – base for brightness (independent of timer changes)
	_full_time = game_timer.wait_time
	# The old player light replaced by the torch
	player_light.visible = false
	# Enable darkness – the torch is now the only light source
	canvas_mod.visible = true

	add_to_group("hud")
	Inventory.reset()
	Inventory.inventory_changed.connect(_update_inventory_hud)
	if pickup_label:
		pickup_label.visible = false
	_update_inventory_hud()

	# Connect the wall lanterns
	call_deferred("_connect_lanterns")

func _connect_lanterns() -> void:
	for lantern in get_tree().get_nodes_in_group("wall_lanterns"):
		if not lantern.lantern_activated.is_connected(_on_lantern_activated):
			lantern.lantern_activated.connect(_on_lantern_activated)

func _process(delta: float) -> void:
	var time_ratio : float = clampf(game_timer.time_left / _full_time, 0.0, 1.0)
	time_label.text = "Time: " + str(int(game_timer.time_left))
	if score_label:
		score_label.text = "Score: " + str(GameState.score)
	if torch_node:
		torch_node.set_light_ratio(time_ratio)

	if _pickup_timer > 0.0:
		_pickup_timer -= delta
		if _pickup_timer <= 0.0 and pickup_label:
			pickup_label.visible = false

func _on_lantern_activated() -> void:
	# Reset the game timer – the torch burns at full brightness again
	game_timer.stop()
	game_timer.start(_full_time)
	if torch_node:
		torch_node.reset_torch()

func _update_inventory_hud() -> void:
	if not inv_label:
		return
	var items := []
	if Inventory.has_torch:  items.append("🔦 Torch")
	if Inventory.has_pistol: items.append("⚔️ Club")
	if Inventory.has_rope:   items.append("🨢 Rope")
	if Inventory.has_key:    items.append("🗝 Key")
	inv_label.text = "\n".join(items)

# Called by ItemPickup through the "hud" group
func show_pickup(message: String) -> void:
	if not pickup_label:
		return
	pickup_label.text    = message
	pickup_label.visible = true
	_pickup_timer        = 2.5

func _on_game_timer_timeout() -> void:
	if _game_over:
		return
	_game_over = true
	print("Out of time! You lose!")
	GameState.finish_game(false)

func _on_sarcophagus_activated(is_fake: bool) -> void:
	if is_fake:
		var tr := get_node_or_null("traproom")
		if tr:
			tr._activate()
	else:
		if _game_over:
			return
		_game_over = true
		# Win bonus + remaining time bonus
		GameState.add_score(500 + int(game_timer.time_left) * 10)
		time_label.text = "🏆 You win!"
		GameState.finish_game(true)
