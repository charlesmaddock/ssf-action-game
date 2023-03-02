extends Sprite

const FLY_TIME = 0.6

var fly_to_target_pos: Vector2
var fly_to_start_pos: Vector2
var fly_time: float


func _ready():
	set_fly_finished()


func set_fly_finished():
	set_visible(false)
	set_process(false)


func fly_to(start_pos: Vector2, target_pos: Vector2, type: int):
	texture = Constants.item_info[type].image
	fly_to_target_pos = Vector2(target_pos.x + 8, target_pos.y) 
	fly_to_start_pos = start_pos
	fly_time = 0
	global_position = start_pos
	set_visible(true)
	set_process(true)


func _process(delta):
	fly_time += delta
	var procent_finished = fly_time / FLY_TIME
	global_position = fly_to_start_pos.linear_interpolate(fly_to_target_pos, procent_finished)
	global_position.y -= (-1 * pow(procent_finished, 2) + procent_finished) * Constants.TILE_DIM.y * 4
	scale = Vector2.ONE * clamp((-1 * pow(procent_finished, 2) + procent_finished) * Constants.TILE_DIM.x / 2, 0, 1.2)
	if procent_finished > 1:
		set_fly_finished()
