extends Node


var has_used_touch: bool = false 


func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		has_used_touch = true


func is_mobile() -> bool:
	return has_used_touch
