class_name State_Attack
extends State

# ------------------------------------------------------------------------------
# KONFIGURASI & VARIABEL
# ------------------------------------------------------------------------------
@export_group("Audio Settings")
@export var attack_sound : AudioStream 

# Referensi Node (Pastikan path sesuai Scene Tree)
@onready var idle = $"../Idle"
@onready var audio_player : AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var hurt_box: HurtBox = $"../../Interactions/HurtBox"

# Variabel Internal State
var target_frame: int = 0  # Frame berapa animasi harus berhenti
var timer: float = 0.0     # Timer pengaman jika animasi macet

# ------------------------------------------------------------------------------
# FUNGSI MASUK STATE (SETUP & AKSI)
# ------------------------------------------------------------------------------
func Enter() -> void:
	# 1. [GERAKAN] Hentikan pemain total & update arah hadap
	player.velocity = Vector2.ZERO
	if player.direction != Vector2.ZERO:
		player.SetDirection()
	
	# 2. [SAFETY] Pastikan hitbox mati dulu sebelum mulai (reset state)
	if hurt_box:
		hurt_box.monitoring = false
	
	# 3. [LOGIKA COMBO] Cek apakah combo lanjut atau reset karena kelamaan
	var current_time = Time.get_ticks_msec()
	if current_time - player.last_attack_time > player.combo_window:
		player.combo_index = 0 # Reset ke serangan pertama jika telat
	
	# 4. [VISUAL] Tentukan frame animasi berdasarkan urutan combo
	player.UpdateAnimation("attack") # Memuat animasi dasar
	
	if player.combo_index == 0:
		# Serangan 1: Frame 0 sampai 5
		player.sprite.frame = 0
		target_frame = 5
	else:
		# Serangan 2: Frame 6 sampai 11
		player.sprite.frame = 6
		target_frame = 11
	
	player.sprite.play() # Jalankan animasi
	
	# 5. [GAME FEEL] Delay Attack (Jeda sebelum damage masuk)
	# Tunggu sebentar agar damage muncul pas pedang diayun, bukan pas tombol ditekan
	await get_tree().create_timer(0.075).timeout
	
	# [CRITICAL] Cek apakah state masih aktif setelah menunggu?
	# Jika pemain kena damage/mati saat menunggu, jangan nyalakan hitbox!
	if player.fsm.current_state != self:
		return
		
	# 6. [AKSI] Nyalakan Hitbox dan Audio
	if hurt_box:
		hurt_box.monitoring = true
		
	if audio_player and attack_sound:
		audio_player.stream = attack_sound
		audio_player.pitch_scale = randf_range(0.9, 1.1) # Variasi suara
		audio_player.play()
		
	timer = 0.0 # Reset safety timer

# ------------------------------------------------------------------------------
# FUNGSI KELUAR STATE (CLEANUP)
# ------------------------------------------------------------------------------
func Exit() -> void:
	# 1. [SAFETY] Matikan Hitbox agar tidak melukai apapun saat Idle/Walk
	if hurt_box:
		hurt_box.monitoring = false

	# 2. [DATA] Simpan waktu serangan ini untuk kalkulasi combo berikutnya
	player.last_attack_time = Time.get_ticks_msec()
	
	# 3. [COMBO] Siapkan index untuk serangan berikutnya (Flip-Flop 0 <-> 1)
	if player.combo_index == 0:
		player.combo_index = 1
	else:
		player.combo_index = 0 
		
	# 4. [COOLDOWN] Aktifkan jeda tombol agar tidak bisa spamming
	if "current_attack_cooldown" in player:
		player.current_attack_cooldown = player.attack_cooldown_duration

# ------------------------------------------------------------------------------
# FUNGSI PROSES (LOOP PER FRAME)
# ------------------------------------------------------------------------------
func Process(delta: float) -> State:
	player.velocity = Vector2.ZERO # Kunci posisi selama menyerang
	timer += delta
	
	# 1. [CEK ANIMASI] Jika frame saat ini sudah mencapai target, berhenti.
	if player.sprite.frame >= target_frame:
		player.sprite.pause() # Bekukan frame agar tidak bocor
		return idle           # Kembali ke state Idle
		
	# 2. [FALLBACK] Jika animasi macet/glitch lebih dari 1 detik, paksa keluar.
	if timer > 1.0: 
		return idle

	return null
