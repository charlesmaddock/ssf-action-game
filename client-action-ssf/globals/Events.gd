extends Node


signal console_message(msg, type)
signal show_error_panel(msg)


signal authenticated(account)
signal no_refresh_token()
signal logged_out()
signal back_to_main_menu()


signal player_dead(id)
signal game_over() 
signal game_win(reason)
signal switched_spectate(entity)
signal add_footstep()
signal cutscene_over()
signal follow_w_camera(follow)
signal one_min_left()
signal time_left(seconds_left, total_timer)
