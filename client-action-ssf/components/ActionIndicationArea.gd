extends Area2D


func init_indication_area(size: Vector2, pos: Vector2):
	var shape = RectangleShape2D.new()
	shape.extents = size
	$CollisionShape2D.shape = shape
	position = pos


func _on_ActionIndicationArea_mouse_entered():
	if get_parent().get_id() != Client.get_my_account().id:
		Events.emit_signal("hovered_over_entity_or_resource", get_parent())


func _on_ActionIndicationArea_mouse_exited():
	if get_parent().get_id() != Client.get_my_account().id:
		Events.emit_signal("left_hover_over_entity_or_resource", get_parent())


func _on_ActionIndicationArea_input_event(viewport, event, shape_idx):
	if get_parent().get_id() == Client.get_my_account().id:
		return
	
	if Client.ui_interaction_mode == Client.UIInteractionModes.GAMEPLAY:
		if Input.is_action_just_pressed("interact_action"):
			Events.emit_signal("touched_entity_or_resource", get_parent())
		if event is InputEventScreenTouch:
			if event.is_pressed():
				Events.emit_signal("touched_entity_or_resource", get_parent())
