extends HBoxContainer


func _on_SettingsButton_button_down():
	Events.emit_signal("settings_button_pressed")


func _on_ChatButton_button_down():
	Events.emit_signal("chat_button_pressed")


func _on_InventoryButton_button_down():
	Events.emit_signal("open_inv_button_pressed")


func _on_ZoomInButton_button_down():
	Events.emit_signal("zoom_in_button_pressed")


func _on_ZoomOutButton_button_down():
	Events.emit_signal("zoom_out_button_pressed")


func _on_BuildButton_button_down():
	Events.emit_signal("build_button_pressed")


func _on_MusicButton_button_down():
	Events.emit_signal("music_button_pressed")
