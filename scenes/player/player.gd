class_name Player
extends RigidBody2D

signal popped

@export var max_speed: float = 300.0
@export var acceleration: float = 600.0
@export var friction: float = 1.0

var _pop_scene: PackedScene = preload("res://scenes/pop/pop.tscn")

var _popped: bool = false

@onready var blast: Blast = %Blast


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if _popped:
		return
	var direction = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	if direction != Vector2.ZERO:
		state.apply_central_force(direction * acceleration)
	else:
		state.apply_central_force(-state.linear_velocity * friction)
	state.linear_velocity = (
		min(state.linear_velocity.length(), max_speed) * state.linear_velocity.normalized()
	)


func add_bonus_time(amount: float) -> void:
	blast.add_time(amount)


func pop() -> void:
	if _popped:
		return
	_popped = true
	freeze = true
	blast.hide()
	var pop_effect: Pop = _pop_scene.instantiate()
	get_parent().add_child(pop_effect)
	pop_effect.global_position = global_position
	await get_tree().create_timer(0.5).timeout
	popped.emit()
