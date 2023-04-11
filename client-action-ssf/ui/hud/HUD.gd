extends CanvasLayer


var death_screen_scene = load("res://ui/hud/DeadScreenBackdrop.tscn")
var dead = false


func _ready():
	Events.connect("my_health_changed", self, "_on_my_health_changed")


func _on_my_health_changed(health: int):
	if health <= 0 && dead == false:
		dead = true
		var death_screen = death_screen_scene.instance()
		add_child(death_screen)
