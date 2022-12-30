extends ColorRect


var _has_pressed: bool = false
export(bool) var ingame: bool = true


func _ready():
	if(ingame == true):
		set_visible(false)
		yield(Events, "cutscene_over")
		yield(get_tree().create_timer(1), "timeout")
		if _has_pressed == false:
			set_visible(true)
			yield(get_tree().create_timer(10), "timeout")
			set_visible(false)


func _input(event):
	if(ingame == true):
		if event is InputEventKey or event is InputEventScreenTouch:
			_has_pressed = true
			set_visible(false)
