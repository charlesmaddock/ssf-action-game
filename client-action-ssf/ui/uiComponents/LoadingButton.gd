extends Button
tool


export(bool) var load_on_click = true
export(String) var default_text = ""


onready var animation_player = $AnimationPlayer


func _ready():
	text = default_text


func _on_LoadingButton_pressed():
	if load_on_click: 
		set_loading(true)


func set_loading(loading: bool):
	if loading == true:
		animation_player.play("loading")
		disabled = true
	else:
		animation_player.stop()
		text = default_text
		disabled = false
