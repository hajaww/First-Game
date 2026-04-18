class_name State_Walk
extends State

@export var move_speed: float = 65.0

@onready var idle: State = $"../Idle"
@onready var attack: State = $"../Attack"

func Enter() -> void:
	player.UpdateAnimation("walk")

func Process(_delta: float) -> State:
	if player.direction == Vector2.ZERO:
		return idle
		
	player.velocity = player.direction * move_speed
		
	if player.SetDirection():
		player.UpdateAnimation("walk")
	return null

	# update arah + anim jalan
	if player.SetDirection():
		player.UpdateAnimation("walk")

	return null
	
func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null
