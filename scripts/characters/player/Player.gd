extends CharacterBody2D

@export var speed = 240
@export var run_multiplier = 2.5
@onready var animations = $AnimatedSprite2D

var velocity_direction

func select_player_animation():
	if Input.is_action_pressed("run"):
		animations.play("run")
		velocity_direction *= run_multiplier
	elif Input.is_action_pressed("key-down"):
		animations.play("walk")
	else: animations.play("idle")	

func _physics_process(_delta):
	var input_direction_x = float(Input.is_action_pressed("right")) - float(Input.is_action_pressed("left"))
	var input_direction_y = float(Input.is_action_pressed("down")) - float(Input.is_action_pressed("up"))
	var input_direction = Vector2(input_direction_x, input_direction_y)
	
	velocity_direction = input_direction.limit_length().snapped(Vector2(0.1, 0.1))
	velocity_direction *= speed
	
	if input_direction_x > 0:
		animations.flip_h = false
	elif input_direction_x < 0:
		animations.flip_h = true
	
	select_player_animation()
	
	velocity = velocity_direction
	
	move_and_slide()
