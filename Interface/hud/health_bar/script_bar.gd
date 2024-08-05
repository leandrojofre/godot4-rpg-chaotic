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

func update_health(parent_health: int):
	var hearts = get_children()
	var healthPoints: int = get_health_points(hearts)
	var healthCorrection = healthPoints - parent_health
	
	if healthCorrection < 0:
		print("ERROR: Health correction has a negative value: ", healthCorrection)
		print("-healthPoints: ", healthPoints)
		print("-parent_health: ", parent_health)
		return
	
	for heart in hearts:
		if healthCorrection == 0: break
		if heart.is_heart_empty(): continue
		
		healthCorrection = heart.update_sprite(healthCorrection)
