extends Node


var has_used_touch: bool = false 


func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		has_used_touch = true


func is_mobile() -> bool:
	return has_used_touch


func get_game_node() -> Node:
	return get_node("/root/Game")


func get_nav_points() -> Array:
	return get_node("/root/Game/RoomNavPoints").get_children()


func get_living_players() -> Array:
	var entities = get_node("/root/Game/Entities").get_children()
	var players = []
	for e in entities:
		if e.get("is_player") != null && e.visible == true:
			players.append(e)
	return players


func get_sprite_for_class(className: String) -> Texture:
	for info in Constants.class_info:
		if info.name == className:
			return info.tex
	
	return null
