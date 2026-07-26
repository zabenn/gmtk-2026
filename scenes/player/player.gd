class_name Player
extends CharacterBody2D

@export var max_speed: float = 300.0
@export var acceleration: float = 500.0
@export var friction: float = 0.0
@export var restitution: float = 3.0

var _resolved_this_frame: bool = false

func _ready():
	$Sprite2D.modulate = Color(1.0, 0.0, 0.0, 1.0)

func _physics_process(delta: float) -> void:
	if _resolved_this_frame:
		_resolved_this_frame = false
		return

	var direction = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var collider = collision_info.get_collider()
		var normal = collision_info.get_normal()
		velocity = restitution * velocity.bounce(normal)
		collider.velocity = collider.restitution * collider.velocity.bounce(-normal)
		collider._resolved_this_frame = true
