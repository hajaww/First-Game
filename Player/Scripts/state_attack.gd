class_name State_Attack
extends State

@export var attack_sound : AudioStream 
@onready var idle = $"../Idle"
@onready var audio_player : AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"

var target_frame: int = 0
var timer: float = 0.0

func Enter() -> void:
	player.velocity = Vector2.ZERO
	if player.direction != Vector2.ZERO:
		player.SetDirection()
	
	# --- LOGIKA COMBO CHECK ---
	var current_time = Time.get_ticks_msec()
	
	# Jika jeda waktu terlalu lama dari serangan terakhir, reset ke combo awal (0)
	if current_time - player.last_attack_time > player.combo_window:
		player.combo_index = 0
	
	# Panggil animasi dasar dulu (ini akan reset ke frame 0 karena force_restart di player.gd)
	player.UpdateAnimation("attack")
	
	# --- ATUR FRAME BERDASARKAN COMBO ---
	if player.combo_index == 0:
		# Serangan 1: Mulai frame 0, Stop di frame 5
		player.sprite.frame = 0
		target_frame = 5
	else:
		# Serangan 2: Mulai frame 6, Stop di frame 11
		player.sprite.frame = 6
		target_frame = 11
	
	player.sprite.play() # Pastikan jalan
	
	# --- AUDIO (Opsional: Bisa bedakan suara per combo kalau mau) ---
	if audio_player and attack_sound:
		audio_player.stream = attack_sound
		audio_player.pitch_scale = randf_range(0.9, 1.1)
		audio_player.play()
		
	timer = 0.0

func Exit() -> void:
	# Update waktu serangan terakhir saat keluar
	player.last_attack_time = Time.get_ticks_msec()
	
	# Siapkan index untuk serangan berikutnya (0 -> 1 -> 0)
	if player.combo_index == 0:
		player.combo_index = 1
	else:
		player.combo_index = 0 # Balik ke awal setelah combo tamat
		
	# Jalankan cooldown seperti biasa
	if "current_attack_cooldown" in player:
		player.current_attack_cooldown = player.attack_cooldown_duration

func Process(delta: float) -> State:
	player.velocity = Vector2.ZERO
	timer += delta
	
	# --- LOGIKA BERHENTI ANIMASI ---
	# Cek apakah frame saat ini sudah melewati target frame
	if player.sprite.frame >= target_frame:
		# Kita pause sprite agar tidak bocor ke frame 6 (saat combo 1)
		player.sprite.pause() 
		return idle
		
	# Fallback jika animasi macet
	if timer > 1.0: 
		return idle

	return null
