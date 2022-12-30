extends Node2D


export(NodePath) var movement_component_path


onready var Movement: Node2D = get_node(movement_component_path)
onready var nav: Navigation2D = Util.get_game_node().get_node("Navigation2D")
onready var roomNavPoints: Node2D = Util.get_game_node().get_node("RoomNavPoints")
onready var gameNode = Util.get_game_node()
onready var timer = $Timer


var path = []
var threshold = 16

var room_point: Node2D = null
var target_freeable_node: Node2D = null
var unchecked_room_points: Array = []
var freeable_nodes_in_view: Array = []
var scammers_in_view: Array = []
var time_since_last_ability: float = 0
var is_dead: bool =  false
var panic_time_length: float = 12
var panic_timer: float = panic_time_length + 1


var _used_abilities: Array = []

func _ready():
	timer.start()
	get_parent().connect("damage_taken", self, "_on_damage_taken")
	Events.connect("player_dead", self, "_on_player_dead")


func _on_damage_taken(_damage, _dir) -> void:
	if randf() > 0.5:
		yield(get_tree().create_timer(1.4), "timeout")
		if Lobby.is_host && time_since_last_ability > 3 && is_dead == false:
			try_use_ability()


func _on_player_dead(id) -> void:
	if id == get_parent().get_id():
		is_dead = true


func _physics_process(delta):
	time_since_last_ability += delta
	panic_timer += delta
	if Lobby.is_host == true:
		if path.size() > 0:
			move_to_target()


func try_use_ability() -> void:
	var abilities = [Constants.AbilityEffects.SYSTEM_UPDATE, Constants.AbilityEffects.INCOGNITO, Constants.AbilityEffects.VPN]
	var available_abilities = []
	for ability in abilities:
		if _used_abilities.find(ability) == -1:
			available_abilities.append(ability)
	
	if available_abilities.size() > 0:
		var ability_to_use = available_abilities[randi() % available_abilities.size()]
		_used_abilities.append(ability_to_use)
		Server.use_ability(ability_to_use, get_parent().get_id(), get_parent().global_position)
		time_since_last_ability = 0


func move_to_target():
	if global_position.distance_to(path[0]) < threshold:
		path.remove(0)
	else:
		var direction = global_position.direction_to(path[0])
		Movement.set_velocity(direction)


func get_target_path(target_pos):
	path = nav.get_simple_path(global_position, target_pos, false)


func _on_Timer_timeout():
	randomize()
	var sees_scammer = run_from_scammer()
	
	if sees_scammer == false:
		var found_freeable_node = find_freeable_node()
		
		if found_freeable_node == false:
			set_random_room_point()
			get_target_path(room_point.position)
	
	if Lobby.is_host && sees_scammer && randf() > 0.985 && time_since_last_ability > 3 && is_dead == false:
		try_use_ability()



func run_from_scammer() -> bool:
	var is_disguised = true
	for scammer in scammers_in_view:
		if scammer.has_method("get_is_disguised"):
			if scammer.get_is_disguised() == false:
				is_disguised = false
	
	if scammers_in_view.size() > 0 && is_disguised == false || panic_timer < panic_time_length:
		if panic_timer > panic_time_length:
			panic_timer = 0
		
		set_random_room_point()
		get_target_path(room_point.position)
		return true
	
	return false


func find_freeable_node() -> bool:
	if target_freeable_node != null:
		if target_freeable_node.get_is_freed() == false && target_freeable_node.was_first_freer(get_parent().get_id()):
			get_target_path(target_freeable_node.position + Vector2.ONE * (randf() - 0.5) * 3)
			return true
	
	var closest_node_dist: float = 9999
	var closest_node: Node2D = null
	for freeable_node in freeable_nodes_in_view:
		var dist = global_position.distance_to(freeable_node.global_position)
		if dist < closest_node_dist:
			if freeable_node.was_first_freer(get_parent().get_id()) && freeable_node.get_is_freed() == false:
				closest_node_dist = dist
				closest_node = freeable_node
				get_target_path(freeable_node.position + Vector2.ONE * (randf() - 0.5) * 3)
	
	if closest_node != null:
		target_freeable_node = closest_node
		return true
	else:
		return false


func set_random_room_point(min_dist_away: float = -1) -> void:
	var check_another_room: bool = false
	if room_point == null:
		check_another_room = true
	else:
		check_another_room = global_position.distance_to(room_point.position) < 40
	
	if min_dist_away != -1:
		for nav_point in roomNavPoints.get_children():
			print("global_position.distance_to(nav_point.global_position): ", global_position.distance_to(nav_point.global_position))
			if global_position.distance_to(nav_point.global_position) > min_dist_away:
				room_point = nav_point
	
	elif check_another_room == true:
		if unchecked_room_points.size() == 0:
			unchecked_room_points.append_array(roomNavPoints.get_children())
		
		var random_room_point = unchecked_room_points[randi() % unchecked_room_points.size()]
		var remove_at = unchecked_room_points.find(random_room_point)
		unchecked_room_points.remove(remove_at)
		room_point = random_room_point


func is_scammer(body) -> bool:
	return body.get("is_player") == null && body is KinematicBody2D


func _on_ScammerFOVArea_body_entered(body):
	if is_scammer(body):
		scammers_in_view.append(body)


func _on_ScammerFOVArea_body_exited(body):
	var remove_at = scammers_in_view.find(body)
	if remove_at != -1:
		scammers_in_view.remove(remove_at)


func _on_FreeableNodeFOVArea_area_entered(area):
	var remove_at = freeable_nodes_in_view.find(area.get_parent())
	if remove_at == -1:
		freeable_nodes_in_view.append(area.get_parent())


func _on_FreeableNodeFOVArea_area_exited(area):
	var remove_at = freeable_nodes_in_view.find(area.get_parent())
	if remove_at != -1:
		freeable_nodes_in_view.remove(remove_at)
