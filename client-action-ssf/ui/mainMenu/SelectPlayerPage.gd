extends Control


onready var NameLabel = $HBoxContainer/VBoxContainer/PlayersDisplay/MarginContainer/VBox/Name
onready var PlayerContainer = $HBoxContainer/VBoxContainer/PlayersDisplay/MarginContainer/VBox/PlayerContainer
onready var CreateNewPlayerButton = $HBoxContainer/VBoxContainer/PlayersDisplay/MarginContainer/VBox/CreateNewPlayer
onready var SpawnNorthLineEdit = $HBoxContainer/VBoxContainer/PlayersDisplay/MarginContainer/VBox/PlayerContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/SpawnNorthLineEdit
onready var SpawnEastLineEdit = $HBoxContainer/VBoxContainer/PlayersDisplay/MarginContainer/VBox/PlayerContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/SpawnEastLineEdit


func _ready():
	Events.connect("authenticated", self, "_on_authenticated")


func _on_authenticated(account: Account) -> void:
	NameLabel.text = "Welcome " + account.username


func _on_EnterWorldButton_button_down():
	var requested_spawn_pos = Vector2(int(SpawnEastLineEdit.text), int(SpawnNorthLineEdit.text))
	API.requestSpawnPlayer(requested_spawn_pos)


func _on_CreateNewPlayer_button_down():
	CreateNewPlayerButton.set_visible(false)
	PlayerContainer.set_visible(true)
