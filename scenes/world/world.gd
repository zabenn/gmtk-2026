class_name World
extends Node2D

@export var spawn_time: float = 5

var _enemy_scene: PackedScene = preload("res://scenes/enemy/enemy.tscn")

@onready var player: Player = %Player
@onready var enemy_spawn_timer: Timer = %EnemySpawnTimer


func _ready():
	enemy_spawn_timer.wait_time = spawn_time
	enemy_spawn_timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout():
	var enemy = _enemy_scene.instantiate()
	enemy.global_position = Vector2(randf_range(100, 1800), randf_range(100, 960))
	enemy.target = player
	add_child(enemy)
