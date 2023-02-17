extends LineEdit


onready var ToggleVisibleButton = $ToggleVisible


func _on_ToggleVisible_toggled(button_pressed):
	if button_pressed == true:
		ToggleVisibleButton.text = "hide"
		secret = false
	else:
		ToggleVisibleButton.text = "show"
		secret = true
