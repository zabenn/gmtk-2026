class_name GameMenu
extends Control

@onready var score_text: RichTextLabel = %ScoreText


func update_score(points: int) -> void:
	score_text.text = str(points)
