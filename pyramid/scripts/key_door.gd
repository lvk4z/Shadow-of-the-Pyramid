extends StaticBody2D
# -------------------------------------------------------
#  KeyDoor – drzwi otwierane kluczem
#
#  Gracz (stojąc w InteractArea) naciska "interact" (E),
#  jeśli ma klucz w ekwipunku.
# -------------------------------------------------------

@onready var interact_area    : Area2D           = $InteractArea
@onready var collision_shape  : CollisionShape2D = $CollisionShape2D
@onready var sprite           : Sprite2D         = $Sprite2D
@onready var hint_label       : Label            = $HintLabel

var _player_nearby : bool = false

func _ready() -> void:
	interact_area.body_entered.connect(_on_player_enter)
	interact_area.body_exited.connect(_on_player_exit)

func _process(_delta: float) -> void:
	if _player_nearby and Inventory.has_key:
		hint_label.text    = "E – Otwórz (masz klucz!)"
		hint_label.visible = true
		if Input.is_action_just_pressed("interact"):
			_open()
	elif _player_nearby:
		hint_label.text    = "Potrzebny klucz"
		hint_label.visible = true
	else:
		hint_label.visible = false

func _open() -> void:
	collision_shape.disabled = true
	sprite.visible           = false
	hint_label.visible       = false
	set_process(false)
