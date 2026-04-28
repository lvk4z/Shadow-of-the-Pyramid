extends Node2D
# -------------------------------------------------------
#  RopeAnchor – punkt zaczepienia liny nad szybem
#
#  Gracz (stojąc w InteractArea) naciska "interact" (E),
#  jeśli ma linę w ekwipunku.
#  Lina jest wdrożona raz na zawsze – potem działa jak drabina.
# -------------------------------------------------------

@export var rope_length  : float = 300.0  # piksele w dół

@onready var interact_area : Area2D   = $InteractArea
@onready var hint_label    : Label    = $HintLabel
@onready var rope_ladder   : Node2D   = $RopeLadder   # Node2D z Area2D (jak drabina)

var _player_nearby : bool = false
var _deployed      : bool = false

func _ready() -> void:
	interact_area.body_entered.connect(_on_player_enter)
	interact_area.body_exited.connect(_on_player_exit)
	# Lina początkowo niewidoczna i nieaktywna
	rope_ladder.visible = false
	_set_rope_collision(false)

func _process(_delta: float) -> void:
	if _player_nearby and not _deployed and Inventory.has_rope:
		hint_label.visible = true
		if Input.is_action_just_pressed("interact"):
			_deploy()
	else:
		hint_label.visible = false

func _deploy() -> void:
	_deployed = true
	rope_ladder.visible = true
	_set_rope_collision(true)
	hint_label.visible = false
	# Powiadom gracza, by podłączył nowe drabiny (Area2D liny)
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("_connect_ladders"):
		# Daj klatkę na dodanie Area2D do drzewa, potem połącz
		await get_tree().process_frame
		player._connect_ladders()

func _set_rope_collision(enabled: bool) -> void:
	for child in rope_ladder.get_children():
		if child is Area2D:
			for shape in child.get_children():
				if shape is CollisionShape2D:
					shape.disabled = not enabled

func _on_player_enter(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_nearby = true

func _on_player_exit(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_nearby = false
