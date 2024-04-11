extends "res://resources/entities/entity_base.gd"

const DASH_SPEED = 1500
const DASH_LENGTH = .1
const JUMP_VELOCITY = -900.0

@export var DAGGER: PackedScene = preload("res://resources/projectiles/player_dagger.tscn")

@onready var melee_hit = $MeleeHit
@onready var melee_hit_collision = $MeleeHit/CollisionShape2D
@onready var melee_hit_timer = $AttackTimer
@onready var projectile_timer = $ProjectileTimer
@onready var player_animated_sprite = $AnimatedSprite2D
@onready var dash = $"../Dash"
@onready var player_base = $"."

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var can_dash = true
var dashing = false
var dash_direction = Vector2.ZERO
var facing

func throw_dagger():
	if (DAGGER):
		var dagger = DAGGER.instantiate()
		get_tree().current_scene.add_child(dagger)
		dagger.global_position = self.global_position
		var dagger_rotation = self.global_position.direction_to(get_global_mouse_position()).angle()
		dagger.rotation = dagger_rotation
		projectile_timer.start()

func attack():
	melee_hit.visible = true
	melee_hit_collision.disabled = false
	melee_hit_timer.start()
	# melee_hit scripts controls the destroy

func _physics_process(delta):
	var direction = Input.get_axis("left", "right")
	var speed = DASH_SPEED if dash.is_dashing() else SPEED
	velocity.y += gravity * delta
	
	# Handle jump.
	# if Input.is_action_just_pressed("jump") and is_on_floor():
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("primary_attack") and melee_hit_timer.is_stopped():
		attack()
	
	if Input.is_action_just_pressed("secondary_attack") and projectile_timer.is_stopped():
		throw_dagger()
		
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
