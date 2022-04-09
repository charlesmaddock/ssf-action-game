extends Node


func get_game_node() -> Node:
	return get_node("/root/Game")


func get_nav_points() -> Array:
	return get_node("/root/Game/RoomNavPoints").get_children()


func get_players() -> Array:
	var entities = get_node("/root/Game/Entities").get_children()
	var players = []
	for e in entities:
		if e.has("is_player"):
			players.append(e)
	return players


func get_sprite_for_class(className: String) -> Texture:
	for info in Constants.class_info:
		if info.name == className:
			return info.tex
	
	return null
