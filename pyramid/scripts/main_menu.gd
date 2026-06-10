extends Control

# -------------------------------------------------------
#  MainMenu – the game's start screen
#    • PLAY button     → launches the level
#    • Instructions    → controls + goal
#    • QUIT button     → closes the game
# -------------------------------------------------------

@onready var _play_button : Button = $CenterRow/LeftPanel/PlayButton
@onready var _quit_button : Button = $CenterRow/LeftPanel/QuitButton

func _ready() -> void:
	# Po powrocie z gry odpauzuj drzewo
	get_tree().paused = false
	_play_button.pressed.connect(_on_play_pressed)
	_quit_button.pressed.connect(_on_quit_pressed)
	_play_button.grab_focus()

func _on_play_pressed() -> void:
	GameState.reset_run()
	get_tree().change_scene_to_file("res://scenes/main_level.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
