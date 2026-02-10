class_name PlayerCamera extends Camera2D

func _ready() -> void:
	LevelManager.TileMapBoundsChanged.connect( UpdateLimits )
	UpdateLimits( LevelManager.current_tilemap_bounds )

func UpdateLimits( bounds : Array[ Vector2 ]) -> void:
	# Jika data masih kosong, jangan proses
	if bounds.size() == 0:
		return
	
	# Set limit camera internal Godot
	limit_left = int( bounds[0].x )
	limit_top = int( bounds[0].y )
	limit_right = int( bounds[1].x )
	limit_bottom = int( bounds[1].y )
	
	# Debug print (Lihat di tab Output bawah saat game jalan)
	print("Camera Limits Updated: Left:", limit_left, " Right:", limit_right, " Top:", limit_top, " Bottom:", limit_bottom)
