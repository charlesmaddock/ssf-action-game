extends Camera2D


var follow: Node2D = null


func set_follow(node: Node2D) -> void:
	follow = node


func _process(delta):
	if follow != null:
		position = position.linear_interpolate(follow.position, delta * 4)
