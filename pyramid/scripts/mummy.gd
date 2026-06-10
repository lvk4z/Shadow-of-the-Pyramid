extends CharacterBody2D
# -------------------------------------------------------
#  Mummy – an enemy that moves toward the player
# -------------------------------------------------------

@export var speed     : float = 80.0
@export var max_hp    : int   = 1
@export var damage    : int   = 1   # damage to the player (future)

var hp        : int   = max_hp
var gravity   : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var _player   : Node2D = null
var _dead     : bool   = false

signal died

func _ready() -> void:
	hp = max_hp
	add_to_group("mummies")
	add_to_group("enemies")
	# Look for the player
	await get_tree().process_frame
	_player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if _dead:
		return
	if not is_on_floor():
		velocity.y += gravity * delta

	if _player:
		var dir = sign(_player.global_position.x - global_position.x)
		velocity.x = dir * speed

	move_and_slide()

func take_damage(amount: int) -> void:
	if _dead:
		return
	hp -= amount
	# Simple visual feedback
	modulate = Color(1.5, 0.3, 0.3)
	var t = get_tree().create_timer(0.15)
	t.timeout.connect(_reset_color)
	if hp <= 0:
		die()

func _reset_color() -> void:
	if not _dead:
		modulate = Color(1, 1, 1)

func die() -> void:
	if _dead:
		return
	_dead = true
	remove_from_group("enemies")
	remove_from_group("mummies")
	velocity = Vector2.ZERO
	set_physics_process(false)
	GameState.add_score(25)
	emit_signal("died")
	# The mummy falls and fades out (same animation as the spider)
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", position.y + 400.0, 0.6) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate:a", 0.0, 0.6)
	tween.chain().tween_callback(queue_free)
