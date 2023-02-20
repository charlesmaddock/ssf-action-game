extends Node2D


export(NodePath) var worldYSortPath
onready var WorldYSort = get_node(worldYSortPath)


var chunk_scene = load("res://world/Chunk.tscn")
var resource_scene = load("res://resources/Resource.tscn")


func _ready():
	API.connect("packet_received", self, "_on_packet_received")


func _on_packet_received(event: String, data: Dictionary):
	if event == "compressedChunkData":
		for missingChunkId in data.missingChunks:
			for chunk_scene in get_children():
				if chunk_scene.chunk_id == missingChunkId:
					chunk_scene.deactive()
		for chunkData in data.compressedChunkData:
			for chunk_scene in get_children():
				if chunk_scene.chunk_id == chunkData.id:
					chunk_scene.init(chunkData, resource_scene, WorldYSort)
					continue
			var chunk = chunk_scene.instance()
			add_child(chunk)
			chunk.init(chunkData, resource_scene, WorldYSort)
