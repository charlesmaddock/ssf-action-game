extends CanvasLayer


onready var EscPanelContainer = $EscPanelContainer
onready var Backdrop = $Backdrop


func _ready():
	Events.connect("settings_button_pressed", self, "_on_settings_button_pressed")
	hide()


func _on_settings_button_pressed():
	toggle_visible()


func _input(event):
	if Input.is_action_just_pressed("settings"):
		toggle_visible()


func toggle_visible():
	EscPanelContainer.set_visible(!EscPanelContainer.visible)
	Backdrop.set_visible(EscPanelContainer.visible)


func hide():
	EscPanelContainer.set_visible(false)
	Backdrop.set_visible(false)


func _on_BackToTheGame_pressed():
	hide()


func _on_LeaveGame_pressed():
	API.leave_world()
