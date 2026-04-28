extends Area2D
# -------------------------------------------------------
#  ItemPickup – przedmiot do zebrania (lina, klucz, amunicja)
#
#  @export item_type: "rope" | "key" | "ammo"
# -------------------------------------------------------

@export var item_type : String = "rope"
@export var label_text : String = ""   # np. "Lina" – wyświetlane przy zbieraniu

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	Inventory.pick_up(item_type)
	# Powiadomienie w HUD (opcjonalnie)
	var tree = get_tree()
	if tree:
		# Szukamy HUD
		var hud = tree.get_first_node_in_group("hud")
		if hud and hud.has_method("show_pickup"):
			var name_pl := label_text if label_text != "" else item_type
			hud.show_pickup("Podniesiono: " + name_pl)
	queue_free()
