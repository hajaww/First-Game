class_name State_Idle
extends State

@onready var walk = $"../Walk"
@onready var attack = $"../Attack"

func Enter() -> void:
	player.UpdateAnimation("idle")
	player.velocity = Vector2.ZERO

func Process(_delta: float) -> State:
	# Prioritas attack
	if Input.is_action_just_pressed("attack"):
		# jangan paksa SetDirection kalau tidak ada input,
		# biar pakai last_dir sebelumnya
		if player.direction != Vector2.ZERO:
			player.SetDirection()
		return attack

	# Kalau ada input gerak -> Walk
	if player.direction != Vector2.ZERO:
		player.SetDirection()
		return walk

	player.velocity = Vector2.ZERO
	return null
