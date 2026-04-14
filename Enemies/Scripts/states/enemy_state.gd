class_name EnemyState extends Node

var enemy : Enemy
var state_machine : EnemyStateMachine


## What happens when we initialize this state?
func init() -> void:
	pass


## What happens when the enemy enters this state?
func enter() -> void:
	pass


## What happens when the enemy exits this State?
func exit() -> void:
	pass


## What happens druing the _process update in this State?
func process( _delta : float ) -> EnemyState:
	return null

func physics( _delta : float ) -> EnemyState:
	return null
