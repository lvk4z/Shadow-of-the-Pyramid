extends Node2D
# -------------------------------------------------------
#  Spider – a simple spider hanging on a web thread.
#  It gently sways in place and dies when the player hits
#  it with the club (take_damage). No chasing, no biting.
#
#  Node position = the spider body (what the attack aims at).
#  The web thread is drawn upward to a fixed ceiling point.
# -------------------------------------------------------

@export var max_hp      : int   = 1
@export var web_length  : float = 110.0   # thread length to the ceiling
@export var sway_amount : float = 9.0     # horizontal sway (px)
@export var sway_speed  : float = 1.5     # sway speed
@export var score_value : int   = 40

var hp            : int   = max_hp
var _time         : float = 0.0
var _base_global  : Vector2
var _anchor_global: Vector2
var _dead         : bool  = false
var _hurt_flash   : float = 0.0

signal died

const BODY_COLOR := Color(0.07, 0.06, 0.09)
const LEG_COLOR  := Color(0.07, 0.06, 0.09)
const EYE_COLOR  := Color(0.95, 0.25, 0.25)
const WEB_COLOR  := Color(0.85, 0.85, 0.9, 0.5)

func _ready() -> void:
	hp = max_hp
	add_to_group("enemies")
	add_to_group("spiders")
	_base_global   = global_position
	_anchor_global = _base_global + Vector2(0.0, -web_length)

func _process(delta: float) -> void:
	_time += delta
	if _hurt_flash > 0.0:
		_hurt_flash -= delta
	if _dead:
		queue_redraw()
		return
	# Gentle sway in place
	var sway_x : float = sin(_time * sway_speed) * sway_amount
	global_position = Vector2(_base_global.x + sway_x, _base_global.y)
	queue_redraw()

# ──────────────────────────────────────────────
#  DAMAGE / DEATH
# ──────────────────────────────────────────────
func take_damage(_amount: int) -> void:
	if _dead:
		return
	hp -= 1
	_hurt_flash = 0.15
	if hp <= 0:
		_die()

func _die() -> void:
	_dead = true
	remove_from_group("enemies")
	remove_from_group("spiders")
	GameState.add_score(score_value)
	emit_signal("died")
	# Spider falls and fades out
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", position.y + 400.0, 0.6) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate:a", 0.0, 0.6)
	tween.chain().tween_callback(queue_free)

# ──────────────────────────────────────────────
#  DRAWING (simple spider)
# ──────────────────────────────────────────────
func _draw() -> void:
	# Web thread up to a fixed ceiling point
	draw_line(to_local(_anchor_global), Vector2.ZERO, WEB_COLOR, 1.5)

	var body_color := BODY_COLOR
	if _hurt_flash > 0.0:
		body_color = Color(1.0, 0.4, 0.4)

	# Four simple legs
	draw_line(Vector2(0, 0), Vector2(-12, 8), LEG_COLOR, 2.0)
	draw_line(Vector2(0, 0), Vector2(12, 8), LEG_COLOR, 2.0)
	draw_line(Vector2(0, 2), Vector2(-12, 14), LEG_COLOR, 2.0)
	draw_line(Vector2(0, 2), Vector2(12, 14), LEG_COLOR, 2.0)

	# Body and eyes
	draw_circle(Vector2(0, 6), 9.0, body_color)
	draw_circle(Vector2(-3, 4), 1.6, EYE_COLOR)
	draw_circle(Vector2(3, 4), 1.6, EYE_COLOR)
