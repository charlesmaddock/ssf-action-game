extends Area2D


var bodies: Array = []
var _speed: float = 50

onready var _direction = Vector2.UP.rotated(rotation) 


func _physics_process(delta):
	for body in bodies:
		body.move_and_slide(_direction * _speed)


func _on_Conveyor_body_entered(body):
	bodies.append(body)


func _on_Conveyor_body_exited(body):
	bodies.erase(body)
