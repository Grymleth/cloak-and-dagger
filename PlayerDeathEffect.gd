extends AnimatedSprite

onready var deathSound = $PlayerDeathSound

signal player_death

func _ready():
	#ignore-warning:return_value_discarded
	connect("player_death", get_parent(), "player_death")
	deathSound.play()
	play("Animate")

func _on_PlayerDeathEffect_animation_finished():
	emit_signal("player_death")
	queue_free()
