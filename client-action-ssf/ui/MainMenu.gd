extends Control


onready var Welcome = $Welcome
onready var LobbyNode = $Lobby

onready var CodeInput = $Welcome/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/CodeInput
onready var CodeLabel = $Lobby/HBoxContainer/VBoxContainer/CodeWrapper/CodeLabel
onready var PlayerInfoContainer = $Lobby/HBoxContainer/VBoxContainer/TeamsContainer/GoodGuys/PlayerInfoContainer
onready var ErrorLabel = $Welcome/ErrorLabel
onready var StartButton = $Lobby/HBoxContainer/VBoxContainer/StartButton


var _lobby_client_data: Array = []


func _ready():
	show_page(Welcome)
	Server.connect("packet_received", self, "_on_packet_received")
	Events.connect("error_message", self, "_on_error_message")
	OS.set_screen_orientation(OS.SCREEN_ORIENTATION_LANDSCAPE)


func _on_error_message(msg: String) -> void:
	ErrorLabel.text = msg


func _input(event):
	if Input.is_key_pressed(KEY_CONTROL) && Input.is_key_pressed(KEY_Z):
		Server.join("random")


func _on_packet_received(packet: Dictionary) -> void:
	match(packet.type):
		Constants.PacketTypes.ROOM_JOINED:
			show_page(LobbyNode)
			set_lobby(packet)


func set_lobby(packet: Dictionary) -> void:
	CodeLabel.text = "Rooms code: " + str(packet.code)
	_lobby_client_data = packet.clientData
	
	StartButton.set_visible(Lobby.is_host)
	
	for playerInfoPanel in PlayerInfoContainer.get_children():
		playerInfoPanel.clear()
	
	for i in _lobby_client_data.size():
		var playerInfoPanel = PlayerInfoContainer.get_child(i)
		playerInfoPanel.set_player_info(_lobby_client_data[i])


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
