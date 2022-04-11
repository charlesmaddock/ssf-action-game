extends Node2D


var closed: bool = false


func _on_OpenCloseTimer_timeout():
	closed = !closed
	$AnimationPlayer.play("open" if closed == true else "close")
