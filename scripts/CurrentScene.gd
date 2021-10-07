extends Node

func queue_child_index(index: int) -> void:
	get_child(index).queue_free()

func add_child_path(path: String) -> void:
	add_child(load(path).instance())
