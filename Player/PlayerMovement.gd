extends KinematicBody2D

const UP_DIRECTION = Vector2.UP

export(float) var speed = 600.0
export(float) var jumpStrength = 1500.0
export(int) var jumps = 2
export(float) var extraJumpStrength = 1200.0
export(float) var gravity = 4500.0

var _jumpsMade = 0
var _velocity = Vector2.ZERO

func _physics_process(delta) -> void:
	var _xDir = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	
	_velocity.x = _xDir * speed
	_velocity.y += gravity * delta
	
	var isFalling = _velocity.y > 0.0 and not is_on_floor()
	var isJumping = Input.is_action_just_pressed("jump") and is_on_floor()
	var isDoubleJumping = Input.is_action_just_pressed("jump") and isFalling
	var isJumpCancelled = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var isIdling = is_on_floor() and is_zero_approx(_velocity.x)
	var isRunning = is_on_floor() and not is_zero_approx(_velocity.x)
	
	if isJumping:
		_jumpsMade += 1
		_velocity.y = -jumpStrength
	elif isDoubleJumping:
		_jumpsMade += 1
		if _jumpsMade <= jumps:
			_velocity.y = -extraJumpStrength
	elif isJumpCancelled:
		_velocity.y = 0.0
	elif isIdling or isRunning:
		_jumpsMade = 0
	
	_velocity = move_and_slide(_velocity, UP_DIRECTION)
