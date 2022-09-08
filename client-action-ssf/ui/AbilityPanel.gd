tool
extends Control


export(String) var key
export(Texture) var button_text


func _ready():
	Server.connect("packet_received", self, "_on_packet_received")
	
	$ButtonText.texture = button_text
	$ButtonTextPressed.texture = button_text
	
	$ButtonPressed.set_visible(false)
	$ButtonTextPressed.set_visible(false)
	
	if Lobby.my_client_data.class == "Romance Scammer":
		set_visible(false)


func _on_packet_received(packet: Dictionary) -> void:
	if(packet.type == Constants.PacketTypes.ABILITY_USED):
		if packet.key == key && packet.id == Lobby.my_id:
			_set_used()


func _set_used() -> void:
	$Button.set_visible(false)
	$ButtonText.set_visible(false)
	$ButtonPressed.set_visible(true)
	$ButtonTextPressed.set_visible(true)
	modulate = Color(0.5,0.5,0.5,0.6)


func _on_TouchScreenButton_pressed():
	Server.use_ability(key, Lobby.my_id)
