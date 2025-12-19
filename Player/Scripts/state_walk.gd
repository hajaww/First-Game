class_name State_Walk
extends State

@export var move_speed: float = 80.0
@onready var idle: State = $"../Idle"

func Enter() -> void:
	player.UpdateAnimation("walk")

func Process(_delta: float) -> State:
	if player.direction == Vector2.ZERO:
		player.velocity = Vector2.ZERO
		return idle

	player.velocity = player.direction * move_speed

	if player.SetDirection():
		player.UpdateAnimation("walk")

	return null
