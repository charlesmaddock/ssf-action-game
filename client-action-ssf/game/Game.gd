extends Node2D


var player_scene = preload("res://entities/Player.tscn")


onready var Camera: Camera2D = $Camera
onready var Entities = $Entities


func _ready():
	API.joinWorld()

