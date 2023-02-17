extends Control


onready var WelcomePage = $Welcome
onready var LoadingPage = $Loading
onready var LoginPage = $Login
onready var CreateAccountPage = $CreateAnAccount
onready var SelectPlayerPage = $SelectPlayerPage
onready var WorldMapPage = $WorldMapPage


func _ready():
	API.attempt_connect()
	
	var refresh_token_expired = Client.check_refresh_token_expiration()
	if refresh_token_expired:
		show_page(WelcomePage)
	else:
		show_page(LoadingPage)
	
	Events.connect("authenticated", self, "_on_authenticated")
	Events.connect("no_refresh_token", self, "_on_no_refresh_token")


func _on_authenticated(_account) -> void:
	show_page(SelectPlayerPage)


func _on_no_refresh_token() -> void:
	show_page(WelcomePage)


func show_page(page: Control) -> void:
	for page in get_children():
		if page.name != "Background":
			page.set_visible(false)
	
	page.set_visible(true)


func _on_OpenLogInButton_button_down():
	show_page(LoginPage)


func _on_OpenCreateAccountButton_button_down():
	show_page(CreateAccountPage)


func _on_CreateAnAccountBackButton_pressed():
	show_page(WelcomePage)


func _on_LogOutButton_pressed():
	show_page(WelcomePage)
	Events.emit_signal("logged_out")


func _on_LogInBackButton_pressed():
	show_page(WelcomePage)


func _on_OpenWorldMapPage_button_down():
	show_page(WorldMapPage)


func _on_WorldMapPage_back_button_pressed():
	show_page(WelcomePage)
