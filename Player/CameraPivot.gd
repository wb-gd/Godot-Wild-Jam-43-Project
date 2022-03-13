extends Position2D

onready var _startScale := scale
onready var _parent: KinematicBody2D = $'..'

func _physics_process(delta):
	update_pivot_angle()

func update_pivot_angle():
	scale = _startScale * _parent._direction
