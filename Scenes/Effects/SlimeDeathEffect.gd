extends AnimatedSprite

onready var deathSound = $DeathSound
func _ready():
	play("Animate")
	
	deathSound.play()

func _on_SlimeDeathEffect_animation_finished():
	queue_free()
