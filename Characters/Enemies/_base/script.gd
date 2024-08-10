extends CharacterBody2D

@export var speed = 120
@export var markersNodes: Array[NodePath]
@export var loop_in_circles: bool = true
@export var damage: int = 2

@onready var Animations = $AnimatedSprite2D

var step_length = 0
var current_marker_target = 0
var swaping_target_direction = 1
var position_target
var velocity_direction = Vector2(0, 0)
var markers: Array[Vector2]

func _ready():	
	for i in range(markersNodes.size()):
		markers.append(get_node(markersNodes[i]).global_position)
	
	position_target = markers[current_marker_target]
	set_motion_mode(CharacterBody2D.MOTION_MODE_FLOATING)

func get_damage() -> int:
	return damage * -1

func swap_current_marker():
	var topLimitReached = (current_marker_target + swaping_target_direction == markers.size())
	var bottomLimitReached = (current_marker_target + swaping_target_direction < 0)
	
	if (topLimitReached or bottomLimitReached) and not loop_in_circles:
		swaping_target_direction *= -1
	elif topLimitReached and loop_in_circles:
		current_marker_target = -1
		
	current_marker_target += swaping_target_direction
	
	return current_marker_target

func change_direction():
	if markers.size() == 1: return
	if not position.distance_to(position_target) <= step_length: return
	
	position_target = markers[swap_current_marker()]

func select_animation():
	if velocity_direction.length() == 0:
		Animations.play("idle")
	else: Animations.play("walk")
		
	if velocity_direction.x > 0:
		Animations.flip_h = false
	elif velocity_direction.x < 0:
		Animations.flip_h = true

func _physics_process(_delta):
	change_direction()
	select_animation()
	
	if position.distance_to(position_target) <= step_length:
		position = position_target
	
	velocity_direction = position.direction_to(position_target).limit_length().snapped(Vector2(0.1, 0.1))
	velocity_direction *= speed
	velocity = velocity_direction
	
	var prePosition = position
	move_and_slide()
	var posPosition = position
	
	step_length = prePosition.distance_to(posPosition)
