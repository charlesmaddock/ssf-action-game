extends PanelContainer


var showing = false


func init(serialized_item: Dictionary):
	var item_info = Constants.item_info[int(serialized_item.type)]
	var resource_info = Util.get_highest_priority_made_of_resource(serialized_item.madeOf)
	$VBox/Label.text = resource_info.name + " " + item_info.name
	if serialized_item.desc.size() == 0:
		$VBox/Desc.visible = false
	else:
		$VBox/Desc.visible = true
		$VBox/Desc.text = ""
		var i = 0
		for desc in serialized_item.desc:
			$VBox/Desc.text += desc
			if i + 1 != serialized_item.desc.size():
				$VBox/Desc.text += "\n"
			i += 1


func _ready():
	hide()


func show():
	showing = true
	yield(get_tree().create_timer(0.2), "timeout")
	if showing == true:
		set_visible(true)


func hide():
	showing = false
	set_visible(false)
