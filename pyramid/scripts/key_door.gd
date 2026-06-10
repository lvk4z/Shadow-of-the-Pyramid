extends StaticBody2D
# -------------------------------------------------------
#  KeyDoor – a door opened with a key
#
#  The player (standing in InteractArea) presses "interact" (E)
#  if they have a key in their inventory.
# -------------------------------------------------------

@onready var interact_area    : Area2D           = $InteractArea
@onready var collision_shape  : CollisionShape2D = $CollisionShape2D
@onready var sprite           : Sprite2D         = $Sprite2D
@onready var hint_label       : Label            = get_node_or_null("HintLabel")

var _player_nearby : bool = false

func _ready() -> void:
	interact_area.body_entered.connect(_on_player_enter)
	interact_area.body_exited.connect(_on_player_exit)

func _on_player_enter(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_nearby = true

func _on_player_exit(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_nearby = false
		if hint_label:
			hint_label.visible = false

func _process(_delta: float) -> void:
	if hint_label:
		hint_label.visible = _player_nearby
	if _player_nearby and Inventory.has_key and Input.is_action_just_pressed("interact"):
		_open()

func _open() -> void:
	collision_shape.disabled = true
	if hint_label:
		hint_label.visible = false
	set_process(false)
	# Score bonus for opening the door with a key
	GameState.add_score(100)
	# Opening animation – the door "escapes" upward and disappears
	var tween := create_tween()
	tween.tween_property(sprite, "position:y", sprite.position.y - 220.0, 0.5) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(sprite, "modulate:a", 0.0, 0.5)
	tween.tween_callback(func(): sprite.visible = false)
