extends Node2D


export(NodePath) var buildings_node_path


onready var prototype = $Prototype


var colliding_with = []
var dragging_building_of_type = -1


func _ready():
	Events.connect("building_selected", self, "_on_building_selected")
	
	# Prototype moved to building nodes ysort
	var building_node = get_node(buildings_node_path)
	remove_child(prototype)
	building_node.add_child(prototype)


func get_can_place():
	return colliding_with.size() == 0


func _on_building_selected(texture: Texture, building_type: int):
	prototype.texture = texture
	prototype.visible = true
	
	dragging_building_of_type = building_type
	
	var extents = Util.get_extents_from_texture(texture, true)
	prototype.get_node("PrototypeArea2D/CollisionShape2D").shape.extents = extents
	prototype.get_node("PrototypeArea2D/CollisionShape2D").position = extents
	prototype.offset = Constants.TILE_DIM - extents * 2 


func stop_dragging():
	dragging_building_of_type = -1
	prototype.visible = false


func _input(event):
	var pos = Vector2(stepify(get_local_mouse_position().x, Constants.TILE_DIM.x), stepify(get_local_mouse_position().y, Constants.TILE_DIM.y))
	prototype.position = pos
	
	if event is InputEventMouseButton && get_can_place():
		if event.is_pressed() == false && dragging_building_of_type != -1:
			API.place_construction_site(pos, dragging_building_of_type)
			Events.emit_signal("building_dropped")
			stop_dragging()


func _on_PrototypeArea2D_area_entered(area):
	if colliding_with.find(area) == -1:
		colliding_with.append(area)
	
	prototype.modulate = Color(1,0,0,0.6)


func _on_PrototypeArea2D_area_exited(area):
	colliding_with.erase(area)
	
	if get_can_place():
		prototype.modulate = Color(1,1,1,0.6)
