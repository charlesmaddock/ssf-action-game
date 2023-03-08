extends Node


signal console_message(msg, type)
signal show_error_panel(msg)


signal authenticated(account)
signal no_refresh_token()
signal logged_out()
signal back_to_main_menu()


signal game_loaded(game_node) 


signal follow_w_camera(follow)


signal chat_button_pressed()
signal zoom_out_button_pressed()
signal zoom_in_button_pressed()
signal open_inv_button_pressed()
signal settings_button_pressed()


signal hovered_over_entity_or_resource(entity_or_resource)
signal left_hover_over_entity_or_resource(entity_or_resource)
signal touched_entity_or_resource(entity_or_resource)


signal effect(id, direction)
signal text_effect(id, text, modulate)
