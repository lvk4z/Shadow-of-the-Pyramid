extends CharacterBody2D

@export var SPEED = 400.0
@export var JUMP_VEL = -800.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#func _physics_process(delta):
	#if not is_on_floor():
		#velocity.y += gravity * delta
		#
	#if Input.is_action_just_pressed("move_up") and is_on_floor():
		#velocity.y = JUMP_VEL
	#var direction = Input.get_axis("move_left","move_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, .0, SPEED/10)
	#move_and_slide()
func _physics_process(delta):
	# Zwykły ruch w 8 kierunkach do testowania mapy
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	move_and_slide()
