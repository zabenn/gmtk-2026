class_name Interface
extends Control

@onready var quit_button: Button = %QuitButton
@onready var retry_button: Button = %RetryButton
@onready var game_over_menu: PanelContainer = %GameOverMenu
@onready var start_menu: PanelContainer = %StartMenu

signal start_game_signal

func _ready():
	game_over_menu.hide()
	quit_button.pressed.connect(_quit_button_pressed)
	retry_button.pressed.connect(_retry_button_pressed)
	
func _player_died():
	game_over_menu.show()
	
func _retry_button_pressed():
	get_tree().reload_current_scene()

func _quit_button_pressed():
	get_tree().quit()

#func _input(event):
#	if event is InputEventKey and event.pressed():

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		start_game_signal.emit()
		start_menu.hide()
