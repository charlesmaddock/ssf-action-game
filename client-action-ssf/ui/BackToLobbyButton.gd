extends Button


func _ready():
	set_visible(Lobby.is_host)


func _on_BackToLobby_pressed():
	Server.back_to_lobby()
