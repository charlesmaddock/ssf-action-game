extends Node


var mainMenuScene = preload("res://ui/MainMenu.tscn")
var gameScene = preload("res://game/Game.tscn")


var room_code: String = ""
var my_id: String = ""
var is_host: bool
var players_data: Array


signal game_has_loaded(game_node)


func _ready():
	Server.connect("packet_received", self, "_on_packet_recieved")
	connect("game_has_loaded", self, "_on_game_loaded")


func _on_packet_recieved(packet: Dictionary) -> void:
	match(packet.type):
		Constants.PacketTypes.CONNECTED:
			my_id = packet.id
		Constants.PacketTypes.ROOM_HOSTED:
			is_host = true
		Constants.PacketTypes.ROOM_JOINED:
			room_code = packet.code
		Constants.PacketTypes.GAME_STARTED:
			handle_game_started(packet) 
		Constants.PacketTypes.ROOM_LEFT:
			handle_room_left(packet)


func handle_room_left(packet: Dictionary) -> void:
	if my_id == packet.id:
		room_code = ""
		is_host = false
		players_data.clear()
		get_tree().change_scene_to(mainMenuScene)


func handle_game_started(packet: Dictionary) -> void:
	print("players_data: ", packet.players)
	players_data = packet.players
	
	get_tree().change_scene_to(gameScene)
	# Now we wait for _on_game_loaded


func _on_game_loaded(game_node: Node2D) -> void:
	game_node.generate_players(players_data)
