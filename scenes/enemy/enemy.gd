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

@onready var balloon_nub: BalloonNub = %BalloonNub
@onready var collision_shape: CollisionShape2D = %CollisionShape2D

var fully_spawned: bool = false

var _pop_scene: PackedScene = preload("res://scenes/pop/pop.tscn")


func _ready() -> void:
	scale = Vector2(0.1, 0.1)
	freeze = true
	collision_shape.disabled = true


func pop() -> void:
	var pop_effect: Pop = _pop_scene.instantiate()
	get_parent().add_child(pop_effect)
	pop_effect.global_position = global_position
	if target and target.has_method("add_bonus_time"):
		target.add_bonus_time(1.0)
	queue_free()


func _physics_process(delta: float) -> void:
	if not fully_spawned:
		scale += Vector2(delta, delta)
		if scale.x >= 1.0:
			scale = Vector2(1, 1)
			fully_spawned = true
			freeze = false
			collision_shape.disabled = false
		return
	if stunned:
		_stunned_time += delta
		if _stunned_time >= stun_duration:
			stunned = false


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if stunned:
		return
	var direction = global_position.direction_to(target.global_position)
	balloon_nub.rotation = direction.angle()
	state.apply_central_force(direction * acceleration)
	state.linear_velocity = (
		min(state.linear_velocity.length(), max_speed) * state.linear_velocity.normalized()
	)


func _set_stunned(_old_value: bool) -> void:
	_stunned_time = 0.0
