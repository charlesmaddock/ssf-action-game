extends Camera2D


const zoom_levels = [0.3, 0.9, 1.7, 3, 20]
var zoom_level_index = 2

var follow: Node2D = null
var spectate_index: int = 0
var follow_prev_pos: Vector2
var target_zoom: Vector2 = Vector2.ONE


func _ready():
	Events.connect("follow_w_camera", self, "_on_follow_w_camera")
	Events.connect("zoom_out_button_pressed", self, "_on_zoom_out_button_pressed")
	Events.connect("zoom_in_button_pressed", self, "_on_zoom_in_button_pressed")
	
	_on_zoom_in_button_pressed()


func _on_zoom_out_button_pressed() -> void:
	zoom_level_index = clamp(zoom_level_index + 1, 0, zoom_levels.size() - 1)
	target_zoom = Vector2(zoom_levels[zoom_level_index], zoom_levels[zoom_level_index])
	if Util.is_mobile():
		target_zoom *= 0.8


func _on_zoom_in_button_pressed() -> void:
	zoom_level_index = clamp(zoom_level_index - 1, 0, zoom_levels.size() - 1)
	target_zoom = Vector2(zoom_levels[zoom_level_index], zoom_levels[zoom_level_index])
	if Util.is_mobile():
		target_zoom *= 0.8


func _on_follow_w_camera(node: Node2D) -> void:
	follow = node


func _process(delta):
	if follow != null && is_instance_valid(follow):
		var dir = follow_prev_pos.direction_to(follow.global_position)
		if follow_prev_pos.distance_squared_to(follow.global_position) < 1000:
			dir = Vector2.ZERO
		
		position = position.linear_interpolate(follow.global_position + Vector2(1, 1) * 8, delta * 4)
		follow_prev_pos = follow.global_position
		
		zoom = zoom.linear_interpolate(target_zoom, delta * 10)
		
		if follow.global_position.distance_squared_to(global_position) > 100000:
			position = follow.global_position
