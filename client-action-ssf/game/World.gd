extends TileMap


var chunks: Array = []


func _ready():
	API.connect("packet_received", self, "_on_packet_received")
	for i in 9:
		var tile_map = TileMap.new()
		chunks.append()


func _on_packet_received(event: String, data: Dictionary):
	if event == "compressedChunkData":
		for chunk_data in data:
			


#[{globalPosX:10240, globalPosY:10240, tiles:[{amount:400, type:0}]
