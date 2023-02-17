extends CanvasLayer


onready var ErrorMessageLabel = $Control/PanelContainer/MarginContainer/VBoxContainer/Label  


func _ready():
	get_child(0).set_visible(false)
	Events.connect("show_error_panel", self, "_on_show_error_panel")


func _on_show_error_panel(msg: String):
	get_child(0).set_visible(true)
	ErrorMessageLabel.text = msg


func _on_Button_pressed():
	Events.emit_signal("back_to_main_menu")
