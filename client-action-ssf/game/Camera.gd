extends Camera2D


var follow: Node2D = null
var my_player_is_dead: bool = false
var spectate_index: int = 0
var follow_prev_pos: Vector2
var target_zoom: Vector2 = Vector2.ONE


func _ready():
	Events.connect("player_dead", self, "_on_player_dead")
	Events.connect("follow_w_camera", self, "_on_follow_w_camera")
	
	set_process(false)
	yield(Events, "cutscene_over")
	set_process(true)


func _on_player_dead(id) -> void:
	if id == Lobby.my_id:
		my_player_is_dead = true


func _input(event):
	if Input.is_key_pressed(KEY_C) && Input.is_key_pressed(KEY_V):
		target_zoom = Vector2(5, 5)
	else:
		target_zoom = Vector2(0.85, 0.85) if Util.is_mobile() else Vector2(1, 1)
	
	if my_player_is_dead == true:
		if Input.is_action_just_pressed("ui_left") or event is InputEventScreenTouch:
			var all_players = Util.get_living_players() 
			spectate_index -= 1
			if spectate_index < 0:
				spectate_index = all_players.size() - 1
			Events.emit_signal("follow_w_camera", all_players[spectate_index])
		if Input.is_action_just_pressed("ui_right"):
			var all_players = Util.get_living_players() 
			spectate_index += 1
			if spectate_index > all_players.size() - 1:
				spectate_index = 0
			Events.emit_signal("follow_w_camera", all_players[spectate_index])


func _on_follow_w_camera(node: Node2D) -> void:
	Lobby.specating_player_w_id = node.get_id()
	follow = node
	Events.emit_signal("switched_spectate", node)


func _process(delta):
	if follow != null:
		var dir = follow_prev_pos.direction_to(follow.global_position)
		if follow_prev_pos.distance_squared_to(follow.global_position) < 20:
			dir = Vector2.ZERO
		
		position = position.linear_interpolate(follow.global_position + (dir * 40), delta * 4)
		zoom = zoom.linear_interpolate(target_zoom, delta * 3)
		follow_prev_pos = follow.global_position
