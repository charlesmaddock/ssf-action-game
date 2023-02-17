extends Control


onready var NameLabel = $HBoxContainer/VBoxContainer/PlayersDisplay/MarginContainer/VBox/Name
onready var PlayerContainer = $HBoxContainer/VBoxContainer/PlayersDisplay/MarginContainer/VBox/PlayerContainer
onready var CreateNewPlayerButton = $HBoxContainer/VBoxContainer/PlayersDisplay/MarginContainer/VBox/CreateNewPlayer


func _ready():
	Events.connect("authenticated", self, "_on_authenticated")


func _on_authenticated(account: Account) -> void:
	NameLabel.text = "Welcome " + account.username


func _on_EnterWorldButton_button_down():
	get_tree().change_scene("res://game/Game.tscn")


func _on_CreateNewPlayer_button_down():
	CreateNewPlayerButton.set_visible(false)
	PlayerContainer.set_visible(true)
