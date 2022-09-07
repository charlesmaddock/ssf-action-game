extends TouchScreenButton


onready var label = $Label


func _ready():
	set_visible(Lobby.my_client_data.class == "Romance Scammer")
	label.set_visible(Util.is_mobile() == false)


func _on_AttackTouchScreenButton_pressed():
	Input.action_press("attack")


func _on_AttackTouchScreenButton_released():
	Input.action_release("attack")
