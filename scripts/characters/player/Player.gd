extends CharacterBody2D

@export var speed = 240
@export var run_multiplier = 2.5

func _physics_process(_delta):
	var input_direction_x = float(Input.is_action_pressed("right")) - float(Input.is_action_pressed("left"))
	var input_direction_y = float(Input.is_action_pressed("down")) - float(Input.is_action_pressed("up"))

	var step_x = input_direction_x * speed
	var step_y = input_direction_y * speed
	
	if Input.is_action_pressed("run"):
		step_x *= run_multiplier
		step_y *= run_multiplier
	
	velocity.x = step_x
	velocity.y = step_y
	move_and_slide()
