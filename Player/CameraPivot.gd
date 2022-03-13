extends Position2D

onready var _startScale := scale
onready var _parent: KinematicBody2D = $'..'
onready var _offsetNode = $CameraOffset
onready var _offsetStart: Vector2 = _offsetNode.position

func _physics_process(delta):
	update_pivot_angle()

func update_pivot_angle():
	if is_zero_approx(_parent._velocity.x):
		_offsetNode.position.x = 0
	else:
		_offsetNode.position = _offsetStart
	
	scale = _startScale * _parent._direction
