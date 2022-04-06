tool
extends ColorRect


export(String) var key
export(String) var ability_name


func _ready():
	$Key.text = key
	$AbilityName.text = ability_name
	
	Server.connect("packet_received", self, "_on_packet_received")


func _on_packet_received(packet: Dictionary) -> void:
	if(packet.type == Constants.PacketTypes.ABILITY_USED):
		if packet.key == key && packet.id == Lobby.my_id:
			_set_used()


func _set_used() -> void:
	color = Color(0.5,0.5,0.5,0.7)
