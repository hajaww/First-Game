class_name LevelTileMap extends TileMap

func _ready() -> void:
	# Pastikan script LevelManager sudah jadi Autoload
	LevelManager.ChangeTileMapBounds( GetTilemapBounds() )

func GetTilemapBounds() -> Array[ Vector2 ]:
	var bounds : Array[ Vector2 ] = []
	
	# Menggunakan tile_set.tile_size lebih akurat daripada rendering_quadrant_size
	bounds.append(
		Vector2( get_used_rect().position * tile_set.tile_size )
	)
	bounds.append(
		Vector2( get_used_rect().end * tile_set.tile_size )
	)
	return bounds
