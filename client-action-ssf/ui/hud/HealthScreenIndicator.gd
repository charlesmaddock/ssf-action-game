extends TextureRect


var target_opacity: float = 0


func _ready():
	Events.connect("my_health_changed", self, "_on_my_health_changed")
	modulate.a = 0


func _on_my_health_changed(health: int):
	print("_on_my_health_changed! ", health)
	target_opacity = clamp(1 - (float(clamp(health, 0, 60)) / 60.0), 0, 1)


func _process(delta):
	modulate.a = lerp(modulate.a, target_opacity, delta * 4)


func _on_LeaveGame_pressed():
	API.leave_world()
