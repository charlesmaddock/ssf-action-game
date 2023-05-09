extends TextureButton
class_name Item


signal started_dragging(item)


export(bool) var show_amount = true 


onready var item_desc = $Area2D/ItemDesc
onready var area2d: Area2D = $Area2D


var id = ""
var amount = 0
var type = Constants.ItemType.LOG
var made_of: Array = []
var _is_preview = false
var colliding_item_slot_areas = []
var _item_slot = null
var _hotbar_active: bool = true

func init(serialized_item: Dictionary, is_preview = false):
	var item_type = int(serialized_item.type)
	var item_info = Constants.item_info[item_type]
	var made_of_resource_info = Util.get_highest_priority_made_of_resource(serialized_item.madeOf)
	var sprite = get_sprite()
	sprite.texture = item_info.image
	
	if made_of_resource_info != null:
		if made_of_resource_info.item_modulate.has(item_type):
			sprite.modulate = made_of_resource_info.item_modulate[item_type]
		else:
			sprite.modulate = made_of_resource_info.default_modulate
	
	get_node("Area2D/ItemDesc").init(serialized_item)
	set_amount(serialized_item.amount)
	
	id = serialized_item.id
	type = int(serialized_item.type)
	made_of = serialized_item.madeOf
	_is_preview = is_preview


func _ready():
	Events.connect("inventory_toggled", self, "_on_inventory_toggled")
	_on_inventory_toggled(false)


func _on_inventory_toggled(inventory_visible: bool):
	item_desc.hide()
	_hotbar_active = !inventory_visible


func get_id():
	return id


func get_type():
	return type


func get_made_of():
	return made_of


func get_is_preview():
	return _is_preview


func get_sprite():
	return get_node("Area2D/Sprite")


func get_current_item_slot():
	return _item_slot


func set_current_item_slot(item_slot):
	_item_slot = item_slot


func get_closest_item_slot(prev_item_slot):
	var closest_item_slot = null
	var closest_dist = 999999
	var item_slot_extents = prev_item_slot.get_extents()
	for item_slot_area in colliding_item_slot_areas:
		if is_instance_valid(item_slot_area):
			var item_slot = item_slot_area.get_parent()
			if (item_slot.get_item() == null || prev_item_slot == item_slot) && item_slot.get_is_available():
				var item_slot_pos = item_slot.rect_global_position + item_slot_extents
				var dist = item_slot_pos.distance_to(get_global_mouse_position())
				if dist < closest_dist:
					closest_item_slot = item_slot
					closest_dist = dist
	
	return closest_item_slot


func set_amount(a: int):
	amount = a
	if show_amount == true:
		get_node("Area2D/StackAmountLabel").text = str(a)
	else:
		get_node("Area2D/StackAmountLabel").text = ""


func hide_item_desc():
	item_desc.hide()


func _on_Item_button_up():
	if _is_preview == false:
		var switched_slot = ItemDragHandler.try_place_dragged_item() 
		area2d.z_index = 2
		
		print("switched_slot: ", switched_slot)
		
		if _hotbar_active && switched_slot == false:
			Events.emit_signal("hotbar_slot_pressed", _item_slot.hotbar_index)
	
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
