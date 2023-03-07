extends Node


var has_used_touch: bool = false 
var entities = null


func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		has_used_touch = true


func is_mobile() -> bool:
	return has_used_touch


func is_entity(node) -> bool:
	return node.get("is_high_detail_entity") != null


func get_joy_stick():
	return get_tree().get_root().get_node("Game").JoyStick


func get_entity(id: String):
	if is_instance_valid(entities) == false:
		entities = get_tree().get_root().get_node_or_null("Game/Entities")
		
		if entities == null:
			printerr("Couldn't get entities!")
	
	if entities != null:
		return entities.get_entity(id)
