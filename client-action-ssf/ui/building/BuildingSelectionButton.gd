extends TextureButton


var type: int


func init(building_type: int, building_data: Dictionary):
	$BuildingPreview.texture = building_data.texture
	type = building_type


func _on_BuildingSelectionButton_button_down():
	Events.emit_signal("building_selected", $BuildingPreview.texture, type)
