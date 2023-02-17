extends HTTPRequest
class_name CustomHTTPRequest


func post_request(route: String, body: Dictionary):
	var string_body = JSON.print(body)
	var headers = ["Content-Type: application/json"]
	var error = request(API.http_api_url + route, headers, true, HTTPClient.METHOD_POST, string_body)
	if error != OK:
		Events.emit_signal("console_message", "An error occurred in the HTTP request.", Constants.ConsoleMessageTypes.ERROR)


func get_request(route: String):
	var error = request(API.http_api_url + route, [], true, HTTPClient.METHOD_GET)
	if error != OK:
		Events.emit_signal("console_message", "An error occurred in the HTTP request.", Constants.ConsoleMessageTypes.ERROR)


func _on_CustomHTTPRequest_request_completed(result, response_code, headers, body):
	if response_code >= 400:
		var json = JSON.parse(body.get_string_from_utf8())
		if json.result.get("message") != null:
			if typeof(json.result.message) == TYPE_ARRAY:
				Events.emit_signal("console_message", PoolStringArray(json.result.message).join(", "), Constants.ConsoleMessageTypes.ERROR)
			else:
				Events.emit_signal("console_message", json.result.message, Constants.ConsoleMessageTypes.ERROR)
		else:
			Events.emit_signal("console_message", "Something went wrong whilst sending a request to the server", Constants.ConsoleMessageTypes.ERROR)
