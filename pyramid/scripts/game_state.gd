extends Node

# -------------------------------------------------------
#  GameState – Autoload singleton ("GameState")
#  Holds the current run's score, manages the leaderboard
#  (high scores) and saves it to disk.
# -------------------------------------------------------

const SAVE_PATH    : String = "user://highscores.save"
const PLAYER_NAME  : String = "YOU"          # player name in the table
const MAX_ENTRIES  : int    = 8             # how many entries we keep

# Current run's score
var score        : int    = 0
# Score from the last finished run (for the end screen)
var last_score   : int    = 0
# "win" or "lose" – set before switching to the end screen
var last_result  : String = "lose"
# Player's rank in the table after the last game (1 = first place, 0 = off the table)
var last_rank    : int    = 0
# Leaderboard computed at the end of the game (with the player's row) – for the end screen
var last_board   : Array  = []

# "Fake" leaderboard – starting, made-up records.
var _fake_scores : Array = [
	{ "name": "RA-AMUN",   "score": 3200 },
	{ "name": "CLEOPATRA", "score": 2750 },
	{ "name": "IMHOTEP",   "score": 2100 },
	{ "name": "ANUBIS",    "score": 1650 },
	{ "name": "NEFERTITI", "score": 1200 },
	{ "name": "SETI",      "score":  800 },
	{ "name": "HORUS",     "score":  450 },
]

# Real player scores saved to disk
var _saved_scores : Array = []

func _ready() -> void:
	_load_scores()

# ──────────────────────────────────────────────
#  IN-GAME SCORING
# ──────────────────────────────────────────────
func reset_run() -> void:
	score = 0

func add_score(points: int) -> void:
	score += points

# ──────────────────────────────────────────────
#  END OF GAME
# ──────────────────────────────────────────────
# Computes the table with the player's score, saves it to disk
# and switches to the end screen.
func finish_game(won: bool) -> void:
	last_result = "win" if won else "lose"
	last_score  = score

	# We compute the table BEFORE adding the score to the saved ones,
	# so the player doesn't appear twice on the end screen.
	var board := get_leaderboard_with_player(last_score)
	last_board   = board.entries
	last_rank    = int(board.player_index) + 1

	# Only now we persist the score (it appears in the menu and future games).
	_register_score(last_score)

	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/end_screen.tscn")

# Returns the full table (fake + saved scores) sorted descending.
func get_leaderboard() -> Array:
	var combined : Array = []
	for e in _fake_scores:
		combined.append({ "name": e.name, "score": e.score })
	for e in _saved_scores:
		combined.append({ "name": e.name, "score": e.score })
	combined.sort_custom(func(a, b): return a.score > b.score)
	if combined.size() > MAX_ENTRIES:
		combined.resize(MAX_ENTRIES)
	return combined

# Builds the table with the player's score INCLUDED (for the end screen),
# even if they wouldn't make the top – also returns the player's index.
func get_leaderboard_with_player(player_score: int) -> Dictionary:
	var combined : Array = []
	for e in _fake_scores:
		combined.append({ "name": e.name, "score": e.score, "is_player": false })
	for e in _saved_scores:
		combined.append({ "name": e.name, "score": e.score, "is_player": false })

	var player_entry := { "name": PLAYER_NAME, "score": player_score, "is_player": true }
	combined.append(player_entry)
	combined.sort_custom(func(a, b): return a.score > b.score)

	var player_index : int = combined.find(player_entry)
	if combined.size() > MAX_ENTRIES:
		# Keep the top, but always show the player's row
		if player_index >= MAX_ENTRIES:
			var trimmed : Array = combined.slice(0, MAX_ENTRIES - 1)
			trimmed.append(player_entry)
			combined = trimmed
			player_index = MAX_ENTRIES - 1
		else:
			combined = combined.slice(0, MAX_ENTRIES)

	return { "entries": combined, "player_index": player_index }

# ──────────────────────────────────────────────
#  SAVE / LOAD
# ──────────────────────────────────────────────
func _register_score(player_score: int) -> void:
	_saved_scores.append({ "name": PLAYER_NAME, "score": player_score })
	# Keep only the player's best scores so the file doesn't grow
	_saved_scores.sort_custom(func(a, b): return a.score > b.score)
	if _saved_scores.size() > MAX_ENTRIES:
		_saved_scores.resize(MAX_ENTRIES)
	_save_scores()

func _save_scores() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_warning("GameState: could not save scores to %s" % SAVE_PATH)
		return
	file.store_var(_saved_scores)
	file.close()

func _load_scores() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		_saved_scores = []
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		_saved_scores = []
		return
	var data = file.get_var()
	file.close()
	if data is Array:
		_saved_scores = data
	else:
		_saved_scores = []
