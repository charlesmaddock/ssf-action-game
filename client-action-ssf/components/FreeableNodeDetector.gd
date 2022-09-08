extends Area2D


export(NodePath) var suckSpritePath: NodePath
var areas: Array = []


func _on_FreeableNodeDetector_area_entered(area):
	areas.append(area)


func _on_FreeableNodeDetector_area_exited(area):
	areas.erase(area)


func _physics_process(_delta):
	checkSuck()


func checkSuck() -> void:
	var all_freed = true
	for area in areas:
		if area.get_parent().has_method("get_is_freed"):
			if area.get_parent().get_is_freed() == false:
				all_freed = false
	
	get_node(suckSpritePath).set_visible(!all_freed)
