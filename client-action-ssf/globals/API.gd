extends Node


onready var ws_api_url = "ws://localhost:8081" if Constants.app_mode == Constants.AppMode.DEVELOPMENT else "wss://rivernotch.com/ws"
onready var http_api_url = "http://localhost:3333/api" if Constants.app_mode == Constants.AppMode.DEVELOPMENT else "https://rivernotch.com/api"


var _client = WebSocketClient.new()


signal packet_received(event, data)


func _ready():
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_error")
	_client.connect("server_close_request", self, "_request_close")
	_client.connect("connection_established", self, "_connected")
	_client.connect("data_received", self, "_on_data")
	
	yield(get_tree(), "idle_frame")
	Events.emit_signal("console_message", "Connecting to server...", Constants.ConsoleMessageTypes.LOG)


func _error():
	print("Error connecting")
	Events.emit_signal("show_error_panel", "Couldn't connect to the server.")


func _request_close(code: int, reason: String):
	if code == 1006:
		Events.emit_signal("show_error_panel", "You were afk for too long.")
	else:
		Events.emit_signal("show_error_panel", "Network error " + str(code) + ": " + reason)


func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("Closed, clean: ", was_clean)
	set_process(false)
	Events.emit_signal("show_error_panel", "A Network error occured. Try rejoining later.")
	
	if Constants.app_mode == Constants.AppMode.DEVELOPMENT:
		get_tree().quit()
	else:
		Events.emit_signal("console_message", "Couldn't connect to server with the url " + ws_api_url, Constants.ConsoleMessageTypes.ERROR)


func _connected(proto = ""):
	send_packet(WsEvents.connect, {})
	Events.emit_signal("console_message", "Connected successfully.", Constants.ConsoleMessageTypes.SUCCESS)


func _on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	var packet = _client.get_peer(1).get_packet().get_string_from_utf8()
	var jsonRes: JSONParseResult = JSON.parse(packet)
	var res = jsonRes.result
	emit_signal("packet_received", res.event, res.data)


func _process(delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()


func attempt_connect():
	var err = _client.connect_to_url(ws_api_url)
	if err == ERR_ALREADY_IN_USE:
		print("The websocket is already connected.")
	elif err != OK:
		Events.emit_signal("console_message", "Can not make initial connection to server.", Constants.ConsoleMessageTypes.ERROR)
		set_process(false)


func send_packet(event: String, data: Dictionary = {}, useAccessToken: bool = false) -> void:
	var packet = {
		"event": event, 
		"data": data, 
	}
	
	if useAccessToken == true:
		packet.data.accessToken = Client.get_access_token()
	
	var json = JSON.print(packet)
	_client.get_peer(1).put_packet(json.to_utf8())


func joinWorld(requested_spawn_pos: Vector2) -> void:
	send_packet(WsEvents.joinWorld, {"x": requested_spawn_pos.x, "y": requested_spawn_pos.y}, true)


func leave_world() -> void:
	send_packet(WsEvents.leaveWorld, {}, true)


func send_input(input_vec: Vector2) -> void:
	send_packet(WsEvents.setMoveInput, {"x": input_vec.x, "y": input_vec.y}, true)


func send_chat(text: String) -> void:
	send_packet(WsEvents.sendChat, {"text": text}, true)
