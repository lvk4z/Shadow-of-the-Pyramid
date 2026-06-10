extends Node2D
# -------------------------------------------------------
#  Torch – follows the player, dims over time
#
#  The main scene keeps it as a separate node and calls:
#    set_light_ratio(ratio)  – 0.0 = dark, 1.0 = full brightness
#    reset_torch()           – restore full brightness
# -------------------------------------------------------

@export var follow_speed  : float = 5.0   # speed of following the player
@export var bob_speed     : float = 2.8   # bobbing frequency
@export var bob_amount    : float = 3.5   # bobbing amplitude in px

@onready var _light        : PointLight2D = $TorchLight
@onready var _flame_outer  : Polygon2D    = $FlameOuter
@onready var _flame_mid    : Polygon2D    = $FlameMid
@onready var _flame_core   : Polygon2D    = $FlameCore
@onready var _handle       : Polygon2D    = $Handle
@onready var _wrap         : Polygon2D    = $Wrap

var _player        : Node2D  = null
var _time          : float   = 0.0
var _facing_dir    : float   = 1.0   # 1 = in front of a player walking right
var _light_ratio   : float   = 1.0

# stored starting values from the inspector
var _max_energy        : float = 1.2
var _max_texture_scale : float = 2.0

func _ready() -> void:
	add_to_group("torch")
	_player = get_tree().get_first_node_in_group("player")
	if _player:
		global_position = _player.global_position + Vector2(-22.0, -15.0)
	_max_energy        = _light.energy
	_max_texture_scale = _light.texture_scale

func _process(delta: float) -> void:
	if not is_instance_valid(_player):
		_player = get_tree().get_first_node_in_group("player")
		if not _player:
			return

	_time += delta

	# Direction in front of the player – if standing still, keep the last one
	var vx : float = _player.velocity.x
	if abs(vx) > 10.0:
		_facing_dir = sign(vx)   # the torch is IN FRONT of the player

	var target_offset := Vector2(_facing_dir * 24.0, -16.0)
	var target_pos    := _player.global_position + target_offset

	# Smooth following (slight delay = "floating" effect)
	global_position = global_position.lerp(target_pos, follow_speed * delta)

	# Flame bobbing
	var bob : float = sin(_time * bob_speed) * bob_amount
	_flame_outer.position.y = bob
	_flame_mid.position.y   = bob
	_flame_core.position.y  = bob - 1.5

	# Light flicker
	var f1 : float = sin(_time * 11.3) * 0.06
	var f2 : float = sin(_time * 7.1)  * 0.04
	var flicker : float = 1.0 + f1 + f2

	var r : float = _light_ratio
	_light.energy        = _max_energy * r * flicker
	_light.texture_scale = _max_texture_scale * max(0.15, r)

	# Fading of the flame color
	var a : float = max(0.15, r)
	_flame_outer.color = Color(1.0,       0.35 + 0.25 * a,  0.0,  a)
	_flame_mid.color   = Color(1.0,       0.7  + 0.2  * a,  0.0,  a)
	_flame_core.color  = Color(1.0,       0.95,              0.5,  a)

	# Handle/wrap a bit darker as it dims
	var handle_a : float = max(0.4, r)
	_handle.color = Color(0.35, 0.19, 0.08, handle_a)
	_wrap.color   = Color(0.48, 0.31, 0.06, handle_a)

# Called from main_level.gd every frame
func set_light_ratio(ratio: float) -> void:
	_light_ratio = clampf(ratio, 0.0, 1.0)

# Called when the player lights a wall lantern
func reset_torch() -> void:
	_light_ratio = 1.0
