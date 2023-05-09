extends Node


var draging_item = null
var prev_item_slot = null
var _hot_bar_active = true


func _ready():
	Events.connect("inventory_toggled", self, "_on_inventory_toggled")
	_on_inventory_toggled(false)


func _on_inventory_toggled(inventory_visible: bool):
	_hot_bar_active = !inventory_visible


func get_is_dragging() -> bool:
	return draging_item != null


func started_dragging_item(item, item_slot):
	if draging_item == null: 
		draging_item = item
		prev_item_slot = item_slot


func _process(delta):
	if draging_item != null:
		draging_item.rect_global_position = get_viewport().get_mouse_position() + Vector2(-1, -1) * 16


func try_place_dragged_item() -> bool:
	var switched_slot = false
	
	if draging_item != null:
		draging_item.hide_item_desc()
		
		var closest_item_slot = draging_item.get_closest_item_slot(prev_item_slot)
		
		switched_slot = closest_item_slot != prev_item_slot
		
		if closest_item_slot != null && prev_item_slot != null:
			prev_item_slot.remove_item(draging_item)
			closest_item_slot.place_item(draging_item)
		elif closest_item_slot != null:
			closest_item_slot.place_item(draging_item)
		elif prev_item_slot != null:
			prev_item_slot.place_item(draging_item)
		
		draging_item = null
		prev_item_slot = null
		
	
	return switched_slot
