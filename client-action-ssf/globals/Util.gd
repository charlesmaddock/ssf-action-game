extends Node


func get_nav_points() -> Array:
	return get_node("/root/Game/RoomNavPoints").get_children()
