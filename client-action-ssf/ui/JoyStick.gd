extends TouchScreenButton


export(NodePath) var movement_path


onready var InnerCircleSprite = $InnerCircleSprite
onready var TipPanel = get_parent().get_node("PanelContainer")


var velocity = Vector2.ZERO
var joy_stick_active: bool = false
var inner_circle_offset: Vector2 = Vector2(shape.radius, shape.radius)
var _touch_index: int = -1


func _ready():
	position = Vector2.ONE * 90000
	var is_mobile = Util.is_mobile()
	yield(get_tree(), "idle_frame")
	var use_joy_stick = is_mobile && get_node(movement_path).entity_id == Client.get_my_account().id
	set_physics_process(use_joy_stick)
	set_process_unhandled_input(use_joy_stick)
	yield(Events, "cutscene_over")
	TipPanel.set_visible(use_joy_stick)


func _unhandled_input(event):
	yield(get_tree(), "idle_frame")
	if event is InputEventScreenTouch && _touch_index == -1:
		TipPanel.set_visible(false)
		_touch_index = event.get_index()


func _input(event):
	if event is InputEventScreenTouch:
		if event.get_index() == _touch_index:
			if event.pressed == false:
				velocity = Vector2.ZERO
				position = Vector2.ONE * 90000
				_touch_index = -1
			elif event.pressed == true:
				position = event.position - inner_circle_offset
				velocity = calc_move_dir(event.position)
	elif event is InputEventScreenDrag:
		if event.get_index() == _touch_index:
			velocity = calc_move_dir(event.position)


func _physics_process(_delta):
	var centre = global_position + Vector2(shape.radius / 2, shape.radius / 2) + inner_circle_offset / 2
	InnerCircleSprite.global_position = centre + (velocity * (shape.radius / 2))


func calc_move_dir(event_pos: Vector2) -> Vector2:
	var centre = global_position + Vector2(shape.radius / 2, shape.radius / 2) + inner_circle_offset / 2
	return ((event_pos - centre) / (shape.radius / 2)).clamped(1)


func get_velocity() -> Vector2:
	return velocity
