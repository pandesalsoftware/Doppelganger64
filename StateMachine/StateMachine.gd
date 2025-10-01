extends Node


class_name StateMachine


@export var initState: State
var currState: State
var states: Dictionary = {}


func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.stateMachine = self
			
#Start with default state 
	if initState:
		_change_state(initState.name.to_lower())
		


func _process(delta: float) -> void:
	if currState:
		currState.update(delta)


func _physics_process(delta: float) -> void:
	if currState:
		currState._physics_update(delta)


func _input(event: InputEvent) -> void:
	if currState:
		currState._handle_input(event)


func _change_state(newStatename: String) -> void: 
	if currState:
		currState.exit()
	
	currState = states.get(newStatename.to_lower())
	
	if currState:
		currState.enter()
