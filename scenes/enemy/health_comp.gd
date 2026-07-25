extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 10

var health: float

signal i_died_signal


func _ready():
	health = MAX_HEALTH
