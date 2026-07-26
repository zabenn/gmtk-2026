class_name Interface
extends Control

@onready var start_menu: StartMenu = %StartMenu
@onready var tutorial_menu: TutorialMenu = %TutorialMenu
@onready var game_menu: GameMenu = %GameMenu
@onready var lose_menu: LoseMenu = %LoseMenu


func _ready():
	start_menu.start_button.pressed.connect(_on_start_menu_start_button_pressed)
	tutorial_menu.start_button.pressed.connect(_on_tutorial_menu_start_button_pressed)
	lose_menu.start_button.pressed.connect(_on_lose_menu_start_button_pressed)


func _on_start_menu_start_button_pressed():
	start_menu.hide()
	tutorial_menu.show()


func _on_tutorial_menu_start_button_pressed():
	tutorial_menu.hide()
	game_menu.show()


func _on_lose_menu_start_button_pressed():
	lose_menu.hide()
	game_menu.show()
