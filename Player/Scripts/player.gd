class_name Player
extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var fsm: PlayerStateMachine = $StateMachine

var last_dir := "down"   # down, up, side
var facing_left := false

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	fsm.Initialize(self)

func _process(delta: float) -> void:
	# input disimpan di player supaya state bisa baca
	direction = Vector2.ZERO
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = direction.normalized()

func _physics_process(delta: float) -> void:
	move_and_slide()

# dipanggil state untuk update arah terakhir
func SetDirection() -> bool:
	if direction == Vector2.ZERO:
		return false

	if abs(direction.x) > abs(direction.y):
		last_dir = "side"
		facing_left = direction.x < 0
	elif direction.y < 0:
		last_dir = "up"
	else:
		last_dir = "down"

	return true

# dipanggil state untuk play animasi
func UpdateAnimation(kind: String) -> void:
	# kind: "idle" atau "walk"
	if kind == "walk":
		_play_dir_anim("run") # kamu pakai run_*
	else:
		_play_dir_anim("idle")

func _play_dir_anim(prefix: String) -> void:
	# prefix = "idle" atau "run"
	match last_dir:
		"down":
			sprite.play("%s_down" % prefix)
			sprite.flip_h = false
		"up":
			sprite.play("%s_up" % prefix)
			sprite.flip_h = false
		"side":
			sprite.play("%s_side" % prefix)
			sprite.flip_h = facing_left
