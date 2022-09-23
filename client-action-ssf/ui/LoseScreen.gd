extends ColorRect


var game_finished: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("game_over", self, "_on_game_over")
	Events.connect("game_win", self, "_on_game_win")
	set_visible(false)


func _on_game_over():
	if game_finished == false:
		game_finished = true
		set_visible(true)


func _on_game_win(_reason: String) -> void:
	game_finished = true
