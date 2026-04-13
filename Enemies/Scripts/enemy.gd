class_name Enemy extends CharacterBody2D

signal direction_changed( new_direction : Vector2 )
signal enemy_damaged()

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

@export var hp : int = 3

var

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
