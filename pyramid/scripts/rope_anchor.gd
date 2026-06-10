extends Node2D
# -------------------------------------------------------
#  RopeAnchor – anchor point of a rope above a shaft
#
#  The player (standing in InteractArea) presses "interact" (E)
#  if they have a rope in their inventory.
#  The rope is deployed once and for all – then it works like a ladder.
#
#  Inspector settings:
#    rope_length – rope length in pixels (shaft height)
# -------------------------------------------------------

@export var rope_length  : float = 300.0  # pixels downward

@onready var interact_area : Area2D        = $InteractArea
@onready var hint_label    : Label         = $HintLabel
@onready var rope_ladder   : Node2D        = $RopeLadder   # Node2D with Area2D (like a ladder)
@onready var hole_cover    : StaticBody2D  = $HoleCover    # invisible floor – disabled after deploy

var _player_nearby : bool = false
var _deployed      : bool = false

func _ready() -> void:
	interact_area.body_entered.connect(_on_player_enter)
	interact_area.body_exited.connect(_on_player_exit)
	# The rope starts invisible and inactive
	rope_ladder.visible = false
	_set_rope_collision(false)
	# Adjust collision and visual size to rope_length
	_resize_rope()

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
	# Remove the invisible floor – now you can climb down
	if hole_cover:
		hole_cover.get_node("CollisionShape2D").disabled = true
	# Notify the player to connect the new ladders (the rope's Area2D)
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("_connect_ladders"):
		# Give a frame for the Area2D to be added to the tree, then connect
		await get_tree().process_frame
		player._connect_ladders()

func _resize_rope() -> void:
	# Set the CollisionShape based on rope_length
	for child in rope_ladder.get_children():
		if child is Area2D:
			for shape in child.get_children():
				if shape is CollisionShape2D and shape.shape is RectangleShape2D:
					shape.shape.size = Vector2(40, rope_length)
					shape.position   = Vector2(0, rope_length * 0.5)
	# Set the Line2D
	var line = rope_ladder.get_node_or_null("Line2D")
	if line:
		line.points = PackedVector2Array([Vector2(0, 0), Vector2(0, rope_length)])

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
