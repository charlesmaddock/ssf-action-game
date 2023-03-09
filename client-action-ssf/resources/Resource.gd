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
var loaded = false


var anim_progress: float = 0
const anim_time = 0.5


func _ready():
	API.connect("packet_received", self, "_on_packet_received")
	var action_indication_area = get_node("ActionIndicationArea")
	action_indication_area.init_indication_area(get_resource_extents() + Vector2.DOWN * 16, get_resource_extents() +  Vector2.UP * 16) 
	set_process(false)


func _on_packet_received(event: String, data: Dictionary) -> void:
	if event == WsEvents.harvestedItem:
		if data.resourceId == _id:
			var my_player = Client.get_my_player()
			if my_player != null:
				yield(get_tree().create_timer(0.4), "timeout")
				harvestedItem.fly_to(global_position + get_resource_extents(), my_player.global_position, data.type)
				set_process(true)
				anim_progress = 0
	elif event == WsEvents.resourceStatus:
		if data.id == _id:
			for child in get_children():
				if child is AnimatedSprite:
					child.update_resource_status(data.procentFull)


func init(resource_data: Dictionary):
	_id = resource_data.id
	
	if loaded == false:
		loaded = true
		for x in Constants.RESOURCE_DIM.x / Constants.TILE_DIM.x:
			for y in Constants.RESOURCE_DIM.y / Constants.TILE_DIM.y:
				if x % 2 == 0 || y % 2 == 0:
					continue  
				if randf() > 0.3 || (x > 0 && x < Constants.RESOURCE_DIM.x / Constants.TILE_DIM.x - 1 && y > 0 && y < Constants.RESOURCE_DIM.y / Constants.TILE_DIM.y - 1):
					var resourceSprite = resource_scenes[int(resource_data.type)].instance()
					add_child(resourceSprite)
					resourceSprite.init(x, y, resource_data.dropsPercent)
	
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

