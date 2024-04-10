extends CharacterBody2D

signal hp_changed(new_hp)
signal hp_max_changed(new_hp_max)
signal died

@export var SPEED: int = 400
@export var defense: int = 5
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
		print(hp)
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

func _on_hurtbox_area_entered(hitbox):
	receive_damage(hitbox.damage)
	if (hitbox.is_in_group("Projectile")):
		hitbox.destroy()

func _on_died():
	die()
