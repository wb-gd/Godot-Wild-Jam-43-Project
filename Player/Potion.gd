extends KinematicBody2D

const UP_DIRECTION = Vector2.UP

export var speed := 3000.0

var _velocity = Vector2()

func _physics_process(delta):
	_velocity.x = speed * delta
	_velocity = move_and_slide(_velocity, UP_DIRECTION)
