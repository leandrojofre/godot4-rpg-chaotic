extends "res://Common/Collectable/script.gd"

@export var healing_value = 1

func _on_object_collected(node_to_heal):
	if node_to_heal.has_method("update_health"): node_to_heal.update_health(healing_value)
