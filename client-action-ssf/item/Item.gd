extends Area2D
class_name Item


signal started_dragging(item)


var hovering_over: bool
onready var item_desc = $ItemDesc


var id = ""
var amount = 0
var type = Constants.ItemTypes.LOG
var _is_preview = false


func init(item_data: Dictionary, is_preview = false):
	var item_info = Constants.item_info[int(item_data.type)]
	get_node("Sprite").texture = item_info.image
	get_node("StackAmountLabel").text = str(item_data.amount)
	
	get_node("ItemDesc").init(item_info.name)
	
	id = item_data.id
	amount = item_data.amount
	type = int(item_data.type)
	_is_preview = is_preview


func get_is_preview():
	return _is_preview


func _input(event):
	if Input.is_action_just_pressed("drag_item") && hovering_over && _is_preview == false:
		ItemDragHandler.started_dragging_item(self, get_parent())


func _on_Item_mouse_entered():
	hovering_over = true
	item_desc.show()
	z_index = 2


func _on_Item_mouse_exited():
	hovering_over = false
	item_desc.hide()
	z_index = 1
