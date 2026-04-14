class_name Enemy extends CharacterBody2D

signal direction_changed( new_direction : Vector2 )
signal enemy_damaged()

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

@export var hp : int = 3

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player : Player
var Invulnerable : bool = false

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
##@onready var hit_box : HitBox = %Hitbox
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.initialize( self )
	player = PlayerManager.player
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(_delta):
	move_and_slide()

func set_direction( _new_direction : Vector2 ) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO :
		return false
	
	var direction_id : int = int ( round( 
			( direction + cardinal_direction * 0.1 ).angle()
			/ TAU * DIR_4.size()
	))
	var new_dir = DIR_4[ direction_id ]
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	direction_changed.emit( new_dir )
	
	# --- PERBAIKAN BUG ANIMASI MELAR DI SINI ---
	# Menggunakan flip_h agar ukuran asli (scale) di Inspector tidak rusak
	if cardinal_direction == Vector2.LEFT:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	# -------------------------------------------
	
	return true

func update_animation( state : String ) -> void:
	animation_player.play( state + "_" + anim_direction() )
	pass

func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
