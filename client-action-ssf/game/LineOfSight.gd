extends Light2D


func _ready():
	set_visible(false)
	Events.connect("follow_w_camera", self, "_on_follow_w_camera")


func _on_follow_w_camera(node: Node2D) -> void:
	set_visible(node == get_parent())
