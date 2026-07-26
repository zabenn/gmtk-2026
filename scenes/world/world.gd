class_name World
extends Node2D

signal lost

var _level_scene: PackedScene = preload("res://scenes/level/level.tscn")

var _level: Level = null


func start() -> void:
	if _level:
		_level.queue_free()
	_level = _level_scene.instantiate()
	_level.lost.connect(_on_level_lost)
	add_child(_level)


func _on_level_lost() -> void:
	lost.emit()
