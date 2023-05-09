extends YSort


export(Curve) var shake_curve: Curve


onready var harvested_item = $HarvestedItem


var _id: String  
var _type: int
var original_pos: Vector2
var loaded = false
var points = [Vector2(0.3, 0.2), Vector2(0.7, 0.1), Vector2(0.1, 0.5), Vector2(0.85, 0.6), Vector2(0.4, 0.9), Vector2(0.8, 1)]

var anim_progress: float = 0
const anim_time = 0.5


func _ready():
	API.connect("packet_received", self, "_on_packet_received")
	var action_indication_area = get_node("ActionIndicationArea")
	action_indication_area.init_indication_area(get_resource_extents() + Vector2.DOWN * 16, get_resource_extents() +  Vector2.UP * 16) 
	set_process(false)


func _on_packet_received(event: String, data: Dictionary) -> void:
	if event == WsEvents.harvestedItem:
		if data.harvestedFromId == _id:
			var harvester = Util.get_entity(data.harvesterId)
			if harvester != null:
				harvester.swing_item(global_position + + get_resource_extents())
				harvested_item.fly_to(global_position + get_resource_extents(), harvester.global_position, data.itemConfig.itemType, data.itemConfig.madeOf)
				set_process(true)
				anim_progress = 0
	elif event == WsEvents.resourceStatus:
		if data.id == _id:
			for child in get_children():
				if child.has_method("update_resource_status"):
					child.update_resource_status(data.procentFull)


func init(resource_data: Dictionary):
	_id = resource_data.id
	_type = resource_data.type
	
	var amount_to_spawn = 3 + randi() % 3
	
	if loaded == false:
		loaded = true
		while amount_to_spawn > 0:
			amount_to_spawn -= 1
			var rand_point_i = randi() % points.size()
			var rand_pos = points[rand_point_i] * Constants.RESOURCE_DIM / Constants.TILE_DIM
			points.remove(rand_point_i)
			var resource_sprite = ResourceConstants.resource_info[int(resource_data.type)].scene.instance()
			add_child(resource_sprite)
			resource_sprite.init(rand_pos.x, rand_pos.y, resource_data.dropsPercent, int(resource_data.type))
	
	global_position = Vector2(resource_data.x, resource_data.y)
	original_pos = global_position


func get_id() -> String:
	return _id


func get_resource_extents() -> Vector2:
	return Vector2(Constants.RESOURCE_DIM.x / 2, Constants.RESOURCE_DIM.y / 2)


func _process(delta):
	var procental_progress = anim_progress / anim_time
	
	global_position.x += shake_curve.interpolate_baked(procental_progress) * 1.2
	anim_progress += delta
	if procental_progress >= 1:
		global_position = original_pos 
		set_process(false)

