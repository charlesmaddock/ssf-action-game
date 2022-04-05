extends Control


onready var HideColorRect: ColorRect = $ColorRect
onready var ShowAreaShape: CollisionShape2D = $ColorRect/ShowArea/CollisionShape2D


var opacity: float = 1
var players: Array
var _our_player_is_in_room: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var shape: RectangleShape2D = ShowAreaShape.get_shape()
	shape.set_extents(Vector2(rect_size.x / 2, rect_size.y / 2) + Vector2.ONE * 32)
	ShowAreaShape.position = rect_size / 2 


func _process(delta):
	if _our_player_is_in_room:
		opacity -= delta * 10
	else:
		opacity += delta * 10
	
	opacity = clamp(opacity, 0, 1)
	HideColorRect.modulate = Color(1, 1, 1, opacity)


func _on_ShowArea_body_entered(body):
	if body.get("Sprite") != null:
		if body.get_id() == Lobby.my_id:
			_our_player_is_in_room = true


func _on_ShowArea_body_exited(body):
	if body.get("Sprite") != null:
		if body.get_id() == Lobby.my_id:
			_our_player_is_in_room = false
