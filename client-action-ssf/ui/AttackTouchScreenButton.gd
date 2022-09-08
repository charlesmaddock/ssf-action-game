extends TouchScreenButton


onready var label = $Label


func _ready():
	set_visible(Lobby.my_client_data.class == "Romance Scammer")
	label.set_visible(Util.is_mobile() == false)
	scale = Vector2(0.8, 0.8) if Util.is_mobile() else Vector2(0.4, 0.4)


func _on_AttackTouchScreenButton_pressed():
	Input.action_press("attack")


func _on_AttackTouchScreenButton_released():
	Input.action_release("attack")
