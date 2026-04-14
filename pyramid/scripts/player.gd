extends CharacterBody2D

@export var SPEED       = 400.0
@export var JUMP_VEL    = -800.0
@export var CLIMB_SPEED = 200.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# --- Stan drabiny ---
var _on_ladder   := false   # gracz jest w obszarze drabiny
var _is_climbing := false   # gracz aktywnie wspina się

func _ready() -> void:
	# Szukamy wszystkich drabin na scenie i podpinamy sygnały
	_connect_ladders()

func _connect_ladders() -> void:
	# Łączymy się z każdym węzłem Ladder w grupie "ladders"
	for ladder in get_tree().get_nodes_in_group("ladders"):
		ladder.body_entered.connect(_on_ladder_entered)
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

# ──────────────────────────────────────────────
#  DRABINA
# ──────────────────────────────────────────────
func _handle_ladder(_delta: float) -> void:
	if not _on_ladder:
		_is_climbing = false
		return

	var vert = Input.get_axis("move_up", "move_down")

	# Wejście na drabinę: naciśnij góra/dół będąc przy niej
	if vert != 0.0:
		_is_climbing = true

	# Skok z drabiny
	if Input.is_action_just_pressed("move_up") and _is_climbing and is_on_floor():
		_is_climbing = false
		velocity.y   = JUMP_VEL

func _process_climbing() -> void:
	var vert = Input.get_axis("move_up", "move_down")
	var horiz = Input.get_axis("move_left", "move_right")

	velocity.x = horiz * SPEED * 0.5   # można się trochę przesuwać
	velocity.y = vert  * CLIMB_SPEED

	# Zatrzymaj się gdy brak wejścia (brak grawitacji na drabinie)
	if vert == 0.0:
		velocity.y = 0.0

# ──────────────────────────────────────────────
#  ZWYKŁA PLATFORMÓWKA
# ──────────────────────────────────────────────
func _process_platformer(delta: float) -> void:
	# Grawitacja
	if not is_on_floor():
		velocity.y += gravity * delta

	# Skok
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity.y = JUMP_VEL

	# Ruch poziomy
	var dir = Input.get_axis("move_left", "move_right")
	if dir:
		velocity.x = dir * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED / 10.0)
