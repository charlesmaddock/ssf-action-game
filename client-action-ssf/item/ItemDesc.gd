extends PanelContainer


var showing = false


func init(name: String):
	$Label.text = name 


func _ready():
	hide()


func show():
	showing = true
	yield(get_tree().create_timer(0.2), "timeout")
	if showing == true:
		set_visible(true)


func hide():
	showing = false
	set_visible(false)
