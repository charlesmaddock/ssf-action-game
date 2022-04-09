extends Panel


func _physics_process(delta):
	if Input.is_key_pressed(KEY_M):
		set_visible(true)
	else:
		set_visible(false)
