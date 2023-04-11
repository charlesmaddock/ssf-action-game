extends YSort
class_name Game


onready var Camera: Camera2D = $Camera
onready var Entities = $Entities
onready var JoyStick = $HUD/JoyStick


func _ready():
	Events.emit_signal("game_loaded", self)
	API.request_load_world()
