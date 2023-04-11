extends Label


var descs = ["Experience digital metanoia like never before.", "Have you got the chance to meet Gloobert yet?", "Divide and conquer.", "Build and unite.", "What's extinct might come alive.", "A seemingly endless digital world where binary dreams manifest."]


func _ready():
	randomize()
	text = descs[randi() % descs.size()]
