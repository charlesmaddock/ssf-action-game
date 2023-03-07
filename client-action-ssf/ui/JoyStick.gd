extends TouchScreenButton


export(NodePath) var movement_path


onready var InnerCircleSprite = $InnerCircleSprite


var velocity = Vector2.ZERO
var joy_stick_active: bool = false
var inner_circle_offset: Vector2 = Vector2(shape.radius, shape.radius)


func _ready():
	position = Vector2.ONE * 90000
	var is_mobile = Util.is_mobile()
	yield(get_tree(), "idle_frame")
	set_physics_process(is_mobile)
	set_process_unhandled_input(is_mobile)


func _unhandled_input(event):
	if Client.ui_interaction_mode == Client.UIInteractionModes.GAMEPLAY:
	
		if event is InputEventScreenTouch:
			if event.pressed == true:
				var centre = event.position - Vector2(shape.radius / 2, shape.radius / 2) - inner_circle_offset / 2
				position = centre
				velocity = calc_move_dir(event.position)
			if event.pressed == false:
				velocity = Vector2.ZERO
				position = Vector2.ONE * 90000
		
		if event is InputEventScreenDrag:
			velocity = calc_move_dir(event.position)
	else:
		velocity = Vector2.ZERO


func calc_move_dir(event_pos: Vector2) -> Vector2:
	var centre = global_position + Vector2(shape.radius / 2, shape.radius / 2) + inner_circle_offset / 2
	InnerCircleSprite.global_position = centre + (velocity * (shape.radius / 2))
	var velocity = ((event_pos - centre) / (shape.radius / 2)).clamped(1)
	if velocity.length() < 0.2:
		velocity = Vector2.ZERO
	visible = velocity != Vector2.ZERO
	return velocity


func get_velocity() -> Vector2:
	return velocity
