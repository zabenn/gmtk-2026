extends Node2D

@export var collision_point_distance: float = 20.0
@export var visual_point_distance: float = 5.0
@export_range(0.0, 360.0, 0.1, "radians_as_degrees") var min_angle: float = PI / 4.0
@export_range(0.0, 360.0, 0.1, "radians_as_degrees") var max_angle: float = PI / 4.0
@export_range(0.0, 1000.0, 50.0) var min_radius: float = 100.0
@export_range(0.0, 1000.0, 50.0) var max_radius: float = 600.0
@export var damage_speed: float = 0.2
@export var visual_speed: float = 5.0
@export var min_end_damage_collision_fraction: float = 0.2
@export var attack_increase: float = -0.3
@export var min_force: float = 500.0
@export var max_force: float = 1000.0
@export var min_balloon_scale: float = 1.5
@export var max_balloon_scale: float = 0.3

var start_damage_collision_fraction: float = -1.0:
	set(value):
		var old_value: float = start_damage_collision_fraction
		if old_value == value:
			return
		start_damage_collision_fraction = value
		_set_start_damage_collision_fraction(old_value)
var end_damage_collision_fraction: float = -1.0:
	set(value):
		var old_value: float = end_damage_collision_fraction
		if old_value == value:
			return
		end_damage_collision_fraction = value
		_set_end_damage_collision_fraction(old_value)

var start_damage_visual_fraction: float = -1.0:
	set(value):
		var old_value: float = start_damage_visual_fraction
		if old_value == value:
			return
		start_damage_visual_fraction = value
		_set_start_damage_visual_fraction(old_value)
var end_damage_visual_fraction: float = -1.0:
	set(value):
		var old_value: float = end_damage_visual_fraction
		if old_value == value:
			return
		end_damage_visual_fraction = value
		_set_end_damage_visual_fraction(old_value)

var _start_damage_collision_points: PackedVector2Array = []
var _end_damage_collision_points: PackedVector2Array = []
var _start_damage_visual_points: PackedVector2Array = []
var _end_damage_visual_points: PackedVector2Array = []

@onready var area2d: Area2D = %Area2D
@onready var collision_polygon2d: CollisionPolygon2D = %CollisionPolygon2D
@onready var polygon2d: Polygon2D = %Polygon2D
@onready var balloon_nub: BalloonNub = %BalloonNub


func _ready() -> void:
	start_damage_collision_fraction = 0.0
	end_damage_collision_fraction = min_end_damage_collision_fraction
	start_damage_visual_fraction = start_damage_collision_fraction
	end_damage_visual_fraction = end_damage_collision_fraction


func _process(delta: float) -> void:
	start_damage_visual_fraction += _visual_towards_collision(
		start_damage_visual_fraction, start_damage_collision_fraction, delta
	)
	end_damage_visual_fraction += _visual_towards_collision(
		end_damage_visual_fraction, end_damage_collision_fraction, delta
	)
	balloon_nub.balloon.scale = (
		Vector2.ONE * lerp(min_balloon_scale, max_balloon_scale, end_damage_visual_fraction)
	)


func _physics_process(delta: float) -> void:
	rotation = global_position.angle_to_point(get_viewport().get_mouse_position())
	end_damage_collision_fraction = clamp(
		end_damage_collision_fraction + delta * damage_speed, min_end_damage_collision_fraction, 1.0
	)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_blow"):
		for body in area2d.get_overlapping_bodies():
			print(body)
			if body is Enemy:
				var enemy: Enemy = body
				enemy.stunned = true
				enemy.apply_central_impulse(
					(
						lerp(
							min_force,
							max_force,
							inverse_lerp(
								min_radius,
								max_radius,
								global_position.distance_to(enemy.global_position)
							)
						)
						* global_position.direction_to(enemy.global_position)
					)
				)


func _visual_towards_collision(
	visual_fraction: float, collision_fraction: float, delta: float
) -> float:
	return (
		delta
		* sign(collision_fraction - visual_fraction)
		* clamp(abs(collision_fraction - visual_fraction) * visual_speed, damage_speed, INF)
	)


func _arc_points(
	radius: float,
	start_angle: float,
	end_angle: float,
	point_distance: float,
	center_point: Vector2 = Vector2.ZERO
) -> PackedVector2Array:
	var arc_length: float = abs(end_angle - start_angle) * radius
	var num_points: int = max(2, int(arc_length / point_distance))
	var points: PackedVector2Array = []
	for i in range(num_points):
		var angle: float = lerp(
			start_angle, end_angle, inverse_lerp(0.0, float(num_points - 1), float(i))
		)
		var point: Vector2 = center_point + Vector2(cos(angle), sin(angle)) * radius
		points.append(point)
	return points


func _sync_polygon_shape() -> void:
	if _start_damage_visual_points.is_empty() or _end_damage_visual_points.is_empty():
		return
	polygon2d.polygon = _start_damage_visual_points + _end_damage_visual_points


func _sync_collision_shape() -> void:
	if _start_damage_collision_points.is_empty() or _end_damage_collision_points.is_empty():
		return
	collision_polygon2d.polygon = (_start_damage_collision_points + _end_damage_collision_points)


func _set_start_damage_collision_fraction(_old_value: float) -> void:
	var angle: float = lerp(min_angle, max_angle, start_damage_collision_fraction)
	_start_damage_collision_points = _arc_points(
		lerp(min_radius, max_radius, start_damage_collision_fraction),
		-angle / 2.0,
		angle / 2.0,
		collision_point_distance
	)
	_sync_collision_shape()


func _set_end_damage_collision_fraction(_old_value: float) -> void:
	var angle: float = lerp(min_angle, max_angle, end_damage_collision_fraction)
	_end_damage_collision_points = _arc_points(
		lerp(min_radius, max_radius, end_damage_collision_fraction),
		angle / 2.0,
		-angle / 2.0,
		collision_point_distance
	)
	_sync_collision_shape()


func _set_start_damage_visual_fraction(_old_value: float) -> void:
	var angle: float = lerp(min_angle, max_angle, start_damage_visual_fraction)
	_start_damage_visual_points = _arc_points(
		lerp(min_radius, max_radius, start_damage_visual_fraction),
		-angle / 2.0,
		angle / 2.0,
		visual_point_distance
	)
	_sync_polygon_shape()


func _set_end_damage_visual_fraction(_old_value: float) -> void:
	var angle: float = lerp(min_angle, max_angle, end_damage_visual_fraction)
	_end_damage_visual_points = _arc_points(
		lerp(min_radius, max_radius, end_damage_visual_fraction),
		angle / 2.0,
		-angle / 2.0,
		visual_point_distance
	)
	_sync_polygon_shape()
