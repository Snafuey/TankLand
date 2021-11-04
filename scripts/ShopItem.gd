extends Control

onready var selectedArrow = $SelectedArrow
onready var itemButton = $ItemButton
onready var itemQty = $ItemHbox/ItemQty
onready var itemIcon = $ItemHbox/ItemIcon
onready var itemName = $ItemHbox/ItemName
onready var itemPrice = $ItemHbox/ItemPriceStack

export (Resource) var weapon_data
export (Resource) var defensive_data

var displayed_resource: Item

func _ready() -> void:
	deselect_item()
#	set_item_data(weapon_data)


func change_item_type(type: String, player_inventory: Inventory) -> void:
	match type:
		"Weapon":
			set_item_data(weapon_data)
			update_item_qty(type, player_inventory)
		"Defensive":
			set_item_data(defensive_data)
			update_item_qty(type, player_inventory)
	deselect_item()


func set_item_data(item: Item) -> void:
	displayed_resource = item
	itemIcon.texture = item.icon
	itemName.text = item.name
	itemPrice.text = "$" + str(item.cost) + "/" + str(item.purchase_stack)


func update_item_qty(type: String, player_inventory: Inventory) -> void:
	match type:
		"Weapon":
			itemQty.text = str(player_inventory.weapons[weapon_data.name]["Amount"])
		"Defensive":
			itemQty.text = str(player_inventory.defensive[defensive_data.name]["Amount"])

func deselect_item() -> void:
	itemButton.pressed = false
	selectedArrow.visible = false


func _on_ItemButton_toggled(button_pressed: bool) -> void:
	if button_pressed:
		selectedArrow.visible = true
		Events.emit_signal("shop_item_selected", displayed_resource)
		var itemsContainer: VBoxContainer = get_parent()
		var items: Array = itemsContainer.get_children()
		for item in items:
			if item.name != self.name:
				item.deselect_item()
