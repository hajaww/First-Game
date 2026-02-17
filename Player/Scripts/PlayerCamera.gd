class_name PlayerCamera extends Camera2D

func _ready() -> void:
	LevelManager.TileMapBoundsChanged.connect( UpdateLimits )
	UpdateLimits( LevelManager.current_tilemap_bounds )

func UpdateLimits( bounds : Array[ Vector2 ]) -> void:
	if bounds == []:
		return
	
	limit_left = int( max(bounds[0].x, 0) ) 
	limit_top = int( max(bounds[0].y, 0) )
	
	limit_right = int( bounds[1].x )
	limit_bottom = int( bounds[1].y )
	
	# Debug untuk memastikan angka yang masuk sekarang benar
	print("Camera Limits FORCED: Left:", limit_left, " Right:", limit_right, " Top:", limit_top, " Bottom:", limit_bottom)
