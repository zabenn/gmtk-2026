class_name Player
extends RigidBody2D

@export var max_speed: float = 300.0
@export var acceleration: float = 500.0
@export var friction: float = 1.0

var _resolved_this_frame: bool = false

func _ready():
	$Sprite2D.modulate = Color(1.0, 0.0, 0.0, 1.0)

func _physics_process(delta: float) -> void:
	if _resolved_this_frame:
		_resolved_this_frame = false
		return

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var direction = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	if direction != Vector2.ZERO:
		state.apply_central_force(direction * acceleration)
	else:
		state.apply_central_force(-state.linear_velocity * friction)
	state.linear_velocity = (
		min(state.linear_velocity.length(), max_speed) * state.linear_velocity.normalized()
	)
