extends Node2D


export(NodePath) var worldYSortPath
onready var WorldYSort = get_node(worldYSortPath)


var chunk_scene = load("res://world/Chunk.tscn")
var resource_scene = load("res://resources/Resource.tscn")
var chunk_ids = [] 


func _ready():
	API.connect("packet_received", self, "_on_packet_received")


func _on_packet_received(event: String, data: Dictionary):
	if event == "compressedChunkData":
		for missingChunkId in data.missingChunks:
			for chunk in get_children():
				if chunk.chunk_id == missingChunkId:
					chunk.deactive()
		for chunkData in data.compressedChunkData:
			var found = false
			for chunk in get_children():
				if chunk.chunk_id == chunkData.id:
					chunk.init(chunkData, resource_scene, WorldYSort)
					found = true
					continue
			
			if found == false:
				var chunk = chunk_scene.instance()
				add_child(chunk)
				chunk.init(chunkData, resource_scene, WorldYSort)
