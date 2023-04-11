extends Sprite


const AIR_TIME = 0.1


var _start: Vector2
var _target: Vector2
var _time: float = 0.0



func fire(attacker: Node2D, attacked: Node2D, success: bool) -> void:
	global_position = attacker.global_position
	_start = attacker.global_position
	_target = attacked.global_position
	
	if success == false:
		_target +=  Vector2(randf() - 0.5, randf() - 0.5).normalized() * Constants.TILE_DIM * 3
	
	
	var dir = (global_position - _target).normalized() 
	rotation = dir.angle() - PI / 2


func _process(delta):
	_time += delta
	global_position = _start.linear_interpolate(_target, clamp(_time / AIR_TIME, 0, 1))
	
	if _time > AIR_TIME:
		queue_free()
