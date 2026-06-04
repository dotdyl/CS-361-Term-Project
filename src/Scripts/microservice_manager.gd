extends Node
class_name MicroserviceManager

@export var microservice_app_names : Array[String]

var process_ids : Array[int]

func _ready():
	
	for app in microservice_app_names:
		process_ids.append(launch_microservice(app))

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

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		for process in process_ids:
			var index = process_ids.find(process)
			print("Shutting down Python microservice ", microservice_app_names[index], "...")
			OS.kill(process) # Could replace with http request to properly shut down processes
			
		get_tree().quit()
