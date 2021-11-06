extends CenterContainer

onready var itemQty: Label = $HBox/Qty
onready var itemIcon: TextureRect = $HBox/Icon
onready var itemButton: TextureButton = $ItemButton

export (Resource) var item_data

var player_slot: String

func _ready() -> void:
	if item_data:
		itemIcon.texture = item_data.icon


func set_item_qty(_player_slot: String) -> void:
	player_slot = _player_slot
	var inventory: Inventory = Utils.get_player_inventory(player_slot)
	itemQty.text = str(inventory.get_weapon_amount(item_data.name))


func _on_ItemButton_toggled(button_pressed: bool) -> void:
	if button_pressed:
		var inventory: Inventory = Utils.get_player_inventory(player_slot)
		inventory.equipped_weapon = item_data
		var item_slots: Array = get_parent().get_children()
		for slot in item_slots:
			if slot.is_in_group("inventorySlot") and slot.name != self.name:
				slot.deselect_item()


func deselect_item() -> void:
	itemButton.pressed = false
