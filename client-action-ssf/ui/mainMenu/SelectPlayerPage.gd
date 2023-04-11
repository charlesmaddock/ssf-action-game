extends Control


func _ready():
	Events.connect("authenticated", self, "_on_authenticated")


func _on_authenticated(account: Account) -> void:
	pass
