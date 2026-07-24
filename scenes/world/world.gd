class_name World
extends Node2D

@onready var enemy_spawn_timer: Timer = %EnemySpawnTimer
@onready var enemy_scene = preload("res://scenes/main/enemy.tscn")
@export var spawn_time := 5

func _ready():
	enemy_spawn_timer.wait_time = spawn_time
	enemy_spawn_timer.timeout.connect(_on_timer_timeout)
	
func _on_timer_timeout():
	var enemy_spawnpoint = Vector2(randf_range(10,100),randf_range(10,100))
	var enemy = enemy_scene.instantiate()
	enemy.global_position = enemy_spawnpoint
	add_child(enemy)
