extends CharacterBody2D

@export var speed = 240
@export var run_multiplier = 2.0
@export var max_health: int = 5

@onready var animations = $AnimatedSprite2D

var velocityDirection
var current_health: int

func _ready():
	current_health = max_health
	set_motion_mode(CharacterBody2D.MOTION_MODE_FLOATING)

func select_player_animation():
	if velocityDirection.x > 0:
		animations.flip_h = false
	elif velocityDirection.x < 0:
		animations.flip_h = true
	
	if Input.is_action_pressed("run"):
		animations.play("run")
		velocityDirection *= run_multiplier
	elif Input.is_action_pressed("key-down"):
		animations.play("walk")
	else: animations.play("idle")

func _physics_process(_delta):
	var inputDirection_x = float(Input.is_action_pressed("right")) - float(Input.is_action_pressed("left"))
	var inputDirection_y = float(Input.is_action_pressed("down")) - float(Input.is_action_pressed("up"))
	var inputDirection = Vector2(inputDirection_x, inputDirection_y)
	
	velocityDirection = inputDirection.limit_length().snapped(Vector2(0.1, 0.1))
	velocityDirection *= speed
	
	select_player_animation()
	
	velocity = velocityDirection
	
	move_and_slide()

func _on_hit_box_area_entered(area):
	if area.name == "HitBox":
		current_health -= 1
		print("HP-1 / Total: ", current_health)
		
		if current_health == 0:
			current_health = max_health
