extends CharacterBody2D

@export var speed = 240
@export var run_multiplier = 2.5
@onready var animations = $AnimatedSprite2D

var step_x
var step_y

func select_player_animation():
	if Input.is_action_pressed("run"):
		animations.play("run")
		step_x *= run_multiplier
		step_y *= run_multiplier
	elif Input.is_action_pressed("key-down"):
		animations.play("walk")
	else: animations.play("idle")	

func _physics_process(_delta):
	var input_direction_x = float(Input.is_action_pressed("right")) - float(Input.is_action_pressed("left"))
	var input_direction_y = float(Input.is_action_pressed("down")) - float(Input.is_action_pressed("up"))

	step_x = input_direction_x * speed
	step_y = input_direction_y * speed
	
	if input_direction_x > 0:
		animations.flip_h = false
	elif input_direction_x < 0:
		animations.flip_h = true
	
	select_player_animation()
	
	velocity.x = step_x
	velocity.y = step_y
	move_and_slide()
