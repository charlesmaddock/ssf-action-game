extends HBoxContainer


func _ready():
	rect_scale = Vector2(1.5, 1.5) if Util.is_mobile() else Vector2.ONE
