extends TouchScreenButton


export(NodePath) var movement_path


onready var InnerCircleSprite = $InnerCircleSprite
onready var TipPanel = get_parent().get_node("PanelContainer")


var velocity = Vector2.ZERO
var joy_stick_active: bool = false
var inner_circle_offset: Vector2 = Vector2(shape.radius, shape.radius)
var _touch_index: int = -1


func _ready():
	var is_mobile = Util.is_mobile()
	yield(get_tree(), "idle_frame")
	var use_joy_stick = is_mobile && get_node(movement_path).entity_id == Lobby.my_id
	position = Vector2.ONE * 90000
	set_physics_process(use_joy_stick)
	set_process_unhandled_input(use_joy_stick)
	yield(Events, "cutscene_over")
	TipPanel.set_visible(use_joy_stick)
	


func _unhandled_input(event):
	if event is InputEventScreenTouch && _touch_index == -1:
		TipPanel.set_visible(false)
		position = event.position - inner_circle_offset
		_touch_index = event.get_index()


func _input(event):
	if event is InputEventScreenDrag or event is InputEventScreenTouch:
		yield(get_tree(), "idle_frame")
		if event.get_index() == _touch_index:
			velocity = calc_move_dir(event.position)
	
	if event is InputEventScreenTouch:
		if event.pressed == false && event.get_index() == _touch_index:
			velocity = Vector2.ZERO
			position = Vector2.ONE * 90000
			_touch_index = -1


func _physics_process(delta):
	var centre = global_position + Vector2(shape.radius / 2, shape.radius / 2) + inner_circle_offset / 2
	InnerCircleSprite.global_position = centre + (velocity * (shape.radius / 2))


func calc_move_dir(event_pos: Vector2) -> Vector2:
	var centre = global_position + Vector2(shape.radius / 2, shape.radius / 2) + inner_circle_offset / 2
	return ((event_pos - centre) / (shape.radius / 2)).clamped(1)


func get_velocity() -> Vector2:
	return velocity
