class_name World
extends Node2D

@onready var enemy_spawn_timer: Timer = %EnemySpawnTimer
@onready var enemy_scene = preload("res://scenes/enemy/enemy.tscn")
@export var spawn_time := 5
@export var enemy_count := 20		#number of enemies to spawn
var enemy_death_count := 0

func _ready():
	enemy_spawn_timer.wait_time = spawn_time
	enemy_spawn_timer.timeout.connect(_on_timer_timeout)
	

func _on_timer_timeout():
	var enemy_spawnpoint = Vector2(randf_range(100, 1800), randf_range(100, 960))
	var enemy = enemy_scene.instantiate()
	#add a timer to spawn enemies with like a shadow to telegraph
	enemy.global_position = enemy_spawnpoint
	if enemy_count >= 0:
		add_child(enemy)
		enemy_count -= 1
	spawn_time = randf_range(0, 2)

func _enemy_death_counter():
	enemy_death_count += 1
