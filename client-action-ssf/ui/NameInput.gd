extends LineEdit


func _ready():
	if Lobby.my_client_data.has("name"):
		print("my_client_data: ", Lobby.my_client_data)
		text = Lobby.my_client_data.name


func _on_NameInput_text_changed(new_text):
	var new_client_data = Lobby.my_client_data.duplicate(true)
	new_client_data.name = new_text
	Server.req_update_client_data(new_client_data)


func _on_NameInput_focus_exited():
	var new_client_data = Lobby.my_client_data.duplicate(true)
	new_client_data.name = text
	Server.req_update_client_data(new_client_data)
