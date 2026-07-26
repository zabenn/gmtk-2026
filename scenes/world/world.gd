class_name World
extends Node2D

signal lost
signal score_changed(points: int)

var _level_scene: PackedScene = preload("res://scenes/level/level.tscn")

var _level: Level = null


func start() -> void:
	if _level:
		_level.queue_free()
	_level = _level_scene.instantiate()
	_level.lost.connect(_on_level_lost)
	_level.score_changed.connect(_on_level_score_changed)
	add_child(_level)
	score_changed.emit(0)


func _on_level_lost() -> void:
	lost.emit()


func _on_level_score_changed(points: int) -> void:
	score_changed.emit(points)
