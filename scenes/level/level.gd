class_name Level
extends Node2D

signal lost

@export var initial_spawn_time: float = 3.0
@export var min_spawn_time: float = 1.0
@export var ramp_duration: float = 60.0
@export var border_offset := 300

var points: int = 0

var _enemy_scene: PackedScene = preload("res://scenes/enemy/enemy.tscn")

var _spawn_timer: float = 0.0
var _elapsed_time: float = 0.0

@onready var player: Player = %Player


func _ready():
	_spawn_timer = 0.0
	_elapsed_time = 0.0
	player.popped.connect(_on_player_popped)


func _on_player_popped() -> void:
	lost.emit()


func _physics_process(delta: float) -> void:
	_elapsed_time += delta
	_spawn_timer += delta
	if (
		_spawn_timer
		>= lerp(initial_spawn_time, min_spawn_time, clamp(_elapsed_time / ramp_duration, 0.0, 1.0))
	):
		_spawn_timer = 0.0
		var enemy_spawnpoint = Vector2(
			randf_range(border_offset, get_viewport().get_visible_rect().size.x - border_offset),
			randf_range(border_offset, get_viewport().get_visible_rect().size.y - border_offset)
		)
		var enemy = _enemy_scene.instantiate()
		add_child(enemy)
		enemy.global_position = enemy_spawnpoint
		enemy.target = player
