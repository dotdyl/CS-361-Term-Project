extends Node
class_name StateMachine

@export var state_signal_switchers : Array[StateSignalSwitcher] = []
@export var initial_state : State

@export var state_label : Label

var state : State

signal transitioned(state_name)

func _ready():
	await owner.ready
	state = initial_state
	for child in get_children():
		if child is State:
			child.state_machine = self
	state.enter()
	
	for switcher in state_signal_switchers:
		var node = get_node("../" + switcher.node_name)
		if node:
			if !switcher.no_msg:
				node.connect(switcher.signal_name, state_signal_switch.bind(switcher.acceptable_states, switcher.target_state))
			else:
				node.connect(switcher.signal_name, state_signal_switch_no_msg.bind(switcher.acceptable_states, switcher.target_state))
	
func _unhandled_input(event: InputEvent):
	if state is PlayerState:
		state.handle_input(event)

func _process(delta: float):
	if state:
		state.update(delta)
		
func _physics_process(delta: float):
	if state:
		state.physics_update(delta)

func transition_to(target_state_name: String, msg := {}):
	
	if not has_node(target_state_name):
		#print("Can't find state with target namea")
		return
		
	if state_label:
		state_label.text = target_state_name
		
	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	#print("State transitioned to ", state.name)
	emit_signal("transitioned", state.name)

func state_signal_switch(msg : Dictionary, acceptable_states : Array[String], target_state_name : String):
	
	#print("State switch from signald")
	if !acceptable_states.has(state.name) and acceptable_states.size() != 0:
		#print("Can't force switch from this state")
		return
		
	transition_to(target_state_name, msg)

func state_signal_switch_no_msg(acceptable_states : Array[String], target_state_name : String):
	#print("State switch from signald")
	if !acceptable_states.has(state.name) and acceptable_states.size() != 0:
		#print("Can't force switch from this state")
		return
		
	transition_to(target_state_name)
