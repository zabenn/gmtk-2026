extends Area2D

signal you_died_signal
signal enemy_died_signal

func _ready():
	body_entered.connect(_on_killzone_body_entered)

func _on_killzone_body_entered(body):
	if body is Enemy:
		print("ENEMY")
		enemy_died_signal.emit()
#	if body is Player:
#		print("PLAYER")
#		you_died_signal.emit()
	body.queue_free()
