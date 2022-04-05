tool
extends ColorRect


export(String) var key
export(String) var ability_name


func _ready():
	$Key.text = key
	$AbilityName.text = ability_name


func _input(event):
	if Input.is_action_just_pressed("ability_1") && key == "1":
		_set_used()
	elif Input.is_action_just_pressed("ability_2") && key == "2":
		_set_used()
	elif Input.is_action_just_pressed("ability_3") && key == "3":
		_set_used()


func _set_used() -> void:
	color = Color(0.5,0.5,0.5,0.7)
