extends Node
class_name State

var state_machine : StateMachine = null

# On transition into this state; optionally pass parameters through '_msg'
func enter(_msg := {}): 
	pass
	
# On exit from this state
func exit(): 
	pass
	
# Every tick while in this state
func update(_delta : float): 
	pass
	
# Every phyiscs tick while in this state
func physics_update(_delta : float): 
	pass
