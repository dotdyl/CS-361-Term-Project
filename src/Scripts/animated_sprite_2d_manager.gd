extends Node2D
class_name CompositeAnimatedSprite2D

var sprite_layers : Dictionary = {}
var prime_layer : AnimatedSprite2D = null

var frame : int
var playing : bool = false

func _ready() -> void:
	for child in get_children():
		if child is AnimatedSprite2D:
			sprite_layers[child.name] = child
			if !prime_layer: prime_layer = child
			
	if prime_layer:
		prime_layer.animation_finished.connect(animation_finished)
		prime_layer.frame_changed.connect(frame_changed)
		
func is_playing() -> bool:
	return playing

func for_each_layer(foo : Callable, parameter):
	for layer in sprite_layers:
		var sprite = sprite_layers[layer]
		foo.call(sprite, parameter)

func play(name : String):
	for_each_layer(do_play, name)
	playing = true
	
func do_play(sprite : AnimatedSprite2D, name : String):
	sprite.play(name)

func flip_h(flip : bool):
	for_each_layer(do_flip_h, flip)

func do_flip_h(sprite : AnimatedSprite2D, flip : bool):
	sprite.flip_h = flip
	
func frame_changed():
	frame = prime_layer.frame

func animation_finished():
	playing = false
