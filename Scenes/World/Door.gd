extends StaticBody2D

var is_open = false

# animation child
onready var animation = $AnimationPlayer
onready var openSound = $OpenSound
func _ready():
	if !is_open:
		animation.play("Closed")
	else:
		animation.play("Open")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Opening":
		if is_open:
			animation.play("Open")


func _on_TriggerZone_area_entered(_area):
	if is_open:
		return
	is_open = true
	
	animation.play("Opening")
	openSound.play()
