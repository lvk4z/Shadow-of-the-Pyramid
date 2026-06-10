extends CharacterBody2D

@export var SPEED         = 200.0
@export var JUMP_VEL      = -500.0
@export var CLIMB_SPEED   = 150.0
@export var swing_range   : float = 65.0
@export var swing_cooldown: float = 0.22

# Movement smoothing
@export var ACCEL         : float = 1800.0   # horizontal acceleration (px/s²)
@export var DECEL         : float = 2400.0   # horizontal braking (px/s²)
@export var AIR_ACCEL     : float = 900.0    # acceleration in the air
@export var RUN_ANIM_BASE_SPEED   : float = 1.0
@export var CLIMB_ANIM_BASE_SPEED : float = 1.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const ANIM_MOVE_LEFT  := &"move_left"
const ANIM_MOVE_RIGHT := &"move_right"
const ANIM_CLIMB      := &"climb"
const ANIM_JUMP_LEFT  := &"jump_left"
const ANIM_JUMP_RIGHT := &"jump_right"
const ANIM_ATTACK     := &"attack"

@onready var _anim: AnimatedSprite2D = $AnimatedSprite2D

# --- Ladder state ---
var _on_ladder   := false
var _is_climbing := false
var _climb_input_y: float = 0.0

# --- Club swing ---
var _facing       : float = 1.0
var _swing_timer  : float = 0.0
var _is_swinging  : bool  = false

func _ready() -> void:
	add_to_group("player")
	# Snap – the character doesn't "fall off" small tile edges
	floor_snap_length      = 24.0
	# Gentler wall angle – less sticking
	wall_min_slide_angle   = deg_to_rad(10.0)
	# Stop on a slope when not moving
	floor_stop_on_slope    = false
	floor_max_angle        = deg_to_rad(50.0)
	_connect_ladders()

func _connect_ladders() -> void:
	# Connect to every node in the "ladders" group (ladders and ropes)
	for ladder in get_tree().get_nodes_in_group("ladders"):
		if not ladder.body_entered.is_connected(_on_ladder_entered):
			ladder.body_entered.connect(_on_ladder_entered)
		if not ladder.body_exited.is_connected(_on_ladder_exited):
			ladder.body_exited.connect(_on_ladder_exited)

func _on_ladder_entered(body: Node2D) -> void:
	if body == self:
		_on_ladder = true

func _on_ladder_exited(body: Node2D) -> void:
	if body == self:
		_on_ladder   = false
		_is_climbing = false

func _physics_process(delta: float) -> void:
	_handle_ladder(delta)

	if _is_climbing:
		_process_climbing()
	else:
		_process_platformer(delta)

	move_and_slide()
	_update_animation()

	# Club cooldown
	if _swing_timer > 0.0:
		_swing_timer -= delta

	# Club swing (Space / LMB)
	if Input.is_action_just_pressed("shoot"):
		_try_swing()

# ──────────────────────────────────────────────
#  LADDER
# ──────────────────────────────────────────────
func _handle_ladder(_delta: float) -> void:
	if not _on_ladder:
		_is_climbing = false
		return

	var vert = Input.get_axis("move_up", "move_down")

	# Climb onto the ladder: press up/down while next to it
	if vert != 0.0:
		_is_climbing = true

	# Jump/detach from the ladder with up when standing at the bottom
	if Input.is_action_just_pressed("move_up") and _is_climbing and is_on_floor():
		_is_climbing = false
		velocity.y   = JUMP_VEL

func _process_climbing() -> void:
	var vert = Input.get_axis("move_up", "move_down")
	var horiz = Input.get_axis("move_left", "move_right")
	_climb_input_y = vert

	velocity.x = horiz * SPEED * 0.5   # można się trochę przesuwać
	velocity.y = vert  * CLIMB_SPEED
	if horiz != 0.0:
		_facing = horiz

	# Stop when there's no input (no gravity on the ladder)
	if vert == 0.0:
		velocity.y = 0.0

# ──────────────────────────────────────────────
#  REGULAR PLATFORMER
# ──────────────────────────────
func _process_platformer(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Jump
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity.y = JUMP_VEL

	# Horizontal movement with acceleration/braking
	var dir = Input.get_axis("move_left", "move_right")
	if dir != 0.0:
		var accel = ACCEL if is_on_floor() else AIR_ACCEL
		velocity.x = move_toward(velocity.x, dir * SPEED, accel * delta)
		_facing    = dir
	else:
		var decel = DECEL if is_on_floor() else AIR_ACCEL * 0.5
		velocity.x = move_toward(velocity.x, 0.0, decel * delta)

func _update_animation() -> void:
	if _anim == null:
		return

	_anim.speed_scale = 1.0

	# Attack animation – wait until it finishes (loop: false in the scene)
	if _is_swinging:
		if _anim.animation != ANIM_ATTACK:
			_anim.play(ANIM_ATTACK)
			return
		if _anim.is_playing():
			return
		_is_swinging = false  # animation finished, back to normal

	if _is_climbing:
		_play_anim(ANIM_CLIMB)
		if abs(_climb_input_y) < 0.01:
			_anim.speed_scale = 0.0
		else:
			var climb_ratio: float = absf(velocity.y) / maxf(CLIMB_SPEED, 1.0)
			_anim.speed_scale = CLIMB_ANIM_BASE_SPEED * clampf(climb_ratio, 0.65, 1.35)
		return

	if not is_on_floor():
		_play_anim(ANIM_JUMP_LEFT if _facing < 0.0 else ANIM_JUMP_RIGHT)
		return

	if abs(velocity.x) > 8.0:
		_play_anim(ANIM_MOVE_LEFT if velocity.x < 0.0 else ANIM_MOVE_RIGHT)
		var run_ratio: float = absf(velocity.x) / maxf(SPEED, 1.0)
		_anim.speed_scale = RUN_ANIM_BASE_SPEED * clampf(run_ratio, 0.7, 1.35)
	else:
		if _anim.is_playing():
			_anim.stop()

func _play_anim(anim_name: StringName) -> void:
	if _anim.animation != anim_name:
		_anim.play(anim_name)
	elif not _anim.is_playing():
		_anim.play()

# ──────────────────────────────────────────────
#  CLUB SWING
# ──────────────────────────────────────────────
func _try_swing() -> void:
	if _swing_timer > 0.0:
		return
	_swing_timer = swing_cooldown
	_is_swinging = true
	_do_swing_hitcheck()

func _do_swing_hitcheck() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if not is_instance_valid(enemy):
			continue
		if not enemy.has_method("take_damage"):
			continue
		var dist := global_position.distance_to(enemy.global_position)
		if dist > swing_range:
			continue
		# The hit lands on both sides (left and right)
		enemy.take_damage(1)
