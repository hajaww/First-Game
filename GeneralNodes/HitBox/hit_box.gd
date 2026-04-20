class_name HitBox extends Area2D

signal Damaged (hurt_box: HurtBox )

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func TakeDamage ( hurt_box: HurtBox ) -> void:
	Damaged.emit( hurt_box )
