extends Node2D


var player_scene = preload("res://entities/Player.tscn")
var scammer_scene = preload("res://entities/Scammer.tscn")


onready var Camera: Camera2D = $Camera
onready var Entities = $Entities
onready var FreedNodesLabel = $Camera/CanvasLayer/Panel/Label
onready var WinScreen = $Camera/CanvasLayer/WinScreen


var nodes_freed: Array = []
var total_nodes: int = 0


func _ready():
	Lobby.emit_signal("game_has_loaded", self)
	Server.connect("packet_received", self, "_on_packet_received")
	
	for e in Entities.get_children():
		var entity: Node2D = e
		if entity.get("node_id") != null: # is freeable node
			total_nodes += 1
	set_nodes_freed_text()


func _on_packet_received(packet: Dictionary):
	match(packet.type):
		Constants.PacketTypes.NODE_FREED:
			if nodes_freed.find(packet.id) == -1:
				nodes_freed.append(packet.id)
				set_nodes_freed_text()
				if nodes_freed.size() == total_nodes:
					WinScreen.set_visible(true)


func set_nodes_freed_text():
	FreedNodesLabel.text = str(nodes_freed.size()) + "/" + str(total_nodes) 


func get_players() -> Array:
	var players: Array = []
	for entity in Entities.get_children():
		if entity.get("Sprite") != null:
			players.append(entity)
	
	return players


func generate_players(player_data: Array) -> void:
	var spawn_scammer: bool = true
	for data in player_data:
		if data.class == "Romance Scammer":
			spawn_scammer = false
			var scammer = scammer_scene.instance()
			Entities.add_child(scammer)
			scammer.set_scammer_data(data.id, data.pos, data.class, false)
			if data.id == Lobby.my_id:
				Camera.set_follow(scammer)
		else:
			var player = player_scene.instance()
			player.set_players_data(data.id, data.pos, data.class)
			Entities.add_child(player)
			if data.id == Lobby.my_id:
				Camera.set_follow(player)
	
	if spawn_scammer == true:
		var scammer = scammer_scene.instance()
		scammer.global_position = Vector2(128, -265)
		Entities.add_child(scammer)
