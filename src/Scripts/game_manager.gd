extends Node
class_name GameManager

@onready var http_request: HTTPRequest = %HTTPRequest

@export var tile_map : TileMapLayer

func _ready() -> void:
	http_request.request_completed.connect(_on_request_completed)
	var headers = ["Content-Type: application/json"]
	http_request.request("http://127.0.0.1:6000/daily_number", headers, HTTPClient.METHOD_GET)
	
func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)
