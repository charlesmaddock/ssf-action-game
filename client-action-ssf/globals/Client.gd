extends Node


enum UIInteractionModes {
	UI,
	GAMEPLAY
}


const SAVE_PATH = "user://client_data.json"


var _my_account: Account = null
var _access_token: String = ""
var _refresh_token: String = ""


var dev_tools_on: bool = false
var requested_spawn_pos: Vector2
var ui_interaction_mode: int


onready var AccessTokenExpiredCheck: Timer = $AccessTokenExpiredChecker
onready var RefreshHTTPRequest: CustomHTTPRequest = $RefreshHTTPRequest


func _ready():
	Events.connect("logged_out", self, "_on_logged_out")
	Events.connect("back_to_main_menu", self, "_on_back_to_main_menu")
	API.connect("packet_received", self, "_on_packet_received")


func _on_packet_received(event: String, data: Dictionary):
	if event == "worldLeft":
		Events.emit_signal("back_to_main_menu")
	if event == "worldJoined": 
		get_tree().change_scene("res://game/Game.tscn")


func _on_RefreshHTTPRequest_request_completed(result, response_code, headers, body):
	if response_code >= 200 && response_code < 300:
		print("Updated access token")
		handle_authenticated(body)
	else:
		Events.emit_signal("no_refresh_token")


func _on_logged_out() -> void:
	_access_token = ""
	_my_account = null
	save_data("")


func _on_back_to_main_menu() -> void:
	get_tree().change_scene("res://ui/MainMenu.tscn")


func _on_AccessTokenExpiredChecker_timeout():
	var time_left = check_token_time_left(_access_token)
	if time_left < AccessTokenExpiredCheck.wait_time + (60 * 2):
		check_refresh_token_expiration()


func get_access_token() -> String:
	return _access_token


func get_my_account() -> Account:
	return _my_account


func get_my_player():
	return get_tree().get_root().get_node("Game/Entities").get_my_entity()


func set_ui_interaction_mode(interaction_mode):
	ui_interaction_mode = interaction_mode


func is_mine(id: String) -> bool:
	return _my_account.id == id


func handle_authenticated(http_body: PoolByteArray):
	var json = JSON.parse(http_body.get_string_from_utf8())
	
	_access_token = json.result.accessToken
	_refresh_token = json.result.refreshToken
	save_data(_refresh_token)
	
	var jwt_payload = get_jwt_payload(_refresh_token)
	_my_account = Account.new(jwt_payload.id, jwt_payload.username)
	
	Events.emit_signal("authenticated", _my_account)


func try_load_data() -> String:
	var file: File = File.new()
	
	if file.file_exists(SAVE_PATH):
		file.open(SAVE_PATH, File.READ)
		var text = file.get_as_text()
		var data = JSON.parse(text)
		if data.result.has("refresh_token"):
			_refresh_token = data.result.refresh_token
			return _refresh_token
		file.close()
	
	return ""


func save_data(token: String) -> void:
	var file: File = File.new()
	file.open(SAVE_PATH, File.WRITE)
	file.store_line(to_json({"refresh_token": token}))
	file.close()


func check_refresh_token_expiration() -> bool:
	var refresh_token = try_load_data()
	var refresh_token_expired = check_token_expired(refresh_token)
	
	if refresh_token_expired == false:
		var body: Dictionary = {"refreshToken": _refresh_token}
		RefreshHTTPRequest.post_request("/auth/refresh", body)
		return false
	else:
		return true


func check_token_expired(jwt: String) -> bool:
	if jwt == "":
		return true
	
	var payload = get_jwt_payload(jwt)
	
	var current_unix = OS.get_unix_time()
	var has_expired = current_unix > payload.exp
	var diff_s = payload.exp - current_unix
	print(diff_s , " seconds left until expiration")
	
	return has_expired


func check_token_time_left(jwt: String) -> int:
	if jwt == "":
		return 0
	
	var payload = get_jwt_payload(jwt)
	
	var current_unix = OS.get_unix_time()
	var has_expired = current_unix > payload.exp
	var diff_s = payload.exp - current_unix
	
	return int(diff_s)


func get_jwt_payload(jwt: String):
	var parts = jwt.split(".")
	var payload_string = base64URL_decode(parts[1]).get_string_from_utf8()
	var parse_result: JSONParseResult = JSON.parse(payload_string)
	if parse_result.result != null:
		return parse_result.result


func base64URL_decode(input: String) -> PoolByteArray:
	match (input.length() % 4):
		2: input += "=="
		3: input += "="
	return Marshalls.base64_to_raw(input.replacen("_","/").replacen("-","+"))

