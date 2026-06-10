extends Control

# -------------------------------------------------------
#  EndScreen – end screen (win / lose)
#    • Score with a "count-up" number animation
#    • "Pop-up" panel animation (popup)
#    • Leaderboard with the player's score added
# -------------------------------------------------------

@onready var _panel        : Control       = $Panel
@onready var _result_label : Label         = $Panel/VBox/ResultLabel
@onready var _score_label  : Label         = $Panel/VBox/ScoreLabel
@onready var _board_list   : VBoxContainer = $Panel/VBox/Leaderboard/ScoreList
@onready var _retry_button : Button        = $Panel/VBox/Buttons/RetryButton
@onready var _menu_button  : Button        = $Panel/VBox/Buttons/MenuButton

var _final_score   : int   = 0
var _shown_score   : float = 0.0
var _counting      : bool  = false

func _ready() -> void:
	get_tree().paused = false
	_final_score = GameState.last_score

	if GameState.last_result == "win":
		_result_label.text = "🏆  VICTORY!"
		_result_label.add_theme_color_override("font_color", Color(0.4, 1.0, 0.5))
	else:
		_result_label.text = "💀  GAME OVER"
		_result_label.add_theme_color_override("font_color", Color(1.0, 0.4, 0.4))

	_score_label.text = "Score: 0"
	_retry_button.pressed.connect(_on_retry_pressed)
	_menu_button.pressed.connect(_on_menu_pressed)

	_populate_leaderboard()
	# Wait a frame so the layout computes the panel size (correct pivot)
	_play_popup.call_deferred()

# ──────────────────────────────────────────────
#  POPUP PANEL ANIMATION
# ──────────────────────────────────────────────
func _play_popup() -> void:
	_panel.pivot_offset = _panel.size * 0.5
	_panel.scale = Vector2(0.2, 0.2)
	_panel.modulate.a = 0.0

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(_panel, "scale", Vector2(1.0, 1.0), 0.45) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(_panel, "modulate:a", 1.0, 0.3)
	# After the panel appears we count up the score
	tween.chain().tween_callback(_start_score_count)

func _start_score_count() -> void:
	_counting = true

func _process(delta: float) -> void:
	if not _counting:
		return
	_shown_score = move_toward(_shown_score, float(_final_score), max(1.0, _final_score) * 1.8 * delta)
	_score_label.text = "Score: %d" % int(_shown_score)
	if int(_shown_score) >= _final_score:
		_shown_score = _final_score
		_score_label.text = "Score: %d" % _final_score
		_counting = false
		_pulse_score()

func _pulse_score() -> void:
	var tween := create_tween()
	_score_label.pivot_offset = _score_label.size * 0.5
	tween.tween_property(_score_label, "scale", Vector2(1.25, 1.25), 0.12)
	tween.tween_property(_score_label, "scale", Vector2(1.0, 1.0), 0.12)

# ──────────────────────────────────────────────
#  LEADERBOARD
# ──────────────────────────────────────────────
func _populate_leaderboard() -> void:
	for child in _board_list.get_children():
		child.queue_free()

	var entries : Array = GameState.last_board
	var player_index : int = GameState.last_rank - 1

	var rank := 1
	for i in entries.size():
		var entry = entries[i]
		var row := Label.new()
		row.text = "%2d.  %-12s %6d" % [rank, str(entry.name), int(entry.score)]
		row.add_theme_font_size_override("font_size", 24)
		if i == player_index:
			row.add_theme_color_override("font_color", Color(0.4, 1.0, 0.5))
			row.text = "▶ " + row.text
		else:
			row.add_theme_color_override("font_color", Color(0.9, 0.82, 0.5))
		_board_list.add_child(row)
		rank += 1

func _on_retry_pressed() -> void:
	GameState.reset_run()
	get_tree().change_scene_to_file("res://scenes/main_level.tscn")

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
