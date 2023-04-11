extends Node


func _physics_process(delta):
	if get_viewport().size.x < 1000:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D,  SceneTree.STRETCH_ASPECT_EXPAND, Vector2(get_viewport().size.x, get_viewport().size.y), 1.7)
	else:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D,  SceneTree.STRETCH_ASPECT_EXPAND, Vector2(1280,720), 1)


func is_small_screen():
	return get_viewport().size.x < 1000
