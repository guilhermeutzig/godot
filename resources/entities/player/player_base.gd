extends "res://resources/entities/entity_base.gd"

const DASH_SPEED = 1500
const DASH_LENGTH = .1
const JUMP_VELOCITY = -900.0

@onready var player_animated_sprite = $AnimatedSprite2D
@onready var dash = $"../Dash"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var can_dash = true
var dashing = false
var dash_direction = Vector2.ZERO
var facing

func _physics_process(delta):
	var direction = Input.get_axis("left", "right")
	var speed = DASH_SPEED if dash.is_dashing() else SPEED
	velocity.y += gravity * delta
	
	# Handle jump.
	# if Input.is_action_just_pressed("jump") and is_on_floor():
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		
	
	# Handle dash
	if Input.is_action_just_pressed("dash"):
		dash.start_dash(DASH_LENGTH)
	
	if direction:
		var isRight = velocity.x >= 0
		velocity.x = direction * speed
		dash_direction = Vector2(1, 0) if isRight else Vector2(-1,0)
		facing = "right" if isRight else "left"
		player_animated_sprite.flip_h = false if isRight else true
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide()
