extends HBoxContainer


func _ready():
	rect_scale = Vector2(2, 2) if Util.is_mobile() else Vector2.ONE
