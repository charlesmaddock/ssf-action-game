extends CanvasModulate


func _ready():
	set_visible(false)
	yield(Events, "cutscene_over")
	set_visible(true)
