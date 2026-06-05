extends Node
class_name MicroserviceManager

@onready var http_request1: HTTPRequest = %HTTPRequest1
@onready var http_request2: HTTPRequest = %HTTPRequest2

@export var launch_microservices : bool = false
@export var microservice_app_names : Array[String]

var local_url : String = "http://127.0.0.1:"

var requesting_1 : bool = false
var requesting_2 : bool = false

var process_ids : Array[int]

signal processes_closed
signal responsed1
signal responsed2

func _ready():
	get_tree().set_auto_accept_quit(false)
	processes_closed.connect(exit)
	http_request1.request_completed.connect(_on_request_completed1)
	http_request2.request_completed.connect(_on_request_completed2)
	if launch_microservices:
		for app in microservice_app_names:
			process_ids.append(launch_microservice(app))

func send_request(port : int, path : String, body := {}, method := HTTPClient.METHOD_GET):
	var json = JSON.stringify(body)
	var headers = ["Content-Type: application/json"]
	var response = "Requests are busy"
	if !requesting_1:
		requesting_1 = true
		http_request1.request(local_url + var_to_str(port) + path, headers, method, json)
		response = await responsed1
		requesting_1 = false
	elif !requesting_2:
		requesting_2 = true
		http_request2.request(local_url + var_to_str(port) + path, headers, method, json)
		response = await responsed2
		requesting_2 = false
	return response

func _on_request_completed1(result, response_code, headers, body):
	var json
	if body:
		json = JSON.parse_string(body.get_string_from_utf8())
	#print(json)
	responsed1.emit({
		"result" : result, 
		"response_code" : response_code, 
		"headers" : headers, 
		"body" : json
	})
	
func _on_request_completed2(result, response_code, headers, body):
	var json
	if body:
		json = JSON.parse_string(body.get_string_from_utf8())
	#print(json)
	responsed2.emit({
		"result" : result, 
		"response_code" : response_code, 
		"headers" : headers, 
		"body" : json
	})

func launch_microservice(app_name : String) -> int:
	var app_path = get_python_app_path(app_name)
	var pid = OS.create_process(app_path, [])
	
	if pid > 0:
		print("Packaged app ", app_name, " running in background. Process ID: ", pid)
	else:
		print("Could not start the executable.")
		
	return pid

func get_python_app_path(app_name : String) -> String:
	
	if OS.has_feature("editor"):
		return ProjectSettings.globalize_path("res://").path_join(app_name)
	else:
		var base_dir = OS.get_executable_path().get_base_dir()
		return base_dir.path_join(app_name)

func close_all():
	for process in process_ids:
		close_microservice(process)
	processes_closed.emit()
	print("closed")

func close_microservice(pid : int):
	var index = process_ids.find(pid)
	print("Shutting down Python microservice ", microservice_app_names[index], "...")
	OS.kill(pid)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		close_all() # Could replace with http request to properly shut down processes
		
func exit():
	get_tree().quit()
