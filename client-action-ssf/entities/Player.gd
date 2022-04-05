extends KinematicBody2D


var speed = 80
var sprite_scale: Vector2 = Vector2.ONE
var _id: String = ""
var server_velocity = Vector2.ZERO


var abilities_used = [false, false, false]


onready var Sprite = $Sprite


func _ready():
	Server.connect("packet_received", self, "_on_packet_received")


func get_id() -> String:
	return _id


func _on_packet_received(packet: Dictionary) -> void:
	if _id == packet.id:
		match(packet.type):
			Constants.PacketTypes.SET_INPUT:
				server_velocity = Vector2(packet.x, packet.y)
			Constants.PacketTypes.SET_PLAYER_POS:
				# Don't move the host's player if we are the host
				if Lobby.is_host == true && _id == Lobby.my_id:
					return
				
				position = Vector2(packet.x, packet.y)


func set_players_data(id: String, pos: Dictionary) -> void:
	var spawn_pos = Vector2(pos.x, pos.y)
	position = spawn_pos
	_id = id
	print("player id is ", _id)
	print("my id is ", Lobby.my_id)


func get_input():
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	return velocity.normalized() * speed


func _input(event):
	if Input.is_action_just_pressed("ability_1") && abilities_used[0] == false:
		abilities_used[0] = true
		speed = 130
		yield(get_tree().create_timer(6), "timeout")
		speed = 80
	elif Input.is_action_just_pressed("ability_2") && abilities_used[1] == false:
		abilities_used[1] = true
		var nav_points = Util.get_nav_points()
		var teleport_pos = nav_points[randi() % nav_points.size()].position
		position = teleport_pos
	elif Input.is_action_just_pressed("ability_3") && abilities_used[2] == false:
		abilities_used[2] = true
		set_visible(false)
		yield(get_tree().create_timer(6), "timeout")
		set_visible(true)


func _physics_process(delta):
	var velocity = get_input()
	Server.send_input(velocity)
	
	if Lobby.is_host == true:
		move_and_slide(server_velocity)
		Server.send_pos(_id, position)
	
	if server_velocity != Vector2.ZERO:
		sprite_scale = Vector2(-1 if server_velocity.x < 0 else 1, 1)
	Sprite.scale = sprite_scale