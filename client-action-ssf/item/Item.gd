extends Node2D
class_name Item


signal started_dragging(item)


var hovering_over: bool


var id = ""


func init(item_data: Dictionary):
	print("Constants.item_sprites[int(item_data.type)]: ", Constants.item_sprites[int(item_data.type)])
	get_node("Sprite").texture = Constants.item_sprites[int(item_data.type)]
	get_node("StackAmountLabel").text = str(item_data.amount)
	id = item_data.id
	


func _input(event):
	if Input.is_action_just_pressed("drag_item") && hovering_over:
		ItemDragHandler.started_dragging_item(self, get_parent())


func _on_Item_mouse_entered():
	hovering_over = true


func _on_Item_mouse_exited():
	hovering_over = false
