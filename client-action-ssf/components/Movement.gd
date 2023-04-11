extends Node2D


export(float) var speed: float = 80.0
export(NodePath) var spriteContainerPath


onready var spriteContainer: SpriteContainer = get_node(spriteContainerPath)


var entity_id: String
var target_position: Vector2
var _prev_input: Vector2
var _prev_pos: Vector2
var is_mine: bool
var JoyStick = null


func _ready():
	API.connect("packet_received", self, "_on_packet_received")


func init(spawn_entity_dto: Dictionary, pos: Vector2):
	entity_id = spawn_entity_dto.id
	is_mine = Client.is_mine(entity_id)
	set_process_input(is_mine) 
	
	if is_mine:
		JoyStick = Util.get_joy_stick()
	
	var spawn_pos = pos
	set_pos_directly(spawn_pos)


func _on_packet_received(event: String, data: Dictionary) -> void:
	match(event):
		WsEvents.setEntityPos:
			if entity_id == data.id:
				target_position = Vector2(data.x, data.y)


func in_gameplay_mode() -> bool:
	return Client.ui_interaction_mode == Client.UIInteractionModes.GAMEPLAY


func _process(delta):
	get_parent().global_position = get_parent().global_position.linear_interpolate(target_position, delta * 9)
	
	var is_moving = _prev_pos.distance_squared_to(get_parent().global_position) > 0.02
	# Instant movement feedback for clients
	if is_mine && _prev_pos.distance_squared_to(get_parent().global_position) > 0.02 && get_input() != Vector2.ZERO:
		is_moving = true
	
	if is_moving:
		spriteContainer.play_move_anim()
	else:
		spriteContainer.play_idle()
	
	_prev_pos = get_parent().global_position


func set_pos_directly(pos: Vector2):
	get_parent().global_position = pos
	target_position = pos


func _input(event):
	var input = get_input()
	
	if Input.is_action_just_pressed("open_chat"):
		API.send_input(Vector2(0, 0))
	
	if Input.is_action_just_pressed("open_inventory"):
		API.send_input(Vector2(0, 0))
	
	if _prev_input != input && in_gameplay_mode():
		_prev_input = Vector2(input.x, input.y)
		API.send_input(input)


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
	
	var combined = velocity.normalized() + JoyStick.get_velocity()
	return combined

