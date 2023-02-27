extends Area2D


func _on_MouseHoverInteraction_mouse_entered():
	Events.emit_signal("hovered_over_entity", get_parent())


func _on_MouseHoverInteraction_mouse_exited():
	Events.emit_signal("left_hover_over_entity", get_parent())
	
