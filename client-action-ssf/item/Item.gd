extends TextureButton
class_name Item


signal started_dragging(item)


export(bool) var show_amount = true 


onready var item_desc = $Area2D/ItemDesc
onready var area2d: Area2D = $Area2D


var id = ""
var amount = 0
var type = Constants.ItemType.LOG
var _is_preview = false
var colliding_item_slot_areas = []


func init(item_data: Dictionary, is_preview = false):
	var item_info = Constants.item_info[int(item_data.type)]
	get_node("Area2D/Sprite").texture = item_info.image
	get_node("Area2D/Sprite").modulate = item_info.mod
	get_node("Area2D/ItemDesc").init(item_info.name)
	
	if show_amount == true:
		get_node("Area2D/StackAmountLabel").text = str(item_data.amount)
	else:
		get_node("Area2D/StackAmountLabel").text = ""
	
	id = item_data.id
	amount = item_data.amount
	type = int(item_data.type)
	_is_preview = is_preview


func get_is_preview():
	return _is_preview


func get_closest_item_slot(prev_item_slot):
	var closest_item_slot = null
	var closest_dist = 999999
	var item_slot_extents = prev_item_slot.get_extents()
	for item_slot_area in colliding_item_slot_areas:
		if is_instance_valid(item_slot_area):
			var item_slot = item_slot_area.get_parent()
			if item_slot.get_item() == null && item_slot != prev_item_slot:
				var item_slot_pos = item_slot.rect_global_position + item_slot_extents
				var dist = item_slot_pos.distance_to(get_global_mouse_position())
				if dist < closest_dist:
					closest_item_slot = item_slot
					closest_dist = dist
	
	return closest_item_slot


func hide_item_desc():
	item_desc.hide()


func _on_Item_button_up():
	if _is_preview == false:
		ItemDragHandler.try_place_dragged_item() 
		area2d.z_index = 2
	
	item_desc.hide()


func _on_Item_button_down():
	if _is_preview == false:
		area2d.z_index = 4
		ItemDragHandler.started_dragging_item(self, get_parent()) 
	
	if Util.is_mobile() == true:
		item_desc.show()
	else:
		item_desc.hide()


func _on_Item_mouse_entered():
	if Util.is_mobile() == false:
		area2d.z_index = 3
		item_desc.show()


func _on_Item_mouse_exited():
	if Util.is_mobile() == false:
		area2d.z_index = 2
		item_desc.hide()


func _on_Area2D_area_entered(area):
	if colliding_item_slot_areas.find(area) == -1:
		colliding_item_slot_areas.append(area)


func _on_Area2D_area_exited(area):
	colliding_item_slot_areas.erase(area)
