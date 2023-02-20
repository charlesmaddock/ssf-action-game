extends Camera2D


const MAX_ZOOM = 10
const MIN_ZOOM = 0.1


var follow: Node2D = null
var spectate_index: int = 0
var follow_prev_pos: Vector2
var target_zoom: Vector2 = Vector2.ONE


func _ready():
	Events.connect("follow_w_camera", self, "_on_follow_w_camera")
	Events.connect("zoom_out_button_pressed", self, "_on_zoom_out_button_pressed")
	Events.connect("zoom_in_button_pressed", self, "_on_zoom_in_button_pressed")


func _on_zoom_out_button_pressed() -> void:
	target_zoom += Vector2.ONE * 0.9
	
	if target_zoom.x > MAX_ZOOM:
		target_zoom = Vector2.ONE * MAX_ZOOM


func _on_zoom_in_button_pressed() -> void:
	target_zoom -= Vector2.ONE  * 0.9
	
	if target_zoom.x < MIN_ZOOM:
		target_zoom = Vector2.ONE * MIN_ZOOM


func _on_follow_w_camera(node: Node2D) -> void:
	follow = node
	Events.emit_signal("switched_spectate", node)


func _input(event):
	if event is InputEventPanGesture:
		target_zoom += (Vector2.ONE * event.delta.y / 3)
	
	if target_zoom.x > MAX_ZOOM:
		target_zoom = Vector2.ONE * MAX_ZOOM
	elif target_zoom.x < MIN_ZOOM:
		target_zoom = Vector2.ONE * MIN_ZOOM


func _process(delta):
	if follow != null:
		var dir = follow_prev_pos.direction_to(follow.global_position)
		if follow_prev_pos.distance_squared_to(follow.global_position) < 20:
			dir = Vector2.ZERO
		
		position = position.linear_interpolate(follow.global_position + (dir * 40) + Vector2.UP * 8, delta * 4)
		follow_prev_pos = follow.global_position
		
		zoom = zoom.linear_interpolate(target_zoom, delta * 10)
		
		if follow.global_position.distance_squared_to(global_position) > 1000:
			position = follow.global_position
