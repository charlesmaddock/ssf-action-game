extends Node


const TILE_DIM: Vector2 = Vector2(16, 16)
const RESOURCE_DIM: Vector2 = Vector2(TILE_DIM.x * 6, TILE_DIM.y * 6)


enum EntityTypes {
	HUMAN,
	CRAB,
	GLOOBERT,
	BUNNY,
	BOAR,
	POLAR_BEAR,
	BROWN_BEAR,
	SKELETON_ARCHER,
	SKELETON_WARRIOR,
	FIRE_ELEMENTAL,
	ICE_ELEMENTAL,
	EARTH_ELEMENTAL,
	IMP,
	SNAKE
}


enum ItemType {
	LOG,
	ROCK,
	LEAF,
	FIBRE,
	BRANCH,
	BEAM,
	BLOCK,
	SHARD,
	SHAFT,
	BLADE,
	KNIFE,
	ARROW,
	SWORD,
	BOW,
	AXE,
	PICKAXE,
	SCYTHE,
}


enum TileType {
	VOID = -1,
	GRASS,
	SAND,
	GRAVEL,
	SNOW,
	WATER,
	TUNDRA,
	GLACIER,
	TREACHERY,
	BOREAL,
	FOREST,
	FLOWERS,
	WASTELAND,
	CANYON,
	OASIS,
	SCORCHED_EARTH,
	LAVA
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
	EntityTypes.HUMAN: {"image": load("res://assets/sprites/human.png"), "modulate": Color.white},
	EntityTypes.CRAB: {"image": load("res://assets/sprites/crab.png"), "modulate": Color.white},
	EntityTypes.GLOOBERT: {"image": load("res://assets/sprites/gloobert.png"), "modulate": Color.white},
	EntityTypes.BUNNY: {"image": load("res://assets/entity/bunny.png"), "modulate": Color.white},
	EntityTypes.BOAR: {"image": load("res://assets/entity/boar.png"), "modulate": Color("#e6c4b8")},
	EntityTypes.BROWN_BEAR: {"image": load("res://assets/entity/bear.png"), "modulate": Color("#bf9682")},
	EntityTypes.POLAR_BEAR: {"image": load("res://assets/entity/bear.png"), "modulate": Color.white},
	EntityTypes.SNAKE: {"image": load("res://assets/entity/snake.png"), "modulate": Color("#8fbf82")},
	EntityTypes.SKELETON_WARRIOR:  {"image": load("res://assets/entity/skeleton.png"), "modulate": Color.white},
	EntityTypes.IMP:  {"image": load("res://assets/entity/imp.png"), "modulate": Color("#c57ae6")},
	EntityTypes.FIRE_ELEMENTAL:  {"image": load("res://assets/entity/elemental.png"), "modulate": Color("#e6937a")},
	EntityTypes.ICE_ELEMENTAL:  {"image": load("res://assets/entity/elemental.png"), "modulate": Color("#adccf0")},
	EntityTypes.EARTH_ELEMENTAL:  {"image": load("res://assets/entity/elemental.png"), "modulate": Color("#a89c94")},
}


onready var item_info = {
	ItemType.LOG: {"name": "Log", "image":load("res://assets/sprites/log.png")},
	ItemType.ROCK: {"name": "Rock", "image":load("res://assets/sprites/rock.png")},
	ItemType.BRANCH: {"name": "Branch", "image":load("res://assets/sprites/branch.png")},
	ItemType.LEAF: {"name": "Leaf", "image":load("res://assets/sprites/leaf.png")},
	ItemType.FIBRE: {"name": "Fibre", "image":load("res://assets/sprites/fibre.png")},
	ItemType.BEAM: {"name": "Beam", "image":load("res://assets/sprites/beam.png")},
	ItemType.BLOCK: {"name": "Block", "image":load("res://assets/items/block.png")},
	ItemType.SHARD: {"name": "Shard", "image":load("res://assets/sprites/shard.png")},
	ItemType.BLADE: {"name": "Blade", "image":load("res://assets/sprites/blade.png")},
	ItemType.ARROW: {"name": "Arrow", "image":load("res://assets/sprites/arrow.png")},
	ItemType.SHAFT: {"name": "Shaft", "image":load("res://assets/sprites/shaft.png")},
	ItemType.KNIFE: {"name": "Knife", "image":load("res://assets/sprites/knife.png")},
	ItemType.BOW: {"name": "Bow", "image":load("res://assets/sprites/bow.png")},
	ItemType.SWORD: {"name": "Sword", "image":load("res://assets/sprites/sword.png")},
	ItemType.AXE: {"name": "Axe", "image":load("res://assets/sprites/axe.png")},
	ItemType.PICKAXE: {"name": "Pickaxe", "image":load("res://assets/sprites/pickaxe.png")},
	ItemType.SCYTHE: {"name": "Scythe", "image":load("res://assets/sprites/scythe.png")},
}


var test_production_mode: bool = false
var app_mode: int = AppMode.DEVELOPMENT if OS.is_debug_build() && test_production_mode == false else AppMode.RELEASE


