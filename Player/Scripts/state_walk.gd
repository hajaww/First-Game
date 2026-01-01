class_name State_Walk
extends State

@export var move_speed: float = 65.0

@onready var idle = $"../Idle"
@onready var attack = $"../Attack"

func Enter() -> void:
	player.UpdateAnimation("walk")

func Process(_delta: float) -> State:
	# Attack saat jalan
	if Input.is_action_just_pressed("attack"):
		player.SetDirection()
		player.velocity = Vector2.ZERO
		return attack

	# stop -> idle
	if player.direction == Vector2.ZERO:
		player.velocity = Vector2.ZERO
		return idle

	# gerak
	player.velocity = player.direction * move_speed

	# update arah + anim jalan
	if player.SetDirection():
		player.UpdateAnimation("walk")

	return null
