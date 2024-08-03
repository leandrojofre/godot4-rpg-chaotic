extends CharacterBody2D

@export var speed = 120
@export var markersNodes: Array[NodePath]
@export var loop_in_circles: bool

@onready var animations = $AnimatedSprite2D

var step_length = 0
var currentMarkerTarget = 0
var swapingTargetDirection = 1
var position_target
var velocity_direction = Vector2(0, 0)
var markers: Array[Vector2]

func _ready():	
	for i in range(markersNodes.size()):
		markers.append(get_node(markersNodes[i]).global_position)
	
	position_target = markers[currentMarkerTarget]

func swapCurrentMarker():
	var top_limit_reached = (currentMarkerTarget + swapingTargetDirection == markers.size())
	var bottom_limit_reached = (currentMarkerTarget + swapingTargetDirection < 0)
	
	if (top_limit_reached or bottom_limit_reached) and not loop_in_circles:
		swapingTargetDirection *= -1
	elif top_limit_reached and loop_in_circles:
		currentMarkerTarget = -1
		
	currentMarkerTarget += swapingTargetDirection
	
	return currentMarkerTarget

func change_direction():
	if markers.size() == 1: return
	if not position.distance_to(position_target) <= step_length: return
	
	position_target = markers[swapCurrentMarker()]

func select_animation():
	if velocity_direction.length() == 0:
		animations.play("idle")
	else: animations.play("walk")
		
	if velocity_direction.x > 0:
		animations.flip_h = false
	elif velocity_direction.x < 0:
		animations.flip_h = true

func _physics_process(_delta):
	change_direction()
	select_animation()
	
	if position.distance_to(position_target) <= step_length:
		position = position_target
	
	velocity_direction = position.direction_to(position_target).limit_length().snapped(Vector2(0.1, 0.1))
	velocity_direction *= speed
	velocity = velocity_direction
	
	var pre_position = position
	move_and_slide()
	var pos_position = position
	
	step_length = pre_position.distance_to(pos_position)
