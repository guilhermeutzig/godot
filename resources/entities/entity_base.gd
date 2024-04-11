extends CharacterBody2D

signal hp_changed(new_hp)
signal hp_max_changed(new_hp_max)
signal died

@export var SPEED: int = 400
@export var defense: int = 5
@export var receives_knockback: bool = true
@export var knockback_modifier: float = 10

@export var hp_max: int = 100 :
	get:
		return hp_max
	set(value):
		if (value != hp_max):
			hp_max = max(0, value)
			emit_signal("hp_max_changed", hp_max)
			self.hp = hp

@export var hp: int = hp_max :
	get:
		return hp
	set(value):
		hp = clamp(value, 0, 100)
		emit_signal("hp_changed", value)
		if (hp == 0):
			emit_signal("died")

@onready var sprite = $Sprite2D
@onready var collShape = $CollisionShape2D
@onready var animPlayer = $AnimationPlayer
@onready var hurtbox = $Hurtbox

func die():
	queue_free()

func receive_damage(base_damage: int):
	var actual_damage = base_damage
	actual_damage -= defense
	self.hp -= actual_damage
	return actual_damage
	
func receive_knockback(damage_source_pos: Vector2, received_damage: int):
	if (receives_knockback):
		var knockback_direction = damage_source_pos.direction_to(self.global_position)
		var knockback_strength = received_damage * knockback_modifier
		var knockback = knockback_direction * knockback_strength
		global_position += knockback

func _on_hurtbox_area_entered(body):
	var actual_damage = receive_damage(body.damage)
	
	if (body.is_in_group("Projectile")):
		body.destroy()
	
	receive_knockback(body.global_position, actual_damage)
	

func _on_died():
	die()
