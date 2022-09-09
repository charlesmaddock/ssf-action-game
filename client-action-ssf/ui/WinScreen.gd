extends ColorRect


onready var winLabel = $Label2


func _ready():
	Events.connect("game_win", self, "_on_game_win")


func _on_game_win(reason: String) -> void:
	set_visible(true)
	if reason == "nodes":
		winLabel.text = "They freed all the computer's parts!"
	else:
		winLabel.text = "They managed to beat the clock."

