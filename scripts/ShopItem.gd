extends Control

onready var selectedArrow = $SelectedArrow
onready var itemButton = $ItemButton
onready var itemQty = $ItemHbox/ItemQty
onready var itemIcon = $ItemHbox/ItemIcon
onready var itemName = $ItemHbox/ItemName
onready var itemPrice = $ItemHbox/ItemPriceStack

export (Resource) var weapon_data
export (Resource) var defensive_data

var displayed_resource: Resource

func _ready() -> void:
	deselect_item()
	set_item_data(weapon_data)


func change_item_type(type: String) -> void:
	match type:
		"Weapon":
			set_item_data(weapon_data)
		"Defensive":
			set_item_data(defensive_data)
	deselect_item()


func set_item_data(type: Resource) -> void:
	displayed_resource = type
	itemQty.text = "0"
	itemIcon.texture = type.icon
	itemName.text = type.name
	itemPrice.text = "$" + str(type.cost) + "/" + str(type.purchase_stack)


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
