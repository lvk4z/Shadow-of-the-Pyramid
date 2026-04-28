extends CharacterBody2D
# -------------------------------------------------------
#  Mummy – przeciwnik poruszający się w kierunku gracza
# -------------------------------------------------------

@export var speed     : float = 80.0
@export var max_hp    : int   = 1
@export var damage    : int   = 1   # obrażenia dla gracza (przyszłość)

var hp        : int   = max_hp
var gravity   : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var _player   : Node2D = null

signal died

func _ready() -> void:
	hp = max_hp
	add_to_group("mummies")
	# Szukamy gracza
	await get_tree().process_frame
	_player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if _player:
		var dir = sign(_player.global_position.x - global_position.x)
		velocity.x = dir * speed

	move_and_slide()

func take_damage(amount: int) -> void:
	hp -= amount
	# Prosta informacja wizualna
	modulate = Color(1.5, 0.3, 0.3)
	var t = get_tree().create_timer(0.15)
	t.timeout.connect(_reset_color)
	if hp <= 0:
		die()

func _reset_color() -> void:
	modulate = Color(1, 1, 1)

func die() -> void:
	emit_signal("died")
	queue_free()
