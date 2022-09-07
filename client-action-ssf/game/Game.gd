extends Node2D


var player_scene = preload("res://entities/Player.tscn")
var scammer_scene = preload("res://entities/Scammer.tscn")


onready var Camera: Camera2D = $Camera
onready var Entities = $Entities
onready var WinScreen = $CanvasLayer/WinScreen
onready var AbilityEffects = $AbilityEffects


var nodes_freed: Array = []
var total_nodes: int = 0


func _ready():
	Lobby.emit_signal("game_has_loaded", self)
	Server.connect("packet_received", self, "_on_packet_received")
	
	for e in Entities.get_children():
		var entity: Node2D = e
		if entity.get("node_id") != null: # is freeable node
			total_nodes += 1


func _on_packet_received(packet: Dictionary):
	match(packet.type):
		Constants.PacketTypes.NODE_FREED:
			if nodes_freed.find(packet.id) == -1:
				nodes_freed.append(packet.id)
				if nodes_freed.size() == total_nodes:
					WinScreen.set_visible(true)


func generate_players(player_data: Array) -> void:
	var spawn_scammer: bool = true
	var amount_players: int 
	var scammer_i: int
	var player_spawn_pos: Vector2 = $PlayerSpawnPoints.get_child(randi() % $PlayerSpawnPoints.get_child_count()).global_position
	var scammer_spawn_pos: Vector2 = $ScammerSpawnPoints.get_child(randi() % $ScammerSpawnPoints.get_child_count()).global_position
	for data in player_data:
		if data.class == "Romance Scammer":
			spawn_scammer = false
			var scammer = scammer_scene.instance()
			scammer.set_scammer_data(data.id, scammer_spawn_pos, data.class, false, scammer_i)
			Entities.add_child(scammer)
			scammer_i += 1
			if data.id == Lobby.my_id:
				Events.emit_signal("follow_w_camera", scammer)
		else:
			amount_players += 1
			var player = player_scene.instance()
			player.set_players_data(data.id, data.name, player_spawn_pos, data.class, false)
			Entities.add_child(player)
			if data.id == Lobby.my_id:
				Events.emit_signal("follow_w_camera", player)
	
	if amount_players < Constants.PLAYERS_PER_ROOM:
		Lobby.bot_amount = Constants.PLAYERS_PER_ROOM - amount_players
		for i in Constants.PLAYERS_PER_ROOM - amount_players:
			var player = player_scene.instance()
			player.set_players_data("player_bot_" + str(i), "SSF Bot " + str(i), player_spawn_pos, "Sam the Sniper", true)
			Entities.add_child(player)
	
	if spawn_scammer == true:
		var scammer = scammer_scene.instance()
		scammer.set_scammer_data("scammer_ai", scammer_spawn_pos, "Romance Scammer", true, 0)
		Entities.add_child(scammer)
