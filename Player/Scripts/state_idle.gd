class_name State_Idle
extends State

@onready var walk: State = $"../Walk"

func Enter() -> void:
	player.UpdateAnimation("idle")

func Process(_delta: float) -> State:
	if player.direction != Vector2.ZERO:
		player.SetDirection()
		return walk

	player.velocity = Vector2.ZERO
	return null
