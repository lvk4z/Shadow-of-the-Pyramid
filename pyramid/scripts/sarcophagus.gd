extends Area2D

@export var is_fake : bool = false

signal activated(is_fake: bool)

var _player_inside : bool = false

@onready var _hint : Label = get_node_or_null("HintLabel")

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	if _hint:
		_hint.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_inside = true
		if _hint:
			_hint.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_inside = false
		if _hint:
			_hint.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if _player_inside and event.is_action_pressed("interact"):
		activated.emit(is_fake)
		if _hint:
			_hint.visible = false
		set_process_unhandled_input(false)
