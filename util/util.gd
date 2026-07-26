class_name Util


static func elastic_bounce(
	collision_normal: Vector2, velocity1: Vector2, velocity2: Vector2
) -> Vector2:
	return velocity1 - 2 * (velocity1 - velocity2).dot(collision_normal) * collision_normal
