extends HSlider

export var bus_name: String

var bus_index: int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	self.value = db2linear(AudioServer.get_bus_volume_db(bus_index))


func _on_VolumeSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear2db(value))

