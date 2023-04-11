extends Node


enum BuildingType {
	FENCE,
	PALISADE,
	WALL,
	BASKET,
	CHEST,
	FACTION_BANNER
}


enum BuildingState {
	UNDER_CONSTRUCTION,
	COMPLETE,
	RUBBLE,
	OVERGROWN,
}


enum BuildingCategory {
	WALL,
	CONTAINER,
	TERRITORY
}


var building_data = {
	BuildingType.FENCE: {"name": "Fence", "category": BuildingCategory.WALL, "texture": load("res://assets/building/fence.png")},
	BuildingType.WALL: {"name": "Wall", "category": BuildingCategory.WALL, "texture": load("res://assets/building/wall.png")},
	BuildingType.PALISADE: {"name": "Palisade Wall", "category": BuildingCategory.WALL, "texture": load("res://assets/building/palisadeWall.png")},
	BuildingType.BASKET: {"name": "Basket", "category": BuildingCategory.CONTAINER, "texture": load("res://assets/building/basket.png")},
	BuildingType.CHEST: {"name": "Chest", "category": BuildingCategory.CONTAINER, "texture": load("res://assets/building/chest.png")},
	BuildingType.FACTION_BANNER: {"name": "Faction Banner", "category": BuildingCategory.TERRITORY, "texture": load("res://assets/building/territory/factionBanner.png")},
}
