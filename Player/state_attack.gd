class_name State_Attack
extends State

@onready var idle: State = $"../Idle"

# Flag untuk menandakan anim attack sudah selesai
var finished: bool = false

# Simpan nama anim yang sedang dimainkan (biar aman saat cek selesai)
var current_attack_anim: String = ""

func Enter() -> void:
	# Saat masuk attack:
	# - hentikan movement
	# - play anim attack sesuai arah terakhir
	player.velocity = Vector2.ZERO
	player.SetDirection()

	# Tentukan anim yang harus diputar
	current_attack_anim = _get_attack_anim_name(player.last_dir)

	# Pastikan attack tidak loop (sekali pukul selesai)
	player.sprite.sprite_frames.set_animation_loop(current_attack_anim, false)

	# Mainkan anim attack dari awal
	player.sprite.play(current_attack_anim)
	player.sprite.frame = 0

	# Reset flag
	finished = false

	# Hubungkan sinyal animation_finished (jaga-jaga biar tidak double connect)
	if not player.sprite.animation_finished.is_connected(_on_anim_finished):
		player.sprite.animation_finished.connect(_on_anim_finished)

func Exit() -> void:
	# Saat keluar attack, kita boleh tetap connect (nggak masalah),
	# tapi biar rapi kita disconnect.
	if player.sprite.animation_finished.is_connected(_on_anim_finished):
		player.sprite.animation_finished.disconnect(_on_anim_finished)

func Process(_delta: float) -> State:
	# Selama attack, player tidak boleh jalan
	player.velocity = Vector2.ZERO

	# Kalau anim selesai, balik ke idle
	if finished:
		return idle

	return null

func _on_anim_finished() -> void:
	# Pastikan yang selesai adalah anim attack kita (bukan anim lain)
	if player.sprite.animation == current_attack_anim:
		finished = true

func _get_attack_anim_name(dir: String) -> String:
	# Mapping 4 arah untuk attack (tanpa side)
	match dir:
		"up":
			return "attack_up"
		"down":
			return "attack_down"
		"left":
			return "attack_left"
		"right":
			return "attack_right"
		_:
			return "attack_down"
