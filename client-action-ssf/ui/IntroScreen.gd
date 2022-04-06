extends ColorRect


func _ready():
	set_visible(true)
	yield(get_tree().create_timer(10), "timeout")
	set_visible(false)


func _input(event):
	if event is InputEventKey:
		set_visible(false)
