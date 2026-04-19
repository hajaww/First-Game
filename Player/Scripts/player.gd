class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]
var direction : Vector2 = Vector2.ZERO

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine

signal DirectionChanged( new_direction: Vector2)

func _ready():
	PlayerManager.player = self
	state_machine.Initialize(self)
	pass


func _process( delta ):
	
	#direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	#direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	direction = Vector2(
		Input.get_axis("left", 'right'),
		Input.get_axis("up", "down")
	).normalized()
	pass
	
func _physics_process( delta ):
	move_and_slide()



func SetDirection() -> bool:
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int( round( ( direction + cardinal_direction * 0.1 ).angle() / TAU * DIR_4.size() ) )
	var new_dir = DIR_4[ direction_id ]
		
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	DirectionChanged.emit( new_dir)
	
	if cardinal_direction == Vector2.LEFT:
		# Gunakan ukuran asli spritemu dengan minus untuk hadap kiri
		sprite.scale.x = -0.425
	else:
		# Kembalikan ke ukuran positif untuk hadap kanan/atas/bawah
		sprite.scale.x = 0.425
	
	return true


func UpdateAnimation( state : String ) -> void:
	animation_player.play( state + "_" + AnimDirection())
	pass

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
