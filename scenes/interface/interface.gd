class_name Interface
extends Control

@onready var quit_button: Button = %QuitButton
@onready var retry_button: Button = %RetryButton
@onready var game_over_menu: PanelContainer = %GameOverMenu
@onready var start_menu: PanelContainer = %StartMenu


func _ready():
	game_over_menu.hide()
	quit_button.pressed.connect(_quit_button_pressed)
	retry_button.pressed.connect(_retry_button_pressed)
	SignalBus.you_died_signal.connect(_player_died)
	
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
		SignalBus.game_start_signal.emit()
		start_menu.hide()
		
