extends Node


const RESOURCE_DIM: Vector2 = Vector2(48, 48)
const TILE_DIM: Vector2 = Vector2(16, 16)


enum EntityTypes {
	HUMAN,
	CRAB
}


enum ItemTypes {
	LOG,
	ROCK,
	BEAM,
	BRANCH,
	BLADE,
	KNIFE,
	ARROW,
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


onready var entity_info = {
	EntityTypes.HUMAN: {"image": load("res://assets/sprites/human.png")},
	EntityTypes.CRAB: {"image": load("res://assets/sprites/crab.png")}
}


onready var item_info = {
	ItemTypes.LOG: {"name": "Log", "image":load("res://assets/sprites/log.png")},
	ItemTypes.ROCK: {"name": "Rock", "image":load("res://assets/sprites/rock.png")},
	ItemTypes.BEAM: {"name": "Beam", "image":load("res://assets/sprites/beam.png")},
	ItemTypes.BRANCH: {"name": "Branch", "image":load("res://assets/sprites/branch.png")},
	ItemTypes.BLADE: {"name": "Blade", "image":load("res://assets/sprites/blade.png")},
	ItemTypes.ARROW: {"name": "Arrow", "image":load("res://assets/sprites/arrow.png")},
}


var test_production_mode: bool = false
var app_mode: int = AppMode.DEVELOPMENT if OS.is_debug_build() && test_production_mode == false else AppMode.RELEASE


