extends CharacterBody2D

@export var speed = 240
@export var run_multiplier = 2.0
@export var max_health: int = 5
@export var knockback_force = 580

@onready var Animations = $AnimatedSprite2D
@onready var HealthBar = $Camera2D/HealthBar
@onready var VisualEffects = $VisualEffects
@onready var ImmunityTimer = $ImmunityTimer
@onready var HitBox = $HitBox

var velocity_direction
var current_health: int

func _ready():
	current_health = max_health
	HealthBar.set_max_health(max_health)
	HealthBar.update_health(current_health)
	set_motion_mode(CharacterBody2D.MOTION_MODE_FLOATING)

func select_animation():
	if velocity_direction.x > 0:
		Animations.flip_h = false
	elif velocity_direction.x < 0:
		Animations.flip_h = true
	
	if Input.is_action_pressed("run") and Input.is_action_pressed("key-down"):
		Animations.play("run")
		velocity_direction *= run_multiplier
	elif Input.is_action_pressed("key-down"):
		Animations.play("walk")
	else: Animations.play("idle")

func _physics_process(_delta):
	var inputDirection_x = float(Input.is_action_pressed("right")) - float(Input.is_action_pressed("left"))
	var inputDirection_y = float(Input.is_action_pressed("down")) - float(Input.is_action_pressed("up"))
	var inputDirection = Vector2(inputDirection_x, inputDirection_y)
	
	velocity_direction = inputDirection.limit_length().snapped(Vector2(0.1, 0.1))
	velocity_direction *= speed
	
	select_animation()
	
	velocity = velocity_direction
	
	move_and_slide()

func update_health(health_correction: int):
	current_health += health_correction
	
	if current_health <= 0:
		current_health = max_health
		HealthBar.set_max_health(max_health)
	if current_health > max_health:
		current_health = max_health
		HealthBar.set_max_health(max_health)
		
	HealthBar.update_health(current_health)

func knockback(threat_position: Vector2):
	var knockbackDirection = threat_position.direction_to(position)
	
	knockbackDirection = knockbackDirection.limit_length().snapped(Vector2(0.1, 0.1))
	knockbackDirection *= knockback_force
	
	velocity = knockbackDirection
	
	move_and_slide()

func take_damage(area: Area2D):
	if not ImmunityTimer.is_stopped(): return
	
	var enemy = area.get_parent()
	
	update_health(enemy.get_damage())
	knockback(enemy.position)
	
	ImmunityTimer.start()
	VisualEffects.play("take-damage")

func _on_hit_box_area_entered(area):
	if area.name == "HitBox": take_damage(area)
	if area.has_method("collect"): area.collect(self)

func _on_immunity_timer_timeout():
	VisualEffects.play("RESET")
	
	var collisions = HitBox.get_overlapping_areas()
	
	collisions.filter(func(area): return area.name == "HitBox")
	
	for collision in collisions:
		if HitBox.overlaps_area(collision): return _on_hit_box_area_entered(collision)
