class_name Main
extends Node

@onready var world: World = %World
@onready var interface: Interface = %Interface

func ready():
	pass

func _on_hitbox_comp_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

func _player_died():
	pass
