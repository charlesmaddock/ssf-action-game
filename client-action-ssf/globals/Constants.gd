extends Node


const PLAYERS_PER_ROOM: int = 4


enum AppMode {
	DEVELOPMENT,
	RELEASE
}


enum PacketTypes {
	SERVER_MESSAGE,
	CONNECTED,
	UPDATE_CLIENT_DATA,
	HOST_ROOM,
	ROOM_HOSTED,
	JOIN_ROOM,
	ROOM_JOINED,
	LEAVE_ROOM,
	BACK_TO_LOBBY,
	ROOM_LEFT,
	START_GAME,
	GAME_STARTED,
	SET_INPUT,
	SET_PLAYER_POS,
	FREE_NODE,
	NODE_FREED,
	USE_ABILITY,
	ABILITY_USED,
	SET_HEALTH,
	SHOOT_PROJECTILE,
	START_DOORS,
	DISABLE_PORTALS,
	MINE_EXPLODE
}

enum AbilityEffects {
	SYSTEM_UPDATE,
	INCOGNITO,
	VPN,
	SLACK_ATTACK,
	MINE,
	DISGUISE
}


var class_info = [
	{"name": "Sam the Sniper", "tex": load("res://assets/sprites/player.png")},
	#{"name": "Ryan the Robot", "tex": load("res://assets/sprites/robot.png")},
	#{"name": "Anna the Assassin", "tex": load("res://assets/sprites/coolCharacter.png")},
	{"name": "Romance Scammer", "tex": load("res://assets/sprites/romanceScammer.png")},
]

var ability_effects = {
	AbilityEffects.SYSTEM_UPDATE: load("res://game/SystemUpdateEffect.tscn"),
	AbilityEffects.INCOGNITO: load("res://game/IncognitoEffect.tscn"),
	AbilityEffects.VPN: load("res://game/VPNEffect.tscn")
}


var app_mode: int = AppMode.DEVELOPMENT if OS.is_debug_build() else AppMode.RELEASE
