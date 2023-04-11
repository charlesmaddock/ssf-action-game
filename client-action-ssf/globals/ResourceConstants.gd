extends Node


enum ResourceType {
  OAK,
  BIRCH,
  MAPLE,
  MAGNOLIA,
  CHERRY,
  
  GNEISS,
  GRANITE,
  LIMESTONE,
  SANDSTONE,
  TUFF,

  GOOSEBERRY,
  PLUM,
  BLUEBERRY,
  BLACKCURRANT,
  STRAWBERRY,

  FLAX,
  REED,
  PAMPAS,
  BLUESTEM,
  SWITCHGRASS,
}


const resource_info = {
	-1: {"name_priority": 99, "name": "Any", "scene": preload("res://resources/Tree.tscn"), "default_modulate": Color.white, "item_modulate": {} },
	
	ResourceType.OAK: {"name_priority": 3, "name": "Oak", "scene": preload("res://resources/Tree.tscn"), "default_modulate": Color("#8f6a54"), "item_modulate": {Constants.ItemType.LEAF: Color("#488c72")} },
	ResourceType.BIRCH: {"name_priority": 3, "name": "Birch", "scene": preload("res://resources/Tree.tscn"), "default_modulate": Color("#d1c5be"), "item_modulate": {Constants.ItemType.LEAF: Color("#78db74")} },
	ResourceType.MAPLE:  {"name_priority": 3, "name": "Maple", "scene": preload("res://resources/Tree.tscn"), "default_modulate": Color("#733b35"), "item_modulate": {Constants.ItemType.LEAF: Color("#ff6b7a")} },
	ResourceType.MAGNOLIA:  {"name_priority": 3, "name": "Magnolia", "scene": preload("res://resources/Tree.tscn"), "default_modulate": Color("#7a6356"), "item_modulate": {Constants.ItemType.LEAF: Color("#fca9ea")} },
	ResourceType.CHERRY:  {"name_priority": 3, "name": "Cherry", "scene": preload("res://resources/Tree.tscn"), "default_modulate": Color("#7a6356"), "item_modulate": {Constants.ItemType.LEAF: Color("#a9fcc1")} },
	
	ResourceType.GNEISS: {"name_priority": 2, "name": "Gneiss", "scene": preload("res://resources/Stone.tscn"), "default_modulate": Color("#8c625e"), "item_modulate": {} },
	ResourceType.GRANITE: {"name_priority": 2, "name": "Granite", "scene": preload("res://resources/Stone.tscn"), "default_modulate": Color(1,1,1), "item_modulate": {} },
	ResourceType.LIMESTONE: {"name_priority": 2, "name": "Limestone", "scene": preload("res://resources/Stone.tscn"), "default_modulate": Color("#fceed4"), "item_modulate": {} },
	ResourceType.SANDSTONE: {"name_priority": 2, "name": "Sandstone", "scene": preload("res://resources/Stone.tscn"), "default_modulate": Color("#ffbd87"), "item_modulate": {} },
	ResourceType.TUFF: {"name_priority": 2, "name": "Tuff", "scene": preload("res://resources/Stone.tscn"), "default_modulate": Color("#363954"), "item_modulate": {} },
	
	ResourceType.GOOSEBERRY: {"name_priority": 5, "name": "Gooseberry", "scene": preload("res://resources/Bush.tscn"), "default_modulate": Color("#a2e0a9"), "item_modulate": {} },
	ResourceType.PLUM: {"name_priority": 5, "name": "Plum", "scene": preload("res://resources/Bush.tscn"), "default_modulate": Color("#91f2eb"), "item_modulate": {} },
	ResourceType.BLUEBERRY: {"name_priority": 5, "name": "Blueberry", "scene": preload("res://resources/Bush.tscn"), "default_modulate": Color("#32f0ad"), "item_modulate": {} },
	ResourceType.BLACKCURRANT: {"name_priority": 5, "name": "Blackcurrant", "scene": preload("res://resources/Bush.tscn"), "default_modulate": Color("#7de1ff"), "item_modulate": {} },
	ResourceType.STRAWBERRY: {"name_priority": 5, "name": "Strawberry", "scene": preload("res://resources/Bush.tscn"), "default_modulate": Color("#86f7af"), "item_modulate": {} },
	
	ResourceType.FLAX: {"name_priority": 4, "name": "Flax", "scene": preload("res://resources/TallGrass.tscn"), "default_modulate": Color("#e0fa9d"), "item_modulate": {} },
	ResourceType.REED: {"name_priority": 4, "name": "Reed", "scene": preload("res://resources/TallGrass.tscn"), "default_modulate": Color("#aaf291"), "item_modulate": {} },
	ResourceType.PAMPAS: {"name_priority": 4, "name": "Pampas", "scene": preload("res://resources/TallGrass.tscn"), "default_modulate": Color("#e2faca"), "item_modulate": {} },
	ResourceType.BLUESTEM: {"name_priority": 4, "name": "Bluestem", "scene": preload("res://resources/TallGrass.tscn"), "default_modulate": Color("#acd7fc"), "item_modulate": {} },
	ResourceType.SWITCHGRASS: {"name_priority": 4, "name": "Switchgrass", "scene": preload("res://resources/TallGrass.tscn"), "default_modulate": Color("#fcaf72"), "item_modulate": {} },
}
