extends AnimatedSprite


onready var _start_pos = global_position


var _target_pos = Vector2.ZERO
var _max_life_span = 0.2
var _life_span = 0


func init(target_pos: Vector2):
	_target_pos = target_pos
	var radians = global_position.angle_to_point(_target_pos) + 1.5 * PI
	rotation = radians
	set_visible(true) 
	play()


func _process(delta):
	global_position = global_position.linear_interpolate(_target_pos, clamp(_life_span / _max_life_span, 0, 1))
	_life_span += delta
	
	if _life_span >= _max_life_span:
		set_visible(false) 
