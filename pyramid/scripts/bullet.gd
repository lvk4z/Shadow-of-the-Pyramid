extends Area2D
# -------------------------------------------------------
#  Bullet – a projectile fired by the player
# -------------------------------------------------------

@export var speed  : float = 800.0
@export var damage : int   = 1

var direction : Vector2 = Vector2.RIGHT

func _ready() -> void:
	# Self-destruct after 3 seconds (safety)
	var t = get_tree().create_timer(3.0)
	t.timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	# Ignore the player and other players
	if body.is_in_group("player"):
		return
	# Hit on a mummy
	if body.is_in_group("mummies"):
		body.take_damage(damage)
	queue_free()

func _on_area_entered(_area: Area2D) -> void:
	pass
