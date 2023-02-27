extends Node

# From Client
var connect: String = "connect"
var setMoveInput: String = "setMoveInput"
var requestSpawnPlayer: String = "requestSpawnPlayer"
var requestLoadWorld: String = "requestLoadWorld"
var leaveWorld: String = "leaveWorld"
var shootProjectile: String = "shootProjectile"
var sendChat: String = "sendChat"
var harvest: String = "harvest"
var attack: String = "attack"

# From API
var connected: String = "connected"
var serverMessage: String = "serverMessage"
var worldJoined: String = "worldJoined"
var spawnEntity: String = "spawnEntity"
var despawnEntity: String = "despawnEntity"
var setEntityPos: String = "setEntityPos"
var setEntityHealth: String = "setEntityHealth"
var spawnProjectile: String = "spawnProjectile"
var compressedChunkData: String = "compressedChunkData"
var chatMessage: String = "chatMessage"
var harvestedItem: String = "harvestedItem"
var addItemInv: String = "addItemInv"
var removeItemInv: String = "removeItemInv"
var inventoryContents: String = "inventoryContents"
