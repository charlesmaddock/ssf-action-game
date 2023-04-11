extends ScrollContainer


var _category: int


func init(c: int):
	_category = c


func get_category():
	return _category


func add(building_selection_button):
	$Container.add_child(building_selection_button)
