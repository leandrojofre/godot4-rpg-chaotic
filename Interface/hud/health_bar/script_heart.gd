extends Panel

@onready var Sprite = $Sprite2D

var max_frame
var min_frame
var current_frame

func _ready():
	max_frame = Sprite.hframes - 1
	min_frame = 0
	current_frame = min_frame

func update_sprite(step: int) -> int:
	var original_step = step
	var damage_exceeds_limit = (step + current_frame) > max_frame
	var healing_exceeds_limit = (step + current_frame) < min_frame
	var overflow = 0
	
	if damage_exceeds_limit:
		overflow = step - (step + current_frame - max_frame)
		step = overflow
	if healing_exceeds_limit:
		overflow = step - (step + current_frame)
		step = overflow
	
	current_frame += step
	Sprite.set_frame(current_frame)
	
	return original_step - step

func check_health_points(health_points: int) -> bool:
	return (health_points == current_frame)

func get_heart_points() -> int:
	return max_frame - current_frame

func empty_heart_points():
	update_sprite(get_heart_points())

func reset_sprite():
	update_sprite(min_frame)
