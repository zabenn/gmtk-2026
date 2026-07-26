class_name Player
extends RigidBody2D

@export var max_speed: float = 300.0
@export var acceleration: float = 500.0
@export var friction: float = 1.0


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var direction = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	if direction != Vector2.ZERO:
		state.apply_central_force(direction * acceleration)
	else:
		state.apply_central_force(-state.linear_velocity * friction)
	state.linear_velocity = (
		min(state.linear_velocity.length(), max_speed) * state.linear_velocity.normalized()
	)
