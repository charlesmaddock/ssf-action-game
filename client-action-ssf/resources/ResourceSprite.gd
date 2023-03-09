extends AnimatedSprite


const FRAME_LENGTH = 2


func init(x: int, y: int, percent_drops_left: float):
	var rand_displacement = Vector2((randf() - 0.5) * 32, (randf() - 0.5) * 32)
	position = Vector2((x + 1) * 16 - 8, (y + 1) * 16 - 8) + rand_displacement
	flip_h = randi() % 2 == 0
	if percent_drops_left == 0:
		destroy_completely()
	else:
		frame = floor((1 - percent_drops_left) * FRAME_LENGTH + (randf() * FRAME_LENGTH) *  (1 - percent_drops_left))


func update_resource_status(procent_full: float):
	if procent_full == 0:
		destroy_completely()
	elif frame < FRAME_LENGTH:
		var destroy_more = randf() > 0.4
		if destroy_more == true:
			frame += 1
			flip_h = randi() % 2 == 0


func destroy_completely():
	frame = FRAME_LENGTH
	flip_h = randi() % 2 == 0
