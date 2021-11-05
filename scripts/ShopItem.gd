extends Control

onready var selectedArrow = $SelectedArrow
onready var itemButton = $ItemButton
onready var itemQty = $ItemHbox/ItemQty
onready var itemIcon = $ItemHbox/ItemIcon
onready var itemName = $ItemHbox/ItemName
onready var itemPrice = $ItemHbox/ItemPriceStack

export (Resource) var weapon_data
export (Resource) var defensive_data

var displayed_item: Item

func _ready() -> void:
	deselect_item()


func deselect_item() -> void:
	itemButton.pressed = false
	selectedArrow.visible = false


func set_item_data(type: String, player_inventory: Inventory) -> void:
	match type:
		"Weapon":
			itemQty.text = str(player_inventory.get_weapon_amount(weapon_data.name))
			display_data(weapon_data)
		"Defensive":
			itemQty.text = str(player_inventory.get_defense_item_amount(defensive_data.name))
			display_data(defensive_data)
	

func display_data(item: Item) -> void:
	if displayed_item != item:
		displayed_item = item
		itemIcon.texture = item.icon
		itemName.text = item.name
		itemPrice.text = "$" + str(item.cost) + "/" + str(item.purchase_stack)
		deselect_item()


func _on_ItemButton_toggled(button_pressed: bool) -> void:
	if button_pressed:
		selectedArrow.visible = true
		Events.emit_signal("shop_item_selected", displayed_item)
		var item_slots: Array = get_parent().get_children()
		for slot in item_slots:
			if slot.name != self.name:
				slot.deselect_item()
