class_name Enemy
extends CharacterBody2D

@export var force: float = 200.0
@export var max_speed: float = 300.0
@export var acceleration: float = 500.0
@export var friction: float = 0.0
@export var restitution: float = 1.0
var target: Player = null

var _resolved_this_frame: bool = false

var fully_spawned: bool = false

func _ready() -> void:
	SignalBus.you_died_signal.connect(_game_over)
	scale = Vector2(0.1,0.1)

func _game_over() -> void:
	queue_free()	#delete the enemy so it doesnt crash game when player dies

func _physics_process(delta: float) -> void:
	if fully_spawned == false:
		scale += Vector2(delta,delta)
		if scale >= Vector2(1,1):
			fully_spawned = true
			scale = Vector2(1,1)
	if fully_spawned == true:
		if _resolved_this_frame:
			_resolved_this_frame = false
			return

		var direction = global_position.direction_to(target.global_position)
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
