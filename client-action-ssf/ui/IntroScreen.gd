extends ColorRect


var _has_pressed: bool = false


func _ready():
	set_visible(false)
	yield(Events, "cutscene_over")
	yield(get_tree().create_timer(1), "timeout")
	if _has_pressed == false:
		set_visible(true)
		yield(get_tree().create_timer(6), "timeout")
		set_visible(false)


func _input(event):
	if event is InputEventKey or event is InputEventScreenTouch:
		_has_pressed = true
		set_visible(false)
