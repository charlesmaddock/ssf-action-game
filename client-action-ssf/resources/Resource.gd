extends Node2D


func init(resource_data: Dictionary):
	var resource_type = resource_data.type
	if resource_type == "tree":
		$Tree.set_visible(true)
	elif resource_type == "bush":
		$Bush.set_visible(true)
	elif resource_type == "mushroom":
		$Mushroom.set_visible(true)
	
	global_position = Vector2(resource_data.x, resource_data.y)
