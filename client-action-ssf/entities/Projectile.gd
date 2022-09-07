extends Area2D


export(float) var _damage = 50
export(float) var _speed = 100


var _velocity: Vector2 


func get_damage() -> float:
	return _damage


func fire(pos: Vector2, dir: Vector2) -> void:
	global_position = pos
	_velocity = dir.normalized() * _speed
	rotation = dir.angle() - PI / 2


func _process(delta):
	global_position += _velocity * delta


func _on_DeathTimer_timeout():
	self.queue_free()
