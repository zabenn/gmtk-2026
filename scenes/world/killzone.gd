extends Area2D

func _ready():
	body_entered.connect(_on_killzone_body_entered)

func _on_killzone_body_entered(body):
	if body is Enemy:
		#print("ENEMY")
		SignalBus.enemy_died_signal.emit()
	if body is Player:
#		print("PLAYER")
		Engine.time_scale = 0.5
		SignalBus.you_died_signal.emit()
	body.queue_free()
