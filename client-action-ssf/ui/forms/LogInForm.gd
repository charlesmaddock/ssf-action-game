extends PanelContainer


onready var SubmitButton = $MarginContainer/LogInForm/SubmitButton
onready var UsernameLineEdit = $MarginContainer/LogInForm/Username
onready var PasswordLineEdit = $MarginContainer/LogInForm/Password
onready var SubmitHTTPRequest: CustomHTTPRequest = $MarginContainer/LogInForm/SubmitHTTPRequest


func _ready():
	if(Constants.app_mode == Constants.AppMode.DEVELOPMENT):
		UsernameLineEdit.text = "charles"
		PasswordLineEdit.text = "Abc123!!!."
	
	SubmitHTTPRequest.connect("request_completed", self, "_on_request_completed")


func _on_request_completed(result, response_code, headers, body):
	SubmitButton.set_loading(false)
	
	if response_code >= 200 && response_code < 300:
		Client.handle_authenticated(body)


func _on_SubmitButton_pressed():
	var body = {"username": UsernameLineEdit.get_text(), "password": PasswordLineEdit.get_text()}
	SubmitHTTPRequest.post_request("/auth/signin", body)
