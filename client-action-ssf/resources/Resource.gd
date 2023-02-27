extends YSort


enum ResourceType {
	TREE,
	STONE,
	BUSH,
	MUSHROOM
}

var resource_scenes = {
	ResourceType.TREE: preload("res://resources/tree.tscn"),
	ResourceType.STONE: preload("res://resources/stone.tscn")
}

export(Curve) var shake_curve: Curve

onready var harvestedItem = $HarvestedItem

var _id: String  
var original_pos: Vector2


var anim_progress: float = 0
const anim_time = 0.5


func _ready():
	API.connect("packet_received", self, "_on_packet_received")
	var action_indication_area: CollisionShape2D = get_node("ActionIndicationArea/CollisionShape2D")
	action_indication_area.get_shape().extents = get_center_pos()
	action_indication_area.position = get_center_pos()
	set_process(false)


func _on_packet_received(event: String, data: Dictionary) -> void:
	if event == "harvestedItem":
		if data.resourceId == _id:
			var my_player = Client.get_my_player()
			if my_player != null:
				yield(get_tree().create_timer(0.4), "timeout")
				harvestedItem.fly_to(global_position + get_center_pos(), my_player.global_position, data.type)
				set_process(true)
				anim_progress = 0


func init(resource_data: Dictionary):
	_id = resource_data.id
	for x in Constants.RESOURCE_DIM.x / Constants.TILE_DIM.x:
		for y in Constants.RESOURCE_DIM.y / Constants.TILE_DIM.y:
			if randf() > 0.3 || (x > 0 && x < Constants.RESOURCE_DIM.x / Constants.TILE_DIM.x - 1 && y > 0 && y < Constants.RESOURCE_DIM.y / Constants.TILE_DIM.y - 1):
				var resource = resource_scenes[int(resource_data.type)].instance()
				add_child(resource)
				var rand_displacement = Vector2((randf() - 0.5) * 10, (randf() - 0.5) * 10)
				resource.position = Vector2((x + 1) * 16 - 8, (y + 1) * 16 - 8) + rand_displacement
	
	global_position = Vector2(resource_data.x, resource_data.y)
	original_pos = global_position


func get_id() -> String:
	return _id


func get_center_pos() -> Vector2:
	return Vector2(Constants.RESOURCE_DIM.x / 2, Constants.RESOURCE_DIM.y / 2)


func _process(delta):
	var procental_progress = anim_progress / anim_time
	
	global_position.x += shake_curve.interpolate_baked(procental_progress) * 1.2
	anim_progress += delta
	if procental_progress >= 1:
		global_position = original_pos 
		set_process(false)
