extends KinematicBody2D

const UP_DIRECTION = Vector2.UP

export var speed := 600.0
export var jumpStrength := 1500.0
export var jumps := 2
export var extraJumpStrength := 1200.0
export var gravity := 4500.0

var _jumpsMade := 0
var _velocity := Vector2.ZERO
var _direction := 1.0
var _attackAnimOver := true

onready var _pivot: Node2D = $PlayerSkin
onready var _animPlayer: AnimationPlayer = $PlayerSkin/polygons2/AnimationPlayer
onready var _startScale: Vector2 = _pivot.scale
onready var _attackTimer: Timer = $AttackTimer

func _physics_process(delta) -> void:
	var _xDir := (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	
	_velocity.x = _xDir * speed
	_velocity.y += gravity * delta
	
	var isAirborn := _velocity.y < 0.0 and not is_on_floor()
	var isFalling := _velocity.y > 0.0 and not is_on_floor()
	var isJumping := Input.is_action_just_pressed("jump") and is_on_floor()
	var isDoubleJumping := Input.is_action_just_pressed("jump") and (isFalling or isAirborn)
	var isJumpCancelled := Input.is_action_just_released("jump") and isAirborn
	var isIdling := is_on_floor() and is_zero_approx(_velocity.x)
	var isRunning := is_on_floor() and not is_zero_approx(_velocity.x)
	var isTakingDamage := false
	var isAttacking := Input.is_action_just_pressed("attack") and _attackAnimOver

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
	
	if not is_zero_approx(_velocity.x):
		_pivot.scale.x = sign(_velocity.x) * _startScale.x * -1.0
		_direction = sign(_velocity.x) * 1.0
	
	if not isTakingDamage:
		if _attackAnimOver:
			if isAttacking:
				_attackAnimOver = false
				_attackTimer.start()
				_animPlayer.play("throw")
			elif isJumping or isDoubleJumping:
				_animPlayer.play("jump")
			elif isRunning:
				_animPlayer.play("walk")
			elif isAirborn:
				_animPlayer.play("jump")
			elif isFalling:
				_animPlayer.play("fall")
			elif isIdling:
				_animPlayer.play("idle")
		


func _on_AttackTimer_timeout():
	_attackAnimOver = true
