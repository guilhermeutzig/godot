extends "res://resources/overlap/hitbox.gd"

@onready var melee_hit = $"."
@onready var melee_hit_collision = $CollisionShape2D
@onready var melee_hit_sprite = $Sprite2D
@onready var player_sprite = $"../AnimatedSprite2D"

func set_position_according_to_player_flip():
	if (player_sprite.flip_h):
		melee_hit_sprite.position = Vector2(-47, -4)
		melee_hit_sprite.rotation_degrees = -94
		melee_hit_collision.position = Vector2(-48, -1)
		melee_hit_collision.rotation_degrees = -50
	else:
		melee_hit_sprite.position = Vector2(49, 0)
		melee_hit_sprite.rotation_degrees = 0
		melee_hit_collision.position = Vector2(48, -1)
		melee_hit_collision.rotation_degrees = 50

func _on_attack_timer_timeout():
	melee_hit.visible = false
	melee_hit_collision.disabled = true

func _physics_process(delta):
	set_position_according_to_player_flip()
