extends AnimatedSprite


var _velocity = Vector2.ZERO
var _max_life_span = 0.5
var _life_span = 0


func init(velocity: Vector2):
	_velocity = velocity
	var radians = global_position.angle_to_point(global_position + velocity) + 1.5 * PI
	rotation = radians
	play()


func _process(delta):
	global_position += _velocity
	_life_span += delta
	
	if _life_span >= _max_life_span:
		queue_free() 
