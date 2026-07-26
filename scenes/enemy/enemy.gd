extends CharacterBody2D
class_name Enemy
# @onready var player

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(get_viewport().get_mouse_position())
	velocity = direction * 300
	move_and_slide()
