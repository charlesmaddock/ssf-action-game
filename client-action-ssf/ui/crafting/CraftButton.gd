extends Button


signal craft_items(amount)


onready var preview_item = $PreviewItem/Item 
onready var loading_anim_player = $AnimationPlayer
onready var make_amount_line_edit = $PreviewItem/MakeAmountLineEdit

var loading = false
var max_result_amount: int = 0


