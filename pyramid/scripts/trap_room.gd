extends Node2D
# -------------------------------------------------------
#  TrapRoom – a red room with doors and mummies
#
#  In the Inspector drag the nodes into the fields:
#    door_left   – StaticBody2D of the left door
#    door_right  – StaticBody2D of the right door
#    mummy_spawns – Node2D with children acting as spawn points
#    mummy_scene  – PackedScene of the mummy
# -------------------------------------------------------

@export var door_left    : StaticBody2D
@export var door_right   : StaticBody2D
@export var mummy_spawns : Node2D
@export var mummy_scene  : PackedScene

var _activated     : bool = false
var _mummies_alive : int  = 0

func _ready() -> void:
	# If the export isn't assigned – look up by name
	if door_left  == null: door_left  = get_node_or_null("DoorLeft")
	if door_right == null: door_right = get_node_or_null("DoorRight")
	if mummy_spawns == null: mummy_spawns = get_node_or_null("MummySpawns")
	# Doors start OPEN (collision disabled, invisible)
	_set_doors(false)

func _on_trigger_area_body_entered(body: Node2D) -> void:
	if _activated or not body.is_in_group("player"):
		return
	_activate()

func _activate() -> void:
	_activated = true
	_set_doors(true)

	if mummy_scene == null:
		push_warning("TrapRoom: assign mummy_scene in the Inspector!")
		return
	if mummy_spawns == null:
		push_warning("TrapRoom: assign mummy_spawns in the Inspector!")
		_set_doors(false)
		return

	_mummies_alive = 0
	for spawn_point in mummy_spawns.get_children():
		var mummy := mummy_scene.instantiate() as CharacterBody2D
		get_tree().current_scene.add_child(mummy)
		mummy.global_position = spawn_point.global_position
		mummy.died.connect(_on_mummy_died)
		_mummies_alive += 1

	if _mummies_alive == 0:
		push_warning("TrapRoom: no spawn points in mummy_spawns!")
		_set_doors(false)

func _on_mummy_died() -> void:
	_mummies_alive -= 1
	if _mummies_alive <= 0:
		_set_doors(false)

func _set_doors(closed: bool) -> void:
	_set_door(door_left,  closed)
	_set_door(door_right, closed)

func _set_door(door: StaticBody2D, closed: bool) -> void:
	if door == null:
		return
	# Włącz/wyłącz kolizje
	for child in door.get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", not closed)
		elif child is CollisionPolygon2D:
			child.set_deferred("disabled", not closed)
		# Sprite/Polygon2D chowaj osobno – NIE ukrywaj całego StaticBody2D
		elif child is Sprite2D or child is Polygon2D or child is ColorRect:
			child.visible = closed
