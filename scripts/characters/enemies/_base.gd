extends CharacterBody2D

@export var speed = 120
@export var original_position_a: Marker2D
@export var original_position_b: Marker2D

@onready var animations = $AnimatedSprite2D

var position_point_a
var position_point_b
var position_target
var velocity_direction

func _ready():
	position_point_a = original_position_a.global_position
	position_point_b = original_position_b.global_position
	position_target = position_point_a
	velocity_direction = Vector2(0, 0)
	
func change_direction():
	if not floor(position.distance_to(position_target)) == 0: return
		
	if position_target == position_point_a: position_target = position_point_b
	elif position_target == position_point_b: position_target = position_point_a
	
func select_animation():
	if velocity_direction.length() == 0:
		animations.play("idle")
	else: animations.play("walk")
	
	if velocity_direction.x >= 0:
		animations.flip_h = false
	else: animations.flip_h = true
		

func _physics_process(_delta):
	change_direction()
	select_animation()
	
	velocity_direction = position.direction_to(position_target).snapped(Vector2(0.1, 0.1))
	velocity_direction *= speed
	
	velocity = velocity_direction
	move_and_slide()
