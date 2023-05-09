extends VBoxContainer


onready var building_category_tabs = $BuildingCategoryTabs
onready var building_options_container = $BuildingOptions


var building_selection_button_scene = load("res://ui/building/BuildingSelectionButton.tscn")
var building_category_options = load("res://ui/building/BuildingCategoryOptions.tscn")
var building_category_selection_button = load("res://ui/building/CategorySelectionButton.tscn")


func _ready():
	Events.connect("building_selected", self, "_on_building_selected")
	Events.connect("building_dropped", self, "_on_building_dropped")
	
	for c in BuildingConstants.BuildingCategory.values():
		var category = int(c)
		var options = building_category_options.instance()
		options.init(category)
		
		building_options_container.add_child(options)
		
		var button = building_category_selection_button.instance()
		button.init(category)
		building_category_tabs.add_child(button)
		button.connect("on_category_selected", self, "_on_category_selected")
	
		for building_type in BuildingConstants.building_data.keys():
			var data = BuildingConstants.building_data[building_type]
			
			if data.category == category:
				var building_selection_button = building_selection_button_scene.instance()
				building_selection_button.init(building_type, data)
				options.add(building_selection_button)
	
	_on_category_selected(BuildingConstants.BuildingCategory.WALL)


func _on_building_selected(texture: Texture, building_type: int):
	modulate.a = 0.1


func _on_building_dropped():
	modulate.a = 1


func _on_category_selected(category: int):
	for child in building_options_container.get_children():
		child.set_visible(child.get_category() == category)
