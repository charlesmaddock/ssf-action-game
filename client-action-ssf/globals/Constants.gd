extends Node


enum ConsoleMessageTypes {
	ERROR,
	SUCCESS,
	LOG
}


enum AppMode {
	DEVELOPMENT,
	RELEASE
}


var test_production_mode: bool = false
var app_mode: int = AppMode.DEVELOPMENT if OS.is_debug_build() && test_production_mode == false else AppMode.RELEASE

