extends KinematicBody2D


enum behaviour {
	SEARCH,
	HUNT
}


export var speed = 100
export(NodePath) var nav_path 
export(NodePath) var game_node_path 
export(NodePath) var room_nav_points_path
 

onready var nav: Navigation2D = get_node(nav_path)
onready var roomNavPoints: Node2D = get_node(room_nav_points_path)
onready var gameNode = get_node(game_node_path)
onready var timer = $Timer


var _id = "scammer"

var velocity = Vector2.ZERO
var path = []
var threshold = 16

var behaviour_mode: int = behaviour.SEARCH
var room_point: Node2D = null
var unchecked_room_points: Array = []


func _ready():
	Server.connect("packet_received", self, "_on_packet_recieved")
	yield(get_tree().create_timer(0), "timeout")
	timer.start()


func _on_packet_recieved(packet: Dictionary) -> void:
	match(packet.type):
		Constants.PacketTypes.SET_PLAYER_POS:
			if packet.id == _id:
				# Don't move from packet in the host client since they control the scammer locally
				if Lobby.is_host == false:
					position = Vector2(packet.x, packet.y)


func _physics_process(delta):
	if Lobby.is_host == true:
		if path.size() > 0:
			move_to_target()
		
		Server.send_pos(_id, position)


func move_to_target():
	if global_position.distance_to(path[0]) < threshold:
		path.remove(0)
	else:
		var direction = global_position.direction_to(path[0])
		velocity = direction * speed
		velocity = move_and_slide(velocity)


func get_target_path(target_pos):
	path = nav.get_simple_path(global_position, target_pos, false)


func _on_Damage_body_entered(body):
	if body.get("Sprite") != null:
		body.set_visible(false)
		body.set_process(false)
		body.set_physics_process(false)


func _on_Timer_timeout():
	var players = gameNode.get_players()
	for player in players:
		var player_pos: Vector2 = player.position
		if player_pos.distance_to(position) < 290 && player.visible == true:
			get_target_path(player.position)
			return
	
	var check_another_room: bool = false
	if room_point == null:
		check_another_room = true
	else:
		check_another_room = position.distance_to(room_point.position) < 40
	
	if  check_another_room == true:
		if unchecked_room_points.size() == 0:
			unchecked_room_points.append_array(roomNavPoints.get_children())
		
		var random_room_point = unchecked_room_points[randi() % unchecked_room_points.size()]
		var remove_at = unchecked_room_points.find(random_room_point)
		unchecked_room_points.remove(remove_at)
		room_point = random_room_point
	
	get_target_path(room_point.position)
