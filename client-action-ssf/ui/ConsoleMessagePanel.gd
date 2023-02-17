extends PanelContainer

func set_text(text: String, type: int) -> void:
	$"MarginContainer/Label".text = text
	
	if type == Constants.ConsoleMessageTypes.ERROR:
		$ColorRect.color = "#e32b2b"
	elif type == Constants.ConsoleMessageTypes.SUCCESS:
		$ColorRect.color = "#56a349"
	elif type == Constants.ConsoleMessageTypes.LOG:
		$ColorRect.color = "#4c4c4c"


func _on_Timer_timeout():
	queue_free()
