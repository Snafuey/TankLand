extends Control

onready var itemGrid: GridContainer = $Center/Window/Margin/VBox/ItemGrid

var player_slot: String

func assign_player_slot(_player_slot: String) -> void:
	player_slot = _player_slot


func _ready() -> void:
	var item_slots: Array = itemGrid.get_children()
	for slot in item_slots:
		if slot.is_in_group("inventorySlot"):
			slot.set_item_qty(player_slot)



