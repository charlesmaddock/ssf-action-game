extends Node


const RESOURCE_DIM: Vector2 = Vector2(48, 48)
const TILE_DIM: Vector2 = Vector2(16, 16)


enum ItemTypes {
	LOG,
	ROCK
}


enum ConsoleMessageTypes {
	ERROR,
	SUCCESS,
	LOG
}


enum AppMode {
	DEVELOPMENT,
	RELEASE
}


onready var item_sprites = {
	ItemTypes.LOG: load("res://assets/sprites/log.png"),
	ItemTypes.ROCK: load("res://assets/sprites/rock.png")
}


var test_production_mode: bool = false
var app_mode: int = AppMode.DEVELOPMENT if OS.is_debug_build() && test_production_mode == false else AppMode.RELEASE


