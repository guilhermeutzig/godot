extends "res://resources/overlap/hitbox.gd"

@export var SPEED: int = 400

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta

func destroy():
	queue_free()

func _on_area_entered():
	destroy()

func _on_body_entered():
	destroy()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
