class_name World
extends Node2D

var _enemy_scene: PackedScene = preload("res://scenes/enemy/enemy.tscn")

@onready var player: Player = %Player
@onready var enemy_spawn_timer: Timer = %EnemySpawnTimer
@onready var enemy_scene = preload("res://scenes/enemy/enemy.tscn")
@export var spawn_time: float = 5
@export var enemy_count := 20		#number of enemies to spawn
@export var border_offset := 300	#number of pixels to offset enemy spawn for killzone
var enemy_death_count := 0
var screen_width = DisplayServer.window_get_size()[1]
var screen_length = DisplayServer.window_get_size()[0]

func _ready():
	enemy_spawn_timer.wait_time = spawn_time
	enemy_spawn_timer.timeout.connect(_on_timer_timeout)
	SignalBus.game_start_signal.connect(_game_start)
	
func _game_start():
	enemy_spawn_timer.start()

func _on_timer_timeout():
	var enemy_spawnpoint = Vector2(randf_range(border_offset, screen_length-border_offset), randf_range(border_offset, screen_width-border_offset))
	var enemy = enemy_scene.instantiate()
	#add a timer to spawn enemies with like a shadow to telegraph
	enemy.global_position = enemy_spawnpoint
	if enemy_count >= 0:
		add_child(enemy)
		enemy.target = player
		enemy_count -= 1
	spawn_time = randf_range(0, 2)

func _enemy_death_counter():
	enemy_death_count += 1
