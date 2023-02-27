extends Node


var draging_item = null
var prev_item_slot = null
var hovering_over_item_slots = []


func started_dragging_item(item, item_slot):
	if draging_item == null: 
		draging_item = item
		prev_item_slot = item_slot


func hovering_over_item_slot(item_slot):
	if hovering_over_item_slots.find(item_slot) == -1:
		hovering_over_item_slots.append(item_slot)


func stop_hovering_over_item_slot(item_slot):
	hovering_over_item_slots.erase(item_slot)


func _input(event):
	if Input.is_action_just_released("drag_item"):
		try_place_dragged_item()


func _process(delta):
	if draging_item != null:
		draging_item.global_position = get_viewport().get_mouse_position() 


func try_place_dragged_item():
	if draging_item != null:
		var closest_item_slot = null
		var closest_dist = 999999
		var hover_pos = get_viewport().get_mouse_position()
		for item_slot in hovering_over_item_slots:
			if is_instance_valid(item_slot):
				if item_slot.get_item() == null && item_slot != prev_item_slot && item_slot.is_crafting_result == false:
					var item_slot_pos = item_slot.rect_global_position
					var dist = item_slot_pos.distance_to(hover_pos)
					if dist < closest_dist:
						closest_item_slot = item_slot
						closest_dist = dist
		
		if closest_item_slot != null && prev_item_slot != null:
			prev_item_slot.remove_item(draging_item)
			closest_item_slot.place_item(draging_item)
		elif closest_item_slot != null:
			closest_item_slot.place_item(draging_item)
		elif prev_item_slot != null:
			prev_item_slot.place_item(draging_item)
		
		draging_item = null
		prev_item_slot = null
		hovering_over_item_slots = []
