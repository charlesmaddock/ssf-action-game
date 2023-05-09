extends Node


signal console_message(msg, type)
signal show_error_panel(msg)


signal authenticated(account)
signal no_refresh_token()
signal logged_out()
signal back_to_main_menu()


signal game_loaded(game_node) 


signal follow_w_camera(follow)


signal my_health_changed(health)


signal chat_button_pressed()
signal zoom_out_button_pressed()
signal zoom_in_button_pressed()
signal open_inv_button_pressed()
signal settings_button_pressed()
signal build_button_pressed()
signal music_button_pressed()


signal inventory_toggled(visible)


signal text_effect(id, text, color)


signal hovered_over_entity_or_resource(entity_or_resource)
signal left_hover_over_entity_or_resource(entity_or_resource)
signal touched_entity_or_resource(entity_or_resource)


signal selected_item(item_id, item_type, item_made_of)
signal hotbar_slot_pressed(index)


signal building_selected(texture, type)
signal building_dropped()
