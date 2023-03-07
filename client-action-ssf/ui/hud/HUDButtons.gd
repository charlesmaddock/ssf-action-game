extends HBoxContainer


export(bool) var is_desktop_buttons


func _ready():
	set_visible(!is_desktop_buttons && Util.is_mobile() || is_desktop_buttons && !Util.is_mobile())


func _on_ChatButton_pressed():
	Events.emit_signal("chat_button_pressed")


func _on_ZoomOutButton_pressed():
	Events.emit_signal("zoom_out_button_pressed")


func _on_ZoomInButton_pressed():
	Events.emit_signal("zoom_in_button_pressed")


func _on_InventoryButton_pressed():
	Events.emit_signal("open_inv_button_pressed")


func _on_SettingsButton_pressed():
	Events.emit_signal("settings_button_pressed")
