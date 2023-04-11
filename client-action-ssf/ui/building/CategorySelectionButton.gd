extends Button


signal on_category_selected(category)


var _category: int
var category_names = {
	BuildingConstants.BuildingCategory.WALL: "Walls",
	BuildingConstants.BuildingCategory.CONTAINER: "Containers",
	BuildingConstants.BuildingCategory.TERRITORY: "Territory",
}


func init(category):
	_category = category
	text = category_names[category]


func _on_CategorySelectionButton_button_down():
	emit_signal("on_category_selected", _category)
