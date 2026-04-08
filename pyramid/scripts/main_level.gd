extends Node2D

@onready var time_label = $UI/TimeLabel
@onready var game_timer = $GameTimer
@onready var player_light = $Player/PointLight2D

var max_light_scale = 1.0
var max_light_energy = 1.0

func _ready() -> void:
	max_light_energy = player_light.energy
	max_light_scale = player_light.texture_scale

func _process(delta: float) -> void:
	time_label.text = "Czas: " + str(int(game_timer.time_left))
	var time_ratio = game_timer.time_left / game_timer.wait_time
	player_light.texture_scale = max(0.2, max_light_scale * time_ratio)
	player_light.energy = max(0.3, max_light_energy * time_ratio)

func _on_game_timer_timeout() -> void:
	print("Koniec czasu! Przerana!")
	get_tree().reload_current_scene()


func _on_sarcophagus_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Wygrana")
		time_label.text = "Wygrana"
		get_tree().paused = true
