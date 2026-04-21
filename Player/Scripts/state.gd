class_name State
extends Node

# Reference ke Player (di-inject oleh StateMachine.Initialize)
static var player: Player
static	var state_machine : PlayerStateMachine

func _ready() -> void:
	pass
	

func init() -> void:
	pass

#What happen when playter enters this State?
func Enter() -> void:
	pass

#what happen when the player exits this state?
func Exit() -> void:
	pass

func Process(_delta: float) -> State:
	return null

func Physics(_delta: float) -> State:
	return null

func HandleInput(_event: InputEvent) -> State:
	return null
