extends KinematicBody2D

# export vals
export var acceleration = 512
export var max_speed = 32
export var friction = 0.25
export var gravity = 200

var motion = Vector2.ZERO
var speed = max_speed
# airborne state used in motion calc
var is_airborne = false
var direction = Vector2.RIGHT

enum {
	IDLE,
	WANDER
}

var state = IDLE

#child nodes
onready var sprite = $Sprite
onready var animation = $AnimationPlayer
onready var raycast = $RoombaRaycast
onready var stats = $Stats

const DeathEffect = preload("res://Scenes/Effects/SlimeDeathEffect.tscn")

func _ready():
	randomize()
	raycast.cast_to = Vector2(0, 11)
	state = WANDER
	
func _physics_process(delta):
	match state:
		WANDER:
			wander_state(delta)
	
	motion.y += gravity * delta
	motion = move_and_slide(motion, Vector2.UP)
	
func wander_state(delta):
	if !raycast.is_colliding() or is_on_wall():
		stop_motion()
		
	animation.play("Move")
	travel_to_direction(direction, delta)
	
	sprite.flip_h = direction.x == 1

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func travel_to_direction(_direction, _delta):
	if !is_airborne:
		motion.x = 0
	else:
		motion.x = _direction.x * speed
	
func switch_direction():
	if direction == Vector2.LEFT:
		direction = Vector2.RIGHT
	else:
		direction = Vector2.LEFT
	
	raycast.position.x = (-1) * raycast.position.x
# airborne has to be 1 or 0 to be used in motion calc
func set_airborne_true():
	is_airborne = true
		
func set_airborne_false():
	is_airborne = false
	
func stop_motion():
	motion.x = 0
	speed = 0

func restart_motion():
	if speed == 0:
		switch_direction()
		speed = max_speed


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	# add knockback?
	# sound effect
	
func create_death_effect():
	var deathEffect = DeathEffect.instance()
	deathEffect.flip_h = sprite.flip_h
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position


func _on_Stats_no_health():
	create_death_effect()
	queue_free()
