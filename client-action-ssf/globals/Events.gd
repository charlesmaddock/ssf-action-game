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


signal hovered_over_entity(entity)
signal left_hover_over_entity(entity)
