extends "res://Scripts/Hitbox.gd"

onready var animation = $AnimationPlayer
onready var sprite = $Sprite

var is_face_left = true

func _ready():
	if is_face_left:
		animation.play("SwordLeft")
	else:
		animation.play("SwordRight")


func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
	
func flip_sprite(_is_face_left):
	is_face_left = _is_face_left
