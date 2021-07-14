extends Node2D

const playerStats = PlayerStats
const menu_scene = "res://Menu.tscn"

onready var player = $Player
onready var gui = $GUI

func game_over():
	print("game over")
	gui.show_message("Game Over")
	yield(get_tree().create_timer(2.0), "timeout")
	main_menu()
	
func player_death():
	gui.show_message("You Died")
	yield(get_tree().create_timer(2.0), "timeout")
	main_menu()

func main_menu():
	#ignore-warning:return_value_discarded
	get_tree().change_scene(menu_scene)
	playerStats.reset_stats()


func _on_EndZone_body_entered(body):
	player.controllable = false
	game_over()
