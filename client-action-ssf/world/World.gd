extends Node2D


export(NodePath) var worldYSortPath
onready var WorldYSort = get_node(worldYSortPath)


var chunk_scene = load("res://world/Chunk.tscn")
var resource_scene = load("res://resources/Resource.tscn")


func _ready():
	API.connect("packet_received", self, "_on_packet_received")


func _on_packet_received(event: String, data: Dictionary):
	if event == "compressedChunkData":
		for chunkData in data.compressedChunkData:
			var chunk = chunk_scene.instance()
			add_child(chunk)
			chunk.init(chunkData, resource_scene, WorldYSort)
