extends Node


var frame_count = 3
var _prev_percent_drops_left = 1


func get_init_status(percent_drops_left: float):
	if percent_drops_left == 0:
		return frame_count - 1
	else:
		return floor((1 - percent_drops_left) * (frame_count - 1) + (randf() * (frame_count - 1)) *  (1 - percent_drops_left))


func get_resource_status(procent_drops_left: float, current_frame: int):
	if procent_drops_left == 0:
		current_frame = frame_count - 1
	elif procent_drops_left == 1:
		current_frame = 0
	elif procent_drops_left > _prev_percent_drops_left && current_frame > 0:
		var regenerate = randf() > 0.4
		if regenerate == true:
			current_frame -= 1
	elif procent_drops_left < _prev_percent_drops_left && current_frame < frame_count - 1:
		var destroy_more = randf() > 0.4
		if destroy_more == true:
			current_frame += 1
	
	_prev_percent_drops_left = procent_drops_left
	return current_frame
