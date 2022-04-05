extends ColorRect


func _ready():
	set_visible(true)


func _input(event):
	if event is InputEventKey:
		set_visible(false)
