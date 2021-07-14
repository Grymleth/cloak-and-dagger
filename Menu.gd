extends Control

# path to game scene
const gameScene = "res://Game.tscn"

onready var buttonSound = $ButtonSound

func _on_Button_pressed():
	buttonSound.play()
	yield(buttonSound, "finished")
	
	#ignore-warning:return_value_discarded
	get_tree().change_scene(gameScene)
