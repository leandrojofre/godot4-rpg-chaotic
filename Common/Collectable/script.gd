extends Area2D

signal object_collected

func collect(parent: CharacterBody2D):
	object_collected.emit(parent)
	queue_free()
