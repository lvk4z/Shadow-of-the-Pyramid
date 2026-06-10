extends Area2D
# -------------------------------------------------------
#  ItemPickup – an item to collect (rope, key, ammo)
#
#  @export item_type: "rope" | "key" | "ammo"
# -------------------------------------------------------

@export var item_type  : String = "rope"
@export var label_text : String = ""   # e.g. "Rope" – shown when collected

@onready var _label : Label = $Label

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	# Set the label above the item
	if _label:
		var icons := {"rope": "🨢 Rope", "key": "🗝 Key", "ammo": "🔫 Ammo"}
		_label.text = icons.get(item_type, label_text if label_text != "" else item_type)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	Inventory.pick_up(item_type)
	# Points for collecting the item
	match item_type:
		"key":  GameState.add_score(75)
		"rope": GameState.add_score(50)
		_:      GameState.add_score(25)
	# HUD notification (optional)
	var tree = get_tree()
	if tree:
		# Find the HUD
		var hud = tree.get_first_node_in_group("hud")
		if hud and hud.has_method("show_pickup"):
			var name_pl := label_text if label_text != "" else item_type
			hud.show_pickup("Picked up: " + name_pl)
	queue_free()
