extends Panel

@onready var Sprite = $Sprite2D

var max_frame
var min_frame
var current_frame

func _ready():
	max_frame = Sprite.hframes - 1
	min_frame = 0
	current_frame = min_frame

func is_heart_empty() -> bool:
	return (max_frame == current_frame)

func update_sprite(step: int = 1) -> int:
	if is_heart_empty(): return 0
	
	var overflow: int = (current_frame + step) - max_frame
	
	if overflow < 0: overflow = 0
	
	current_frame += step - overflow
	Sprite.set_frame(current_frame)
	
	return overflow

func reset_sprite():
	current_frame = 0
	Sprite.set_frame(current_frame)

func get_heart_points() -> int:
	return max_frame - current_frame
