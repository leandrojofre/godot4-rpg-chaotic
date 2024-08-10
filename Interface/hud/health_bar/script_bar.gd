extends HBoxContainer

@onready var SceneHeart = preload("res://Interface/hud/health_bar/scene_heart.tscn")

func get_health_points(hearts: Array[Node]) -> int:
	var healthPoints: int = 0
	
	for heart in hearts:
		healthPoints += heart.get_heart_points()
	
	return healthPoints

func set_max_health(max_health: int):
	var hearts = get_children()
	
	for heart in hearts:
		heart.queue_free()
	
	for i in range(max_health):
		if not i % 2 == 0: continue
		
		var heart = SceneHeart.instantiate()
		add_child(heart)

func modify_hearts(hearts: Array[Node], health_correction: int, points_to_skip: String):	
	for heart in hearts:
		if health_correction == 0: return
		if heart.check_health_points(heart[points_to_skip]): continue
		
		health_correction = heart.update_sprite(health_correction)

func update_health(parent_health: int):
	var hearts: Array[Node] = get_children()
	var healthPoints: int = get_health_points(hearts)
	var healthCorrection: int = healthPoints - parent_health
	
	if healthCorrection > 0:
		modify_hearts(hearts, healthCorrection, "max_frame")
	if healthCorrection < 0:
		hearts.reverse()
		modify_hearts(hearts, healthCorrection, "min_frame")
