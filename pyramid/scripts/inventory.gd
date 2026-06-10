extends Node

# -------------------------------------------------------
#  Inventory – Autoload singleton ("Inventory")
#  Tracks the player's items throughout the whole game.
# -------------------------------------------------------

signal inventory_changed

# By default the player has a torch and a pistol.
var has_torch  : bool = true
var has_pistol : bool = true
var has_rope   : bool = false
var has_key    : bool = false

# Ammo – unlimited
var ammo       : int  = -1

func pick_up(item_name: String) -> void:
	match item_name:
		"rope":
			has_rope = true
		"key":
			has_key  = true
		"ammo":
			ammo += 10
	emit_signal("inventory_changed")

func use_ammo() -> bool:
	# Unlimited ammo
	return true

func reset() -> void:
	has_torch  = true
	has_pistol = true
	has_rope   = false
	has_key    = false
	ammo       = -1
	emit_signal("inventory_changed")
