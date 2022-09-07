extends Node2D


func _on_OpenTimer_timeout():
	if Lobby.is_host:
		Server.start_doors()
