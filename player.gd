class_name Player
extends KinematicBody2D


const GRAVITY = 60

const GROUND_ACCEL = 150
const AIR_ACCEL = 50

const GROUND_MAX_SPEED = 150
const AIR_MAX_SPEED = 200

const GROUND_FRICTION = 0.9
const AIR_FRICTION = 0.99

const JUMP_IMPULSE = 100

var velocity = Vector2.ZERO
var init_pos

var last_on_ground = 0.0

func _ready():
	init_pos = global_position

func _physics_process(delta):
	var dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	if is_on_floor():
		velocity += Vector2.RIGHT * dir * GROUND_ACCEL * delta
		velocity.x *= GROUND_FRICTION
		velocity.x = clamp(velocity.x, -GROUND_MAX_SPEED, GROUND_MAX_SPEED)
	else:
		velocity += Vector2.RIGHT * dir * AIR_ACCEL * delta
		velocity.x *= AIR_FRICTION
		velocity.x = clamp(velocity.x, -AIR_MAX_SPEED, AIR_MAX_SPEED)
	
	velocity += Vector2.DOWN * GRAVITY * delta
	
	last_on_ground += delta
	if is_on_floor():
		last_on_ground = 0.0
	
	if Input.is_action_just_pressed("jump"):
		if last_on_ground < 5.0:
			velocity += Vector2.UP * JUMP_IMPULSE
			last_on_ground = INF
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if dir != 0:
		$Sprite.scale.x = sign(dir)
		$AnimationPlayer.play("Walk")
	else:
		$AnimationPlayer.play("RESET")

func kill():
	global_position = init_pos
	velocity = Vector2.ZERO
