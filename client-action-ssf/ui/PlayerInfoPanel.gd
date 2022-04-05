extends Control


onready var Panel = $Panel
onready var Name = $Panel/MarginContainer/vbox/Name
onready var ClassName = $Panel/MarginContainer/vbox/Class


func _ready():
	clear()


func clear() -> void:
	Panel.set_visible(false)


func set_player_info(name, id, className) -> void:
	Panel.set_visible(true)
	
	Name.text = name + " (" + id + ")"
	ClassName.text = className
