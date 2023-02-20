extends CanvasLayer


func _on_ChatButton_pressed():
	Events.emit_signal("chat_button_pressed")


func _on_ZoomOutButton_pressed():
	Events.emit_signal("zoom_out_button_pressed")


func _on_ZoomInButton_pressed():
	Events.emit_signal("zoom_in_button_pressed")
