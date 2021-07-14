extends KinematicBody2D

onready var anim = $AnimationPlayer

var motion = Vector2.ZERO
var speed = 64
var gravity = 200

func _ready():
	anim.play("Run")
func _physics_process(delta):
	motion.x = speed
	motion.y += gravity * delta
	motion = move_and_slide(motion, Vector2.UP)
