extends ColorRect


onready var winLabel = $Label2


var game_finished: bool = false


func _ready():
	Events.connect("game_win", self, "_on_game_win")
	Events.connect("game_over", self, "_on_game_over")


func _on_game_win(reason: String) -> void:
	if game_finished == false:
		game_finished = true
		
		set_visible(true)
		if reason == "nodes":
			winLabel.text = "They freed all the computer's parts!"
		else:
			winLabel.text = "They managed to beat the clock."
		


func _on_game_over() -> void:
	game_finished = true
