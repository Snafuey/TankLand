extends Control


func _on_ApplyButton_pressed() -> void:
	Utils.save_volume_settings()
	self.queue_free()


func _on_CancelButton_pressed() -> void:
	Utils.set_all_bus_volumes_from_save()
	self.queue_free()
	

func _on_RestoreButton_pressed() -> void:
	Utils.restore_default_volume_settings()
	var sliders: Array = get_tree().get_nodes_in_group("volumeSliders")
	for slider in sliders:
		slider.set_slider_value()
