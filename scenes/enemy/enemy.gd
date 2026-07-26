class_name Enemy
extends RigidBody2D

@export var max_speed: float = 300.0
@export var acceleration: float = 500.0
@export var friction: float = 0.0
@export var stun_duration: float = 0.5

var stunned: bool = false:
	set(value):
		var old_value: bool = stunned
		if old_value == value:
			return
		stunned = value
		_set_stunned(old_value)

var target: Node2D = null

var _stunned_time: float = 0.0


func _physics_process(delta: float) -> void:
	if stunned:
		_stunned_time += delta
		if _stunned_time >= stun_duration:
			stunned = false


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if stunned:
		return
	var direction = global_position.direction_to(target.global_position)
	state.apply_central_force(direction * acceleration)
	state.linear_velocity = (
		min(state.linear_velocity.length(), max_speed) * state.linear_velocity.normalized()
	)


func _set_stunned(_old_value: bool) -> void:
	_stunned_time = 0.0
