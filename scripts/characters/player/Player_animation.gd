extends AnimatedSprite2D

func select_animation():
	
	if Input.is_action_pressed("run"): play("run")
	else : play("walk")
	
	if Input.is_action_just_pressed("left"):
		flip_h = true
		return
	elif Input.is_action_just_pressed("right"):
		flip_h = false
		return

func _input(event):
	
	if event.get_class() == "InputEventKey":
		if event.is_pressed():
			select_animation()
			return
		elif not Input.is_action_pressed("key-down"):
			set_animation("idle")
			return
