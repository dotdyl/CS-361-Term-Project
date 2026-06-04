extends Node2D
class_name TileMapDetector

@export var tile_map_detector_signals : Array[TileMapDetectorSignals]

var tile_map_layer : TileMapLayer
var current_cell : TileData

var detector_signals : Array[Signal]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root = get_tree().current_scene as GameManager
	tile_map_layer = root.tile_map
	
	for tile_map_signal in tile_map_detector_signals:
		var node = get_node("../" + tile_map_signal.node_name)
		if node:
			add_user_signal(tile_map_signal.tile_map_target_data)
			var function = Callable(node, tile_map_signal.function_name)
			var new_signal = Signal(self, tile_map_signal.tile_map_target_data)
			detector_signals.append(new_signal)
			new_signal.connect(function)
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	get_tile_map_cell()

func get_tile_map_cell():
	var cell = tile_map_layer.local_to_map(tile_map_layer.to_local(global_position))
	var custom_data = tile_map_layer.get_cell_tile_data(cell)
	
	if current_cell == custom_data: return 
	else: current_cell = custom_data
	
	if !custom_data:
		return
	
	for d_signal in detector_signals:
		var data_name = d_signal.get_name()
		if custom_data.has_custom_data(data_name):
			var data = custom_data.get_custom_data(data_name)
			if data:
				d_signal.emit(custom_data.get_custom_data(data_name))
				print("emitted!")
