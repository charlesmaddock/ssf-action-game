extends Control


onready var Welcome = $Welcome
onready var LobbyNode = $Lobby

onready var CodeInput = $Welcome/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/CodeInput
onready var CodeLabel = $Lobby/HBoxContainer/VBoxContainer/CodeLabel
onready var PlayerInfoContainer = $Lobby/HBoxContainer/VBoxContainer/PlayerInfoContainer
onready var ErrorLabel = $Welcome/ErrorLabel

var _lobby_client_info: Array = []


func _ready():
	show_page(Welcome)
	Server.connect("packet_received", self, "_on_packet_received")
	Events.connect("error_message", self, "_on_error_message")


func _on_error_message(msg: String) -> void:
	ErrorLabel.text = msg


func _on_packet_received(packet: Dictionary) -> void:
	match(packet.type):
		Constants.PacketTypes.ROOM_JOINED:
			show_page(LobbyNode)
			set_lobby(packet)


func set_lobby(packet: Dictionary) -> void:
	CodeLabel.text = "Rooms code: " + str(packet.code)
	_lobby_client_info = packet.client_info
	
	for playerInfoPanel in PlayerInfoContainer.get_children():
		playerInfoPanel.clear()
	
	for i in _lobby_client_info.size():
		var playerInfoPanel = PlayerInfoContainer.get_child(i)
		var info = _lobby_client_info[i]
		playerInfoPanel.set_player_info(info.name, info.id, info.className)


func show_page(page: Control) -> void:
	for page in get_children():
		page.set_visible(false)
	
	page.set_visible(true)


func _on_Button2_pressed():
	pass # Replace with function body.


func _on_JoinButton_pressed():
	Server.join(CodeInput.text)


func _on_HostButton_pressed():
	Server.host()


func _on_StartButton_pressed():
	Server.start()


func _on_CopyCodeButton_pressed():
	OS.set_clipboard(Lobby.room_code)
