extends Node


const RESOURCE_DIM: Vector2 = Vector2(48, 48)
const TILE_DIM: Vector2 = Vector2(16, 16)


enum EntityTypes {
	HUMAN,
	CRAB
}


enum ItemType {
	LOG,
	ROCK,
	BEAM,
	BRANCH,
	SHARD,
	SHAFT,
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
	ItemType.LOG: {"name": "Log", "image":load("res://assets/sprites/log.png"), "mod": Color("#ffffff")},
	ItemType.ROCK: {"name": "Rock", "image":load("res://assets/sprites/rock.png"), "mod": Color("#ffffff")},
	ItemType.BEAM: {"name": "Beam", "image":load("res://assets/sprites/beam.png"), "mod": Color("#ffffff")},
	ItemType.BRANCH: {"name": "Branch", "image":load("res://assets/sprites/branch.png"), "mod": Color("#ffffff")},
	ItemType.SHARD: {"name": "Shard", "image":load("res://assets/sprites/shard.png"), "mod": Color("#ffffff")},
	ItemType.BLADE: {"name": "Blade", "image":load("res://assets/sprites/blade.png"), "mod": Color("#ffffff")},
	ItemType.ARROW: {"name": "Arrow", "image":load("res://assets/sprites/arrow.png"), "mod": Color("#ffffff")},
	ItemType.SHAFT: {"name": "Shaft", "image":load("res://assets/sprites/shaft.png"), "mod": Color("#8c6551")},
	ItemType.KNIFE: {"name": "Knife", "image":load("res://assets/sprites/knife.png"), "mod": Color("#ffffff")},
}


var test_production_mode: bool = false
var app_mode: int = AppMode.DEVELOPMENT if OS.is_debug_build() && test_production_mode == false else AppMode.RELEASE


