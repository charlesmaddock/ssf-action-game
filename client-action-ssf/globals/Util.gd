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


func is_building(node) -> bool:
	return node.get("harvested_item") != null


func get_highest_priority_made_of_resource(made_of: Array) -> Dictionary:
	var highest_prio_resource = null
	var curr_prio = 99999
	
	if made_of.size() == 0:
		return ResourceConstants.resource_info[-1]
	
	for made_of_data in made_of:
		var res_info = ResourceConstants.resource_info[int(made_of_data.resource)]
		if res_info.name_priority < curr_prio:
			curr_prio = res_info.name_priority
			highest_prio_resource = res_info
	
	return highest_prio_resource


func get_joy_stick():
	return get_tree().get_root().get_node("Game").JoyStick


func get_entity(id: String):
	if is_instance_valid(entities) == false:
		entities = get_tree().get_root().get_node_or_null("Game/Entities")
		
		if entities == null:
			printerr("Couldn't get entities!")
	
	if entities != null:
		return entities.get_entity(id)


func get_extents_from_texture(texture: Texture, trim_edge: bool = false) -> Vector2:
	var width = texture.get_width()
	var height = texture.get_height()
	
	var extents = Vector2(width / 2, height / 2)
	
	if trim_edge:
		extents -= Vector2(0.1, 0.1)
	
	return extents
