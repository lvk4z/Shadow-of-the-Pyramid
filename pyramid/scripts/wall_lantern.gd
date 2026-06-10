extends Node2D
# -------------------------------------------------------
#  WallLantern – a wall-mounted lantern
#
#  The player walks into range and presses "interact" (E).
#  Emits the lantern_activated signal → main_level.gd resets the timer.
#  One-time – cannot be activated again after use.
# -------------------------------------------------------

signal lantern_activated

@onready var _hint  : Label        = $HintLabel
@onready var _area  : Area2D       = $InteractArea
@onready var _light : PointLight2D = $LanternLight
@onready var _glow  : Polygon2D    = $Glass

var _player_nearby : bool = false
var _used          : bool = false
var _time          : float = 0.0

func _ready() -> void:
	add_to_group("wall_lanterns")
	_area.body_entered.connect(_on_body_entered)
	_area.body_exited.connect(_on_body_exited)
	_hint.visible = false

func _process(delta: float) -> void:
	_time += delta

	# Steady, calm lantern flicker
	var flicker : float = 0.55 + sin(_time * 6.3) * 0.06 + sin(_time * 13.7) * 0.03
	_light.energy = flicker
	_glow.color = Color(1.0, 0.75, 0.2, 0.45 + sin(_time * 5.0) * 0.06)

	if _player_nearby and not _used:
		_hint.visible = true
		if Input.is_action_just_pressed("interact"):
			_activate()
	else:
		_hint.visible = false

func _activate() -> void:
	_used = true
	_hint.visible = false
	emit_signal("lantern_activated")

	# Lantern flash as feedback
	var tween := create_tween()
	tween.tween_property(_light, "energy", 3.5, 0.12)
	tween.tween_property(_light, "energy", 0.8, 1.5)
	# Set a brighter color after use
	_glow.color = Color(1.0, 0.95, 0.5, 0.75)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_nearby = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_nearby = false
