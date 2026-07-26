class_name Main
extends Node

@onready var world: World = %World
@onready var interface: Interface = %Interface


func _ready():
	interface.tutorial_menu.start_button.pressed.connect(_on_tutorial_menu_start_button_pressed)
	interface.lose_menu.start_button.pressed.connect(_on_lose_menu_start_button_pressed)
	world.lost.connect(_on_world_lost)
	world.score_changed.connect(_on_world_score_changed)


func _on_tutorial_menu_start_button_pressed():
	print("hi")
	world.start()


func _on_lose_menu_start_button_pressed():
	world.start()


func _on_world_lost():
	interface.game_menu.hide()
	interface.lose_menu.show()


func _on_world_score_changed(points: int):
	interface.game_menu.update_score(points)
