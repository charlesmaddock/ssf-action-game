extends Button


export(bool) var load_on_click = true


onready var default_text = text


func _on_LoadingButton_pressed():
	if load_on_click: 
		set_loading(true)


func set_loading(loading: bool):
	if loading == true:
		text = "loading..."
		disabled = true
	else:
		text = default_text
		disabled = false
