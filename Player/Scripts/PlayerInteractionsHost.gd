class_name PlayerInteractionsCode 
extends Node2D

@onready var player : Player = $".." # Mengambil parent (Player)

func _ready() -> void:
	# Pastikan player ditemukan sebelum connect
	if player:
		player.DirectionChanged.connect( UpdateDirection )

func UpdateDirection( new_direction : Vector2 ) -> void:
	# Rotasi node Interactions berdasarkan Vector yang dikirim Player
	match new_direction:
		Vector2.DOWN:
			rotation_degrees = 0   # Bawah (Default)
		Vector2.UP:
			rotation_degrees = 180 # Atas (Balik)
		Vector2.LEFT:
			rotation_degrees = 90  # Kiri (Putar jarum jam 90)
		Vector2.RIGHT:
			rotation_degrees = -90 # Kanan (Lawan arah jarum jam 90)
		_:
			rotation_degrees = 0
	pass
