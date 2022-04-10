extends Panel


onready var label = $Label


var dead_player_ids: Array
var nodes_freed: Array = []
var total_nodes: int = 0


func _ready():
	Events.connect("player_dead", self, "_on_player_dead")
	Server.connect("packet_received", self, "_on_packet_received")
	
	$ChipSprite.set_visible(Lobby.my_client_data.class != "Romance Scammer")
	$PlayerSprite.set_visible(Lobby.my_client_data.class == "Romance Scammer")
	
	for e in Util.get_game_node().get_node("Entities").get_children():
		var entity: Node2D = e
		if entity.get("node_id") != null: # is freeable node
			total_nodes += 1
	
	yield(get_tree(), "idle_frame")
	set_objective_text()


func _on_packet_received(packet: Dictionary):
	match(packet.type):
		Constants.PacketTypes.NODE_FREED:
				if nodes_freed.find(packet.id) == -1:
					nodes_freed.append(packet.id)
					set_objective_text()


func set_objective_text():
	if Lobby.my_client_data.class != "Romance Scammer":
		label.text = str(nodes_freed.size()) + "/" + str(total_nodes) 
	else:
		label.text = str(dead_player_ids.size()) + "/" + str(Lobby.get_amount_good_guys() + Lobby.bot_amount)


func _on_player_dead(id) -> void:
	if dead_player_ids.find(id) == -1:
		dead_player_ids.append(id)
		set_objective_text()
