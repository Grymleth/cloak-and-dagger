extends KinematicBody2D

export var acceleration = 512
export var max_speed = 64
export var friction = 0.25
export var air_resist = 0.02
export var gravity = 200
export var jump_force = 128
export var attack_cooldown = 1
export var knockback_force = 32
export var knockback_duration = 0.6
export var invincibility_duration = 1

# this is the downward force applied by move and slide
# i dont know how to get rid of this
const normal_force = 3.333333

onready var sprite = $Sprite
onready var animation = $AnimationPlayer
onready var blinkAnimation = $BlinkAnimation
onready var hurtbox = $Hurtbox
const SwordEffect = preload("res://Scenes/Effects/SwordEffect.tscn")
const DeathEffect = preload("res://Scenes/Effects/PlayerDeathEffect.tscn")

#sound effects
onready var jumpSound = $JumpSound 
onready var hurtSound = $HurtSound

# timers
onready var knockbackTimer = $KnockbackTimer

enum {
	MOTION,
	ATTACK,
	KNOCKBACK
}

# animation state
var state = MOTION

# state vars
var motion = Vector2.ZERO
onready var is_on_floor = is_on_floor()
var controllable = true setget set_controllable

# player stats
var stats = PlayerStats


func _ready():
	stats.connect("no_health", self, "trigger_death")
	print("health is: ", stats.health)

func _physics_process(delta):
	if controllable:
		var x_input = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
		
		# put is_on_floor() into global var
		# so we dont have to call it twice
		is_on_floor = is_on_floor()
		
		# finish knockback state
		# movement func
		set_motion(x_input, delta)
		if Input.is_action_just_pressed("attack") and \
			animation.get_current_animation() != "Attack" and \
			state != KNOCKBACK:
			state = ATTACK
			create_sword_effect()

		# choose animation
		match state:
			MOTION:
				# animation state machine
				set_motion_animation(x_input)
			ATTACK:
				animation.play("Attack") 
			KNOCKBACK:
				animation.play("Hit")
				
	motion = move_and_slide(motion, Vector2.UP)
		
	
	
func set_motion(x_input, delta):
	# if state is knockback then move player in constant force
	# this means no movement calc is made
	# the force of the knockback is set in a signal
	if state != KNOCKBACK:
		if x_input != 0:
			motion.x += x_input * acceleration * delta
			motion.x = clamp(motion.x, -max_speed, max_speed)
				
		if is_on_floor:
			if x_input == 0:
				motion.x = lerp(motion.x, 0, friction)
			if Input.is_action_just_pressed("jump"):
				jumpSound.play()
				motion.y = -jump_force
		else:
			if Input.is_action_just_released("jump") and motion.y < -jump_force/2:
				motion.y = -jump_force / 2
			if x_input == 0:
				motion.x = lerp(motion.x, 0, air_resist)
		# when state is motion, the sprite faces the direction of the motion vector
		sprite.flip_h = motion.x < 0
	else:
		# when state is knockback, the sprite faces the opposite of the motion vector
		sprite.flip_h = motion.x > 0
		# finish knockback state
			
	
	# gravity apply
	motion.y += gravity * delta

# returns the animation state based on motion
func set_motion_animation(input):
	
	if !is_on_floor:
		# normal_force is the threshold that decides jump up or jump down animation
		# we cant use 0 because move_and_slide() applies constant down force
		if motion.y > normal_force:
			animation.play("JumpDown")
		else:
			animation.play("JumpUp")
	else:
		if input != 0:
			animation.play("Run")
		else:
			animation.play("Idle")
	
	return state

func finish_attack():
	set_state(MOTION)
	
func finish_knockback():
	set_state(MOTION)
	
func set_state(_state):
	state = _state
	
func trigger_death():
	create_death_effect()
	queue_free()
	
func create_sword_effect():
	var swordEffect = SwordEffect.instance()
	
	var is_face_left = sprite.flip_h
	var offset = 0
	swordEffect.flip_sprite(is_face_left)
	if is_face_left:
		offset = -16
	else:
		offset = 16
	
	swordEffect.position = Vector2(offset, 0)
	
	add_child(swordEffect)
	
func create_death_effect():
	var deathEffect = DeathEffect.instance()
	deathEffect.flip_h = sprite.flip_h
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position
	
func set_controllable(value):
	controllable = value


func _on_Hurtbox_area_entered(area):
	state = KNOCKBACK
	# if other area2d is to left of the player the vector points right
	# and vice versa
	var x_direction = 0
	if global_position.x > area.global_position.x:
		x_direction = 1
	else:
		x_direction = -1
	motion = Vector2(x_direction, -1).normalized() * knockback_force
	
	# update health in player stats
	stats.health -= area.damage
	
	# start invincibility
	hurtbox.start_invincibility(invincibility_duration)
	
	# sound effect
	hurtSound.play()
	
	# start knockback state
	knockbackTimer.start(knockback_duration)


func _on_Hurtbox_invincibility_ended():
	#play blinking
	blinkAnimation.play("Stop")


func _on_Hurtbox_invincibility_started():
	blinkAnimation.play("Start")


func _on_KnockBackTimer_timeout():
	# finish knockback state
	finish_knockback()
