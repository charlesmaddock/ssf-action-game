extends TextureButton


signal placed_item(item)
signal removed_item(item)


export(bool) var is_crafting_result = false
export(bool) var is_crafting_slot = false


var item_scene = load("res://item/Item.tscn")
var holding_item = null


func get_item():
	return holding_item


func get_item_id() -> String:
	if holding_item != null:
		return holding_item.id
	else:
		return ""


func set_item(inventory_item_data: Dictionary):
	if holding_item == null:
		# Create new item
		var item = item_scene.instance()
		item.init(inventory_item_data)
		place_item(item)
	else:
		# Increase stack of existing item
		holding_item.init(inventory_item_data)


func place_item(item: Item):
	emit_signal("placed_item", item)
	holding_item = item
	add_child(item)
	item.position = Vector2(0,0)


func remove_item(item: Node2D):
	if item == holding_item:
		emit_signal("removed_item", item)
		holding_item = null
		remove_child(item)


func _on_Area2D_mouse_entered():
	ItemDragHandler.hovering_over_item_slot(self)


func _on_Area2D_mouse_exited():
	ItemDragHandler.stop_hovering_over_item_slot(self)
