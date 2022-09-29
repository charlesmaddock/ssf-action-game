extends Control


onready var titleLabel = $Title
onready var descLabel = $Desc
onready var nextGameLabel = $NextGameLabel
onready var nextGameTimer = $NextGameTimer


var game_finished: bool = false


func _ready():
	Events.connect("game_win", self, "_on_game_win")
	Events.connect("game_over", self, "_on_game_over")
	
	show_buttons(false)
	set_visible(false)
	$WinScreen.set_visible(false)
	$LoseScreen.set_visible(false)


func _process(delta):
	nextGameLabel.text = "Rematch begins in " + str(ceil(nextGameTimer.time_left)) + "..."


func _on_game_win(reason: String) -> void:
	if game_finished == false:
		game_finished = true
		
		nextGameTimer.start()
		
		show_buttons(true)
		set_visible(true)
		$WinScreen.set_visible(true)
		
		titleLabel.text = "The Security Heroes Won!"
		if reason == "nodes":
			descLabel.text = "They freed all the computer's parts!"
		else:
			descLabel.text = "They managed to beat the clock."


func _on_game_over() -> void:
	if game_finished == false:
		game_finished = true
		
		nextGameTimer.start()
		
		show_buttons(true)
		set_visible(true)
		$LoseScreen.set_visible(true)
		titleLabel.text = "The Scammers won."
		descLabel.text = "They eliminated all the Security Heroes."


func _on_NextGameTimer_timeout():
	if Lobby.is_host:
		Server.start()


func show_buttons(visible: bool) -> void:
	if visible == true:
		yield(get_tree().create_timer(3), "timeout")
	nextGameLabel.set_visible(visible)
	$RestartButton.set_visible(visible)
	$BackToLobby.set_visible(visible)
	$LeaveButton.set_visible(visible)
