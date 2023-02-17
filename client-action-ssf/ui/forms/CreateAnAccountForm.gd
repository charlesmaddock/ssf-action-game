extends PanelContainer


onready var SubmitButton = $MarginContainer/CreateAnAccountForm/SubmitButton
onready var SubmitHTTPRequest: CustomHTTPRequest = $"MarginContainer/CreateAnAccountForm/SubmitHTTPRequest"
onready var UsernameLineEdit = $MarginContainer/CreateAnAccountForm/Username
onready var PasswordLineEdit = $MarginContainer/CreateAnAccountForm/Password


func _ready():
	SubmitHTTPRequest.connect("request_completed", self, "_on_request_completed")


func _on_request_completed(result, response_code, headers, body):
	SubmitButton.set_loading(false)
	
	var json = JSON.parse(body.get_string_from_utf8())
	if response_code >= 200 && response_code < 300:
		Client.handle_authenticated(body)
		Events.emit_signal("console_message", "Account created!", Constants.ConsoleMessageTypes.SUCCESS)


func _on_SubmitButton_pressed():
	var body = {"username": UsernameLineEdit.get_text(), "password": PasswordLineEdit.get_text()}
	SubmitHTTPRequest.post_request("/auth/signup", body)
