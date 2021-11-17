extends HSlider

export var bus_name: String

var bus_index: int

func _ready() -> void:
	set_slider_value()

func _on_VolumeSlider_value_changed(value: float) -> void:
	Utils.change_bus_volume(bus_index, value)

func set_slider_value() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	self.value = db2linear(AudioServer.get_bus_volume_db(bus_index))
