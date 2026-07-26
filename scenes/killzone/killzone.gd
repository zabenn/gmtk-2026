class_name Killzone
extends Node2D

@onready var area2d: Area2D = %Area2D


func _ready():
	area2d.body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	body.pop()
