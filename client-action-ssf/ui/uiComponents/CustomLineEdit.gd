extends LineEdit


export(bool) var is_password = false


onready var ToggleVisibleButton = $ToggleVisible


func _ready():
	ToggleVisibleButton.visible = is_password
	secret = is_password
	connect("focus_entered", self, "js_text_entry")


func _on_ToggleVisible_toggled(button_pressed):
	if button_pressed == true:
		ToggleVisibleButton.text = "hide"
		secret = false
	else:
		ToggleVisibleButton.text = "show"
		secret = true


func js_text_entry():
	if OS.has_feature('JavaScript') && Util.is_mobile():
		text = JavaScript.eval("""window.prompt('Enter """ + placeholder_text + """')""")
		
		release_focus()
