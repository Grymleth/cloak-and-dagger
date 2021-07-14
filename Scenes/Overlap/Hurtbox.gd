extends Area2D

var invincible = false

onready var timer = $Timer
onready var collisionShape = $CollisionShape2D
		
func start_invincibility(duration):
	emit_signal("invincibility_started")
	invincible = true
	timer.start(duration)

signal invincibility_started
signal invincibility_ended

func create_hit_effect():
	# add hit effect?
	pass

func _on_Timer_timeout():
	emit_signal("invincibility_ended")
	invincible = false
	
func _on_Hurtbox_invincibility_started():
	# deactivate hurtbox
	collisionShape.set_deferred("disabled", true)

func _on_Hurtbox_invincibility_ended():
	# activate hurtbox
	collisionShape.disabled = false
