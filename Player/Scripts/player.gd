class_name Player
extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var fsm: PlayerStateMachine = $StateMachine

signal DirectionChanged( new_direction: Vector2)

var direction: Vector2 = Vector2.ZERO
var last_dir: String = "down"
# -- VARIABEL COMBO --
var combo_index: int = 0
var last_attack_time: int = 0
var combo_window: int = 800  # Waktu toleransi (ms) untuk lanjut combo (misal 0.8 detik)

func _ready() -> void:
	fsm.Initialize(self)

func _process(delta: float) -> void:
	direction = Vector2.ZERO
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = direction.normalized()

func _physics_process(delta: float) -> void:
	move_and_slide()

func SetDirection() -> bool:
	if direction == Vector2.ZERO:
		return false
	
	# 1. Tentukan arah string (untuk animasi)
	if abs(direction.x) > abs(direction.y):
		last_dir = "left" if direction.x < 0 else "right"
	else:
		last_dir = "up" if direction.y < 0 else "down"
	
	# 2. Konversi string ke Vector2 (untuk rotasi Hitbox)
	var dir_vector = Vector2.DOWN
	match last_dir:
		"up": dir_vector = Vector2.UP
		"down": dir_vector = Vector2.DOWN
		"left": dir_vector = Vector2.LEFT
		"right": dir_vector = Vector2.RIGHT
	
	# 3. FIX: Emit signal SEBELUM return
	DirectionChanged.emit( dir_vector )
	
	return true

func UpdateAnimation(kind: String) -> void:
	match kind:
		"idle":
			_play_idle()
		"walk":
			_play_walk()
		"attack":
			_play_attack()

func _play_idle() -> void:
	match last_dir:
		"up": _safe_play("idle_up", false, true)
		"down": _safe_play("idle_down", false, true)
		"left": _safe_play("idle_side", true, true)
		"right": _safe_play("idle_side", false, true)

func _play_walk() -> void:
	match last_dir:
		"up": _safe_play("run_up", false, true)
		"down": _safe_play("run_down", false, true)
		"left": _safe_play("run_side", true, true)
		"right": _safe_play("run_side", false, true)

func _play_attack() -> void:
	# Attack butuh force restart (parameter ke-4 = true)
	match last_dir:
		"up": _safe_play("attack_up", false, false, true)
		"down": _safe_play("attack_down", false, false, true)
		"left": _safe_play("attack_left", false, false, true) # Pastikan aset ada, atau gunakan attack_side + flip
		"right": _safe_play("attack_right", false, false, true)

# UPDATE PENTING DI SINI: Tambahkan parameter 'force_restart'
func _safe_play(anim: String, flip: bool, loop: bool, force_restart: bool = false) -> void:
	sprite.flip_h = flip
	
	# Hati-hati mengubah setting loop resource global saat runtime, 
	# tapi untuk AnimatedSprite2D biasanya aman per-instance.
	if sprite.sprite_frames.has_animation(anim):
		sprite.sprite_frames.set_animation_loop(anim, loop)
	
	# Jika animasi beda ATAU dipaksa restart (untuk attack)
	if sprite.animation != anim or force_restart:
		sprite.play(anim)
