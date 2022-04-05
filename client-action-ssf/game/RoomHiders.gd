extends Control


export(bool) var visible_on_ready


func _ready():
	if visible_on_ready == true:
		set_visible(true)

