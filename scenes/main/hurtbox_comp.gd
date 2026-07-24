extends Area2D

@export var health_comp : HealthComponent

func damage(attack: EnemyAttack):
	if health_comp:
		health_comp.damage
