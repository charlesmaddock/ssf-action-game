extends Node2D


var target_pos = Vector2.ZERO


func _process(delta):
	if target_pos != Vector2.ZERO:
		global_position = global_position.linear_interpolate(target_pos, delta * 2)


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
