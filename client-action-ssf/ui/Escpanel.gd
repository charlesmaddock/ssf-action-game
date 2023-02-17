extends CanvasLayer


onready var EscPanelContainer = $EscPanelContainer


func _ready():
	hide()


func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_visible()


func toggle_visible():
	EscPanelContainer.set_visible(!EscPanelContainer.visible)


func hide():
	EscPanelContainer.set_visible(false)


func _on_BackToTheGame_pressed():
	hide()


func _on_LeaveGame_pressed():
	API.leave_world()
