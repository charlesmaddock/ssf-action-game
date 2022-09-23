extends Area2D


export(float) var damage
export(bool) var start_active = true


func _ready():
	set_active(start_active)


func get_damage() -> float:
	return damage


func set_active(val: bool) -> void:
	for child in get_children():
		child.disabled = !val
